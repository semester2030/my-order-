import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan, MoreThan } from 'typeorm';
import { JobOffer, JobStatus } from './entities/job-offer.entity';
import { Order, OrderStatus } from '../orders/entities/order.entity';
import { Driver } from '../drivers/entities/driver.entity';
import { DriversService } from '../drivers/drivers.service';
import { DriverNotificationsService } from '../notifications/driver/driver-notifications.service';

@Injectable()
export class JobsService {
  constructor(
    @InjectRepository(JobOffer)
    private readonly jobOfferRepository: Repository<JobOffer>,
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
    private readonly driversService: DriversService,
    private readonly driverNotificationsService: DriverNotificationsService,
  ) {}

  /**
   * Get available jobs (inbox) for drivers
   */
  async getInbox(driverId: string) {
    // Get driver to check location
    const driver = await this.driversService.getDriverByUserId(driverId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    if (driver.status !== 'approved') {
      throw new BadRequestException('Driver not approved');
    }

    // Get pending jobs that haven't expired
    const jobs = await this.jobOfferRepository.find({
      where: {
        status: JobStatus.PENDING,
        expiresAt: MoreThan(new Date()), // Not expired
      },
      relations: ['order', 'order.vendor', 'order.address'],
      order: { createdAt: 'DESC' },
    });

    // Filter jobs based on driver location (if available)
    // TODO: Add distance calculation and filtering

    return jobs.map((job) => ({
      id: job.id,
      orderId: job.orderId,
      orderNumber: job.order.orderNumber,
      deliveryFee: job.deliveryFee,
      driverEarnings: job.driverEarnings,
      estimatedDistance: job.estimatedDistance,
      estimatedDuration: job.estimatedDuration,
      pickupLocation: {
        latitude: job.pickupLatitude,
        longitude: job.pickupLongitude,
      },
      deliveryLocation: {
        latitude: job.deliveryLatitude,
        longitude: job.deliveryLongitude,
      },
      expiresAt: job.expiresAt,
      createdAt: job.createdAt,
    }));
  }

  /**
   * Get active job for driver
   */
  async getActiveJob(driverId: string) {
    const driver = await this.driversService.getDriverByUserId(driverId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    const job = await this.jobOfferRepository.findOne({
      where: {
        acceptedByDriverId: driver.id,
        status: JobStatus.ACCEPTED,
      },
      relations: ['order', 'order.vendor', 'order.address', 'order.items'],
      order: { createdAt: 'DESC' },
    });

    if (!job || job.order.status === OrderStatus.DELIVERED) {
      return null;
    }

    return {
      id: job.id,
      orderId: job.orderId,
      orderNumber: job.order.orderNumber,
      orderStatus: job.order.status,
      deliveryFee: job.deliveryFee,
      driverEarnings: job.driverEarnings,
      estimatedDistance: job.estimatedDistance,
      estimatedDuration: job.estimatedDuration,
      pickupLocation: {
        latitude: job.pickupLatitude,
        longitude: job.pickupLongitude,
      },
      deliveryLocation: {
        latitude: job.deliveryLatitude,
        longitude: job.deliveryLongitude,
      },
      order: {
        id: job.order.id,
        orderNumber: job.order.orderNumber,
        status: job.order.status,
        total: job.order.total,
        vendor: {
          id: job.order.vendor.id,
          name: job.order.vendor.name,
          address: job.order.vendor.address,
        },
        address: {
          streetAddress: job.order.address.streetAddress,
          city: job.order.address.city,
          district: job.order.address.district,
        },
        items: job.order.items,
      },
      acceptedAt: job.acceptedAt,
    };
  }

  /**
   * Accept job
   */
  async acceptJob(jobOfferId: string, driverId: string) {
    const driver = await this.driversService.getDriverByUserId(driverId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    if (driver.status !== 'approved') {
      throw new BadRequestException('Driver not approved');
    }

    if (!driver.isOnline) {
      throw new BadRequestException('Driver must be online to accept jobs');
    }

    const job = await this.jobOfferRepository.findOne({
      where: { id: jobOfferId },
      relations: ['order', 'order.vendor', 'order.address'],
    });

    if (!job) {
      throw new NotFoundException('Job not found');
    }

    if (job.status !== JobStatus.PENDING) {
      throw new ConflictException(`Job is ${job.status}. Cannot accept.`);
    }

    if (job.expiresAt < new Date()) {
      throw new BadRequestException('Job has expired');
    }

    // Check if driver already has an active job
    const activeJob = await this.getActiveJob(driverId);
    if (activeJob) {
      throw new ConflictException('Driver already has an active job');
    }

    // Accept job
    job.status = JobStatus.ACCEPTED;
    job.acceptedByDriverId = driver.id;
    job.acceptedAt = new Date();

    await this.jobOfferRepository.save(job);

    // Update order status
    const order = job.order;
    order.status = OrderStatus.OUT_FOR_DELIVERY;
    order.driverId = driver.id;
    await this.orderRepository.save(order);

    // Send confirmation notification to driver
    await this.driverNotificationsService.sendDeliveryUpdateNotification(
      driver.id,
      job.order.orderNumber,
      'accepted',
    );

    return {
      jobId: job.id,
      orderId: job.orderId,
      status: job.status,
      message: 'Job accepted successfully',
    };
  }

  /**
   * Reject job
   */
  async rejectJob(jobOfferId: string, driverId: string) {
    const driver = await this.driversService.getDriverByUserId(driverId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    const job = await this.jobOfferRepository.findOne({
      where: { id: jobOfferId },
    });

    if (!job) {
      throw new NotFoundException('Job not found');
    }

    if (job.status !== JobStatus.PENDING) {
      throw new ConflictException(`Job is ${job.status}. Cannot reject.`);
    }

    // Mark as rejected (but keep it available for other drivers)
    // Or we can just leave it as PENDING for other drivers
    job.rejectedAt = new Date();

    await this.jobOfferRepository.save(job);

    return {
      jobId: job.id,
      message: 'Job rejected',
    };
  }

  /**
   * Create job offer from order (called when order is ready)
   */
  async createJobOfferFromOrder(orderId: string) {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['vendor', 'address'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    // Check if job already exists
    const existingJob = await this.jobOfferRepository.findOne({
      where: { orderId },
    });

    if (existingJob) {
      throw new ConflictException('Job offer already exists for this order');
    }

    // Calculate delivery fee and driver earnings
    // TODO: Implement proper calculation based on distance, etc.
    const deliveryFee = order.deliveryFee;
    const driverEarnings = deliveryFee * 0.8; // 80% to driver (example)

    // Calculate distance and duration
    // TODO: Use Google Maps API or similar
    const estimatedDistance = 5.0; // km (placeholder)
    const estimatedDuration = 15; // minutes (placeholder)

    // Create job offer
    const jobOffer = this.jobOfferRepository.create({
      orderId: order.id,
      status: JobStatus.PENDING,
      deliveryFee,
      driverEarnings,
      pickupLatitude: order.vendor.latitude,
      pickupLongitude: order.vendor.longitude,
      deliveryLatitude: order.address.latitude,
      deliveryLongitude: order.address.longitude,
      estimatedDistance,
      estimatedDuration,
      expiresAt: new Date(Date.now() + 10 * 60 * 1000), // 10 minutes
      order: order,
    });

    await this.jobOfferRepository.save(jobOffer);

    // Load order relation for notification
    const jobWithOrder = await this.jobOfferRepository.findOne({
      where: { id: jobOffer.id },
      relations: ['order', 'order.vendor', 'order.address'],
    });

    // Send push notification to online drivers
    if (jobWithOrder) {
      await this.driverNotificationsService.sendJobOfferNotification(jobWithOrder);
    }

    return {
      jobId: jobOffer.id,
      orderId: jobOffer.orderId,
      status: jobOffer.status,
      expiresAt: jobOffer.expiresAt,
    };
  }

  /**
   * Get delivery history for driver (all accepted jobs: delivered, cancelled, etc.)
   * Includes total earnings (sum of driver_earnings for delivered orders).
   */
  async getDeliveryHistory(driverId: string) {
    const driver = await this.driversService.getDriverByUserId(driverId);
    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    const jobs = await this.jobOfferRepository.find({
      where: { acceptedByDriverId: driver.id },
      relations: ['order', 'order.vendor'],
      order: { acceptedAt: 'DESC' },
    });

    let totalEarnings = 0;
    const deliveries = jobs.map((job) => {
      const delivered = job.order.status === OrderStatus.DELIVERED;
      if (delivered) {
        totalEarnings += parseFloat(String(job.driverEarnings));
      }
      return {
        id: job.id,
        orderId: job.orderId,
        orderNumber: job.order.orderNumber,
        orderStatus: job.order.status,
        deliveredAt: job.order.deliveredAt,
        driverEarnings: parseFloat(String(job.driverEarnings)),
        vendorName: job.order.vendor?.name ?? '—',
        acceptedAt: job.acceptedAt,
      };
    });

    return {
      totalEarnings: Math.round(totalEarnings * 100) / 100,
      deliveries,
    };
  }
}
