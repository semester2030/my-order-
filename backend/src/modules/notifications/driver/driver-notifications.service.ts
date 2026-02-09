import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { FcmService } from '../fcm/fcm.service';
import { Driver } from '../../drivers/entities/driver.entity';
import { JobOffer } from '../../jobs/entities/job-offer.entity';

/**
 * Driver Notifications Service
 * 
 * Handles sending notifications to drivers:
 * - Job offers
 * - Delivery updates
 * - Earnings notifications
 */
@Injectable()
export class DriverNotificationsService {
  private readonly logger = new Logger(DriverNotificationsService.name);

  constructor(
    @InjectRepository(Driver)
    private readonly driverRepository: Repository<Driver>,
    private readonly fcmService: FcmService,
  ) {}

  /**
   * Send job offer notification to online drivers
   */
  async sendJobOfferNotification(
    jobOffer: JobOffer,
    driverIds?: string[], // Optional: specific drivers to notify
  ): Promise<{ sent: number; failed: number }> {
    try {
      // Get online drivers with FCM tokens
      const query = this.driverRepository
        .createQueryBuilder('driver')
        .where('driver.isOnline = :isOnline', { isOnline: true })
        .andWhere('driver.status = :status', { status: 'approved' })
        .andWhere('driver.fcmToken IS NOT NULL');

      if (driverIds && driverIds.length > 0) {
        query.andWhere('driver.id IN (:...driverIds)', { driverIds });
      }

      const drivers = await query.getMany();

      if (drivers.length === 0) {
        this.logger.warn('No online drivers with FCM tokens found');
        return { sent: 0, failed: 0 };
      }

      const tokens = drivers
        .map((d) => d.fcmToken)
        .filter((token): token is string => token !== null);

      if (tokens.length === 0) {
        this.logger.warn('No valid FCM tokens found');
        return { sent: 0, failed: 0 };
      }

      // Prepare notification
      const notification = {
        title: 'New Job Offer',
        body: `Order #${jobOffer.order.orderNumber} - ${jobOffer.driverEarnings.toFixed(2)} SAR`,
      };

      const data = {
        type: 'job_offer',
        jobOfferId: jobOffer.id,
        orderId: jobOffer.orderId,
        orderNumber: jobOffer.order.orderNumber,
        driverEarnings: jobOffer.driverEarnings.toString(),
        deliveryFee: jobOffer.deliveryFee.toString(),
        estimatedDistance: jobOffer.estimatedDistance.toString(),
        estimatedDuration: jobOffer.estimatedDuration.toString(),
        expiresAt: jobOffer.expiresAt.toISOString(),
      };

      // Send multicast notification
      const result = await this.fcmService.sendMulticast(tokens, notification, data);

      // Remove invalid tokens from database
      if (result.invalidTokens.length > 0) {
        await this.removeInvalidTokens(result.invalidTokens);
      }

      this.logger.log(
        `Job offer notification sent: ${result.successCount} success, ${result.failureCount} failures`,
      );

      return {
        sent: result.successCount,
        failed: result.failureCount,
      };
    } catch (error) {
      this.logger.error(
        `Failed to send job offer notification: ${error.message}`,
        error.stack,
      );
      return { sent: 0, failed: 0 };
    }
  }

  /**
   * Send delivery status update notification
   */
  async sendDeliveryUpdateNotification(
    driverId: string,
    orderNumber: string,
    status: string,
  ): Promise<boolean> {
    try {
      const driver = await this.driverRepository.findOne({
        where: { id: driverId },
      });

      if (!driver || !driver.fcmToken) {
        return false;
      }

      const notification = {
        title: 'Delivery Update',
        body: `Order #${orderNumber} status: ${status}`,
      };

      const data = {
        type: 'delivery_update',
        orderNumber,
        status,
      };

      return await this.fcmService.sendNotification({
        token: driver.fcmToken,
        notification,
        data,
      });
    } catch (error) {
      this.logger.error(
        `Failed to send delivery update notification: ${error.message}`,
        error.stack,
      );
      return false;
    }
  }

  /**
   * Send earnings notification
   */
  async sendEarningsNotification(
    driverId: string,
    amount: number,
    period: string,
  ): Promise<boolean> {
    try {
      const driver = await this.driverRepository.findOne({
        where: { id: driverId },
      });

      if (!driver || !driver.fcmToken) {
        return false;
      }

      const notification = {
        title: 'Earnings Update',
        body: `You earned ${amount.toFixed(2)} SAR for ${period}`,
      };

      const data = {
        type: 'earnings',
        amount: amount.toString(),
        period,
      };

      return await this.fcmService.sendNotification({
        token: driver.fcmToken,
        notification,
        data,
      });
    } catch (error) {
      this.logger.error(
        `Failed to send earnings notification: ${error.message}`,
        error.stack,
      );
      return false;
    }
  }

  /**
   * Remove invalid FCM tokens from database
   */
  private async removeInvalidTokens(tokens: string[]): Promise<void> {
    try {
      await this.driverRepository
        .createQueryBuilder()
        .update(Driver)
        .set({ fcmToken: null })
        .where('fcmToken IN (:...tokens)', { tokens })
        .execute();

      this.logger.log(`Removed ${tokens.length} invalid FCM tokens`);
    } catch (error) {
      this.logger.error(
        `Failed to remove invalid tokens: ${error.message}`,
        error.stack,
      );
    }
  }
}
