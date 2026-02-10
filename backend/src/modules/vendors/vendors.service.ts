import {
  Injectable,
  ConflictException,
  NotFoundException,
  BadRequestException,
  UnauthorizedException,
  InternalServerErrorException,
  Inject,
  forwardRef,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual, LessThanOrEqual, Between } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { Vendor, VendorType } from './entities/vendor.entity';
import { VendorCertificate } from './entities/vendor-certificate.entity';
import { VendorStaff } from './entities/vendor-staff.entity';
import { User } from '../users/entities/user.entity';
import { RegisterVendorDto } from './dto/register-vendor.dto';
import { UpdateVendorProfileDto } from './dto/update-vendor-profile.dto';
import { AddCertificateDto } from './dto/add-certificate.dto';
import { VendorStatus, VerificationStatus, StaffRole, CertificateType } from './enums';
import { Order } from '../orders/entities/order.entity';
import { OrderStatus } from '../orders/entities/order.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { JobsService } from '../jobs/jobs.service';

@Injectable()
export class VendorsService {
  private readonly PASSWORD_SALT_ROUNDS = 10;
  private readonly logger = new Logger(VendorsService.name);

  constructor(
    @InjectRepository(Vendor)
    private readonly vendorRepository: Repository<Vendor>,
    @InjectRepository(VendorCertificate)
    private readonly certificateRepository: Repository<VendorCertificate>,
    @InjectRepository(VendorStaff)
    private readonly staffRepository: Repository<VendorStaff>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
    @InjectRepository(MenuItem)
    private readonly menuItemRepository: Repository<MenuItem>,
    @Inject(forwardRef(() => JobsService))
    private readonly jobsService: JobsService,
  ) {}

  async getVendor(id: string): Promise<Vendor | null> {
    return this.vendorRepository.findOne({
      where: { id },
      relations: ['menuItems', 'certificates', 'staff'],
    });
  }

  async findAll(): Promise<Vendor[]> {
    return this.vendorRepository.find({
      where: { isActive: true, isAcceptingOrders: true },
    });
  }

  async register(dto: RegisterVendorDto, files?: {
    commercialRegistration?: any[];
    ownerId?: any[];
    logo?: any[];
    cover?: any[];
    restaurantImages?: any[];
  }): Promise<{ vendorId: string; status: string; message: string }> {
    const emailNorm = (dto.email || '').trim().toLowerCase();
    const passwordTrim = (dto.password || '').trim();
    const nameTrim = (dto.name || '').trim();
    if (!emailNorm) throw new BadRequestException('البريد الإلكتروني مطلوب.');
    if (!passwordTrim) throw new BadRequestException('كلمة المرور مطلوبة.');
    if (nameTrim.length < 2) throw new BadRequestException('اسم مقدم الخدمة يجب أن يكون حرفين على الأقل.');

    // 1. Check email uniqueness (vendor + user), case-insensitive
    const existingVendorByEmail = await this.vendorRepository
      .createQueryBuilder('v')
      .where('LOWER(TRIM(v.email)) = :email', { email: emailNorm })
      .getOne();
    if (existingVendorByEmail) {
      throw new ConflictException('البريد الإلكتروني مسجّل مسبقاً.');
    }
    const existingUserByEmail = await this.userRepository
      .createQueryBuilder('u')
      .where('LOWER(TRIM(u.email)) = :email', { email: emailNorm })
      .getOne();
    if (existingUserByEmail) {
      throw new ConflictException('البريد الإلكتروني مسجّل مسبقاً.');
    }

    const phoneOrEmail = dto.phoneNumber?.trim() || emailNorm;

    const existingUserByPhone = await this.userRepository.findOne({
      where: { phone: phoneOrEmail },
    });
    if (existingUserByPhone) {
      throw new ConflictException('رقم الجوال أو البريد مستخدم مسبقاً. جرّب تسجيل الدخول أو استخدم بريداً/رقماً آخر.');
    }

    // 2. Optional: commercial registration uniqueness
    if (dto.commercialRegistrationNumber?.trim()) {
      const existingVendorByReg = await this.vendorRepository.findOne({
        where: { commercialRegistrationNumber: dto.commercialRegistrationNumber.trim() },
      });
      if (existingVendorByReg) {
        throw new ConflictException('Commercial registration number already exists');
      }
    }

    // 3. Optional: owner ID uniqueness (use email as fallback for minimal registration)
    const ownerIdValue = dto.ownerIdNumber?.trim() || emailNorm;
    const existingVendorById = await this.vendorRepository.findOne({
      where: { ownerIdNumber: ownerIdValue },
    });
    if (existingVendorById) {
      throw new ConflictException('Owner ID number already exists');
    }

    // 4. Hash password (use trimmed)
    const hashedPassword = await bcrypt.hash(passwordTrim, this.PASSWORD_SALT_ROUNDS);

    // 5. Create vendor — required: name, email, phoneNumber, location, owner fields (use defaults when optional)
    const vendor = this.vendorRepository.create({
      name: nameTrim,
      tradeName: dto.tradeName?.trim() || null,
      type: dto.type ?? VendorType.PREMIUM_CASUAL,
      description: dto.description?.trim() || null,
      email: emailNorm,
      phoneNumber: phoneOrEmail,
      website: dto.website?.trim() || null,
      commercialRegistrationNumber: dto.commercialRegistrationNumber?.trim() || null,
      commercialRegistrationIssueDate: dto.commercialRegistrationIssueDate
        ? new Date(dto.commercialRegistrationIssueDate)
        : null,
      commercialRegistrationExpiryDate: dto.commercialRegistrationExpiryDate
        ? new Date(dto.commercialRegistrationExpiryDate)
        : null,
      commercialRegistrationImage: files?.commercialRegistration?.[0]?.filename || null,
      commercialRegistrationStatus: VerificationStatus.PENDING,
      latitude: dto.latitude ?? 0,
      longitude: dto.longitude ?? 0,
      address: (dto.address?.trim() || '').replace(/^$/, 'قيد الإكمال'),
      city: (dto.city?.trim() || '').replace(/^$/, 'غير محدد'),
      district: dto.district?.trim() || null,
      postalCode: dto.postalCode?.trim() || null,
      deliveryFee: dto.deliveryFee ?? 0,
      deliveryRadius: dto.deliveryRadius ?? 10,
      estimatedDeliveryTime: dto.estimatedDeliveryTime ?? 30,
      ownerName: (dto.ownerName?.trim() || nameTrim).trim(),
      ownerPhone: dto.ownerPhone?.trim() || phoneOrEmail,
      ownerEmail: dto.ownerEmail?.trim() || emailNorm,
      ownerIdNumber: ownerIdValue,
      ownerIdImage: files?.ownerId?.[0]?.filename || '',
      ownerNationality: dto.ownerNationality?.trim() || null,
      ownerAddress: dto.ownerAddress?.trim() || null,
      bankName: dto.bankName?.trim() || null,
      bankAccountNumber: dto.bankAccountNumber?.trim() || null,
      iban: dto.iban?.trim() || null,
      accountHolderName: dto.accountHolderName?.trim() || null,
      swiftCode: dto.swiftCode?.trim() || null,
      logo: files?.logo?.[0]?.filename || null,
      cover: files?.cover?.[0]?.filename || null,
      restaurantImages: files?.restaurantImages?.map((f) => f.filename) || null,
      registrationStatus: VendorStatus.PENDING_APPROVAL,
      isActive: false,
      isAcceptingOrders: false,
      providerCategory: dto.providerCategory?.trim() || null,
      popularCookingAddOns: (() => {
        if (!dto.popularCookingAddOns?.trim()) return null;
        try {
          const parsed = JSON.parse(dto.popularCookingAddOns) as unknown;
          return Array.isArray(parsed) ? parsed : null;
        } catch {
          return null;
        }
      })(),
    });

    try {
      const savedVendor = await this.vendorRepository.save(vendor);

      // 6. Create user account for vendor (login by email + password)
      const vendorUser = this.userRepository.create({
        phone: phoneOrEmail,
        name: (dto.ownerName?.trim() || nameTrim).trim(),
        email: emailNorm,
        pinHash: hashedPassword,
        isVerified: false,
        isActive: true,
      });

      await this.userRepository.save(vendorUser);

      // 9. Create staff record (owner role)
      const ownerStaff = this.staffRepository.create({
        vendorId: savedVendor.id,
        userId: vendorUser.id,
        role: StaffRole.OWNER,
        permissions: ['*'], // All permissions for owner
        isActive: true,
        acceptedAt: new Date(),
      });

      await this.staffRepository.save(ownerStaff);

      return {
        vendorId: savedVendor.id,
        status: savedVendor.registrationStatus,
        message: 'Registration submitted successfully. Your application is under review.',
      };
    } catch (err: any) {
      const code = err?.driverError?.code;
      const detail = err?.driverError?.detail ?? err?.message;
      this.logger.error(
        `Vendor register failed: ${err?.message ?? err} | code=${code} | detail=${detail}`,
        err?.stack,
      );
      if (err?.driverError) {
        this.logger.error(`driverError: ${JSON.stringify(err.driverError)}`);
      }
      if (err?.driverError?.code === '23505') {
        const detailStr = String(err?.driverError?.detail ?? '');
        if (detailStr.includes('(name)=')) {
          throw new ConflictException('اسم مقدم الخدمة مستخدم مسبقاً. اختر اسماً آخر أو سجّل الدخول بالحساب الحالي.');
        }
        if (detailStr.includes('(email)=')) {
          throw new ConflictException('البريد الإلكتروني مسجّل مسبقاً.');
        }
        if (detailStr.includes('(phone') || detailStr.includes('(phone_number)')) {
          throw new ConflictException('رقم الجوال أو البريد مسجّل مسبقاً.');
        }
        throw new ConflictException('البريد أو رقم الجوال مسجّل مسبقاً.');
      }
      if (err?.driverError?.code === '42703' || (detail && String(detail).includes('column') && String(detail).includes('does not exist'))) {
        this.logger.error('DB schema may be missing columns. Run migrations on the database.');
        throw new InternalServerErrorException(
          'Server database is not up to date. Please contact support.',
        );
      }
      throw new InternalServerErrorException(
        'Registration failed. Please try again or contact support.',
      );
    }
  }

  async getRegistrationStatus(vendorId: string): Promise<{
    status: string;
    submittedAt: Date;
    approvedAt: Date | null;
    message: string;
  }> {
    const vendor = await this.vendorRepository.findOne({
      where: { id: vendorId },
      select: ['id', 'registrationStatus', 'createdAt', 'approvedAt'],
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    const messages = {
      [VendorStatus.PENDING_APPROVAL]: 'Your registration is pending review. We will contact you soon.',
      [VendorStatus.UNDER_REVIEW]: 'Your registration is under review. Please wait for approval.',
      [VendorStatus.APPROVED]: 'Your registration has been approved. You can now log in.',
      [VendorStatus.REJECTED]: 'Your registration has been rejected. Please contact support.',
      [VendorStatus.SUSPENDED]: 'Your account has been suspended. Please contact support.',
    };

    return {
      status: vendor.registrationStatus,
      submittedAt: vendor.createdAt,
      approvedAt: vendor.approvedAt,
      message: messages[vendor.registrationStatus] || 'Unknown status',
    };
  }

  async updateProfile(
    vendorId: string,
    dto: UpdateVendorProfileDto,
  ): Promise<Vendor> {
    const vendor = await this.vendorRepository.findOne({
      where: { id: vendorId },
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    // Update fields
    if (dto.name !== undefined) vendor.name = dto.name;
    if (dto.tradeName !== undefined) vendor.tradeName = dto.tradeName;
    if (dto.type !== undefined) vendor.type = dto.type;
    if (dto.description !== undefined) vendor.description = dto.description;
    if (dto.email !== undefined) vendor.email = dto.email;
    if (dto.phoneNumber !== undefined) vendor.phoneNumber = dto.phoneNumber;
    if (dto.website !== undefined) vendor.website = dto.website;
    if (dto.latitude !== undefined) vendor.latitude = dto.latitude;
    if (dto.longitude !== undefined) vendor.longitude = dto.longitude;
    if (dto.address !== undefined) vendor.address = dto.address;
    if (dto.city !== undefined) vendor.city = dto.city;
    if (dto.district !== undefined) vendor.district = dto.district;
    if (dto.postalCode !== undefined) vendor.postalCode = dto.postalCode;
    if (dto.deliveryFee !== undefined) vendor.deliveryFee = dto.deliveryFee;
    if (dto.deliveryRadius !== undefined) vendor.deliveryRadius = dto.deliveryRadius;
    if (dto.estimatedDeliveryTime !== undefined) vendor.estimatedDeliveryTime = dto.estimatedDeliveryTime;
    if (dto.workingHours !== undefined) vendor.workingHours = dto.workingHours;
    if (dto.isAcceptingOrders !== undefined) vendor.isAcceptingOrders = dto.isAcceptingOrders;
    if (dto.isActive !== undefined) vendor.isActive = dto.isActive;
    if (dto.popularCookingAddOns !== undefined) vendor.popularCookingAddOns = dto.popularCookingAddOns;

    return this.vendorRepository.save(vendor);
  }

  async changePassword(
    userId: string,
    currentPassword: string,
    newPassword: string,
  ): Promise<{ message: string }> {
    const user = await this.userRepository.findOne({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Verify current password
    if (user.pinHash) {
      const isPasswordValid = await bcrypt.compare(currentPassword, user.pinHash);
      if (!isPasswordValid) {
        throw new UnauthorizedException('Current password is incorrect');
      }
    } else {
      // If no password is set, allow setting a new one
      // In production, you might want to require email verification first
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update password (using pinHash field for now)
    user.pinHash = hashedPassword;
    await this.userRepository.save(user);

    return { message: 'Password changed successfully' };
  }

  async addCertificate(
    vendorId: string,
    dto: AddCertificateDto,
    file?: any,
  ): Promise<VendorCertificate> {
    const vendor = await this.vendorRepository.findOne({
      where: { id: vendorId },
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    const certificate = this.certificateRepository.create({
      vendorId: vendor.id,
      type: dto.type,
      certificateNumber: dto.certificateNumber,
      issueDate: new Date(dto.issueDate),
      expiryDate: new Date(dto.expiryDate),
      certificateImage: file?.filename || '',
      status: VerificationStatus.PENDING,
    });

    return this.certificateRepository.save(certificate);
  }

  async getCertificates(vendorId: string): Promise<VendorCertificate[]> {
    return this.certificateRepository.find({
      where: { vendorId },
      order: { createdAt: 'DESC' },
    });
  }

  async getProfile(vendorId: string): Promise<Vendor> {
    const vendor = await this.vendorRepository.findOne({
      where: { id: vendorId },
      relations: ['certificates', 'staff'],
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    return vendor;
  }

  async getVendorIdByUserId(userId: string): Promise<string | null> {
    const staff = await this.staffRepository.findOne({
      where: { userId },
      select: ['vendorId'],
    });

    return staff?.vendorId || null;
  }

  // Vendor Orders Management
  async getVendorOrders(
    vendorId: string,
    status?: OrderStatus,
  ): Promise<Order[]> {
    const where: any = { vendorId };
    if (status) {
      where.status = status;
    }

    return this.orderRepository.find({
      where,
      relations: ['items', 'items.menuItem', 'user', 'address'],
      order: { createdAt: 'DESC' },
    });
  }

  async getVendorOrder(vendorId: string, orderId: string): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id: orderId, vendorId },
      relations: ['items', 'items.menuItem', 'user', 'address', 'payments'],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    return order;
  }

  async acceptOrder(vendorId: string, orderId: string): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id: orderId, vendorId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.status !== OrderStatus.PENDING) {
      throw new BadRequestException('Order cannot be accepted. Invalid status.');
    }

    order.status = OrderStatus.CONFIRMED;
    return this.orderRepository.save(order);
  }

  async rejectOrder(
    vendorId: string,
    orderId: string,
    reason: string,
  ): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id: orderId, vendorId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.status !== OrderStatus.PENDING) {
      throw new BadRequestException('Order cannot be rejected. Invalid status.');
    }

    order.status = OrderStatus.CANCELLED;
    // TODO: Store rejection reason in order notes or separate field
    return this.orderRepository.save(order);
  }

  async updateOrderStatus(
    vendorId: string,
    orderId: string,
    status: OrderStatus,
  ): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id: orderId, vendorId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    // Validate status transition
    const validTransitions: Record<OrderStatus, OrderStatus[]> = {
      [OrderStatus.PENDING]: [OrderStatus.CONFIRMED, OrderStatus.CANCELLED],
      [OrderStatus.CONFIRMED]: [OrderStatus.PREPARING, OrderStatus.CANCELLED],
      [OrderStatus.PREPARING]: [OrderStatus.READY, OrderStatus.CANCELLED],
      [OrderStatus.READY]: [OrderStatus.OUT_FOR_DELIVERY],
      [OrderStatus.OUT_FOR_DELIVERY]: [OrderStatus.DELIVERED],
      [OrderStatus.DELIVERED]: [],
      [OrderStatus.CANCELLED]: [],
    };

    const allowedStatuses = validTransitions[order.status] || [];
    if (!allowedStatuses.includes(status)) {
      throw new BadRequestException(
        `Cannot change status from ${order.status} to ${status}`,
      );
    }

    order.status = status;
    if (status === OrderStatus.DELIVERED) {
      order.deliveredAt = new Date();
    }

    const savedOrder = await this.orderRepository.save(order);

    // If order status changed to READY, create job offer for drivers
    if (status === OrderStatus.READY) {
      try {
        await this.jobsService.createJobOfferFromOrder(savedOrder.id);
      } catch (error) {
        // Log error but don't fail the status update
        // Job offer might already exist, which is fine
        console.error('Failed to create job offer:', error);
      }
    }

    return savedOrder;
  }

  // Vendor Menu Management
  async getVendorMenu(vendorId: string): Promise<any[]> {
    const menuItems = await this.menuItemRepository.find({
      where: { vendorId },
      order: { createdAt: 'DESC' },
      relations: ['videoAssets'], // Include video assets
    });
    
    // Transform to ensure price is number and format videoAssets
    return menuItems.map(item => ({
      id: item.id,
      vendorId: item.vendorId,
      name: item.name,
      description: item.description,
      price: typeof item.price === 'string' ? parseFloat(item.price) : item.price,
      image: item.image,
      isSignature: item.isSignature,
      isAvailable: item.isAvailable,
      orderCount: item.orderCount,
      createdAt: item.createdAt.toISOString(),
      updatedAt: item.updatedAt.toISOString(),
      videoAssets: item.videoAssets?.map(video => ({
        id: video.id,
        menuItemId: video.menuItemId,
        cloudflareAssetId: video.cloudflareAssetId,
        playbackUrl: video.playbackUrl,
        thumbnailUrl: video.thumbnailUrl,
        duration: video.duration,
        status: video.status,
        isPrimary: video.isPrimary,
        createdAt: video.createdAt.toISOString(),
        updatedAt: video.updatedAt.toISOString(),
      })) || [],
    }));
  }

  async addMenuItem(
    vendorId: string,
    data: {
      name: string;
      description?: string;
      price: number;
      image?: string;
      isSignature?: boolean;
      isAvailable?: boolean;
    },
  ): Promise<MenuItem> {
    const menuItem = this.menuItemRepository.create({
      vendorId,
      name: data.name,
      description: data.description,
      price: data.price,
      image: data.image,
      isSignature: data.isSignature || false,
      isAvailable: data.isAvailable ?? true,
    });

    return this.menuItemRepository.save(menuItem);
  }

  async updateMenuItem(
    vendorId: string,
    menuItemId: string,
    data: {
      name?: string;
      description?: string;
      price?: number;
      image?: string;
      isSignature?: boolean;
      isAvailable?: boolean;
    },
  ): Promise<MenuItem> {
    const menuItem = await this.menuItemRepository.findOne({
      where: { id: menuItemId, vendorId },
    });

    if (!menuItem) {
      throw new NotFoundException('Menu item not found');
    }

    if (data.name !== undefined) menuItem.name = data.name;
    if (data.description !== undefined) menuItem.description = data.description;
    if (data.price !== undefined) menuItem.price = data.price;
    if (data.image !== undefined) menuItem.image = data.image;
    if (data.isSignature !== undefined) menuItem.isSignature = data.isSignature;
    if (data.isAvailable !== undefined) menuItem.isAvailable = data.isAvailable;

    return this.menuItemRepository.save(menuItem);
  }

  async deleteMenuItem(vendorId: string, menuItemId: string): Promise<void> {
    const menuItem = await this.menuItemRepository.findOne({
      where: { id: menuItemId, vendorId },
    });

    if (!menuItem) {
      throw new NotFoundException('Menu item not found');
    }

    await this.menuItemRepository.remove(menuItem);
  }

  async toggleMenuItemAvailability(
    vendorId: string,
    menuItemId: string,
  ): Promise<MenuItem> {
    const menuItem = await this.menuItemRepository.findOne({
      where: { id: menuItemId, vendorId },
    });

    if (!menuItem) {
      throw new NotFoundException('Menu item not found');
    }

    menuItem.isAvailable = !menuItem.isAvailable;
    return this.menuItemRepository.save(menuItem);
  }

  // Vendor Analytics
  async getVendorAnalytics(vendorId: string, startDate?: Date, endDate?: Date) {
    const whereConditions: any = { vendorId };
    
    if (startDate && endDate) {
      whereConditions.createdAt = Between(startDate, endDate);
    } else if (startDate) {
      whereConditions.createdAt = MoreThanOrEqual(startDate);
    } else if (endDate) {
      whereConditions.createdAt = LessThanOrEqual(endDate);
    }

    const orders = await this.orderRepository.find({
      where: whereConditions,
      relations: ['items', 'items.menuItem'],
    });

    const totalOrders = orders.length;
    const totalRevenue = orders
      .filter((o) => o.status === OrderStatus.DELIVERED)
      .reduce((sum, o) => sum + parseFloat(o.total.toString()), 0);

    const pendingOrders = orders.filter((o) => o.status === OrderStatus.PENDING).length;
    const preparingOrders = orders.filter((o) => o.status === OrderStatus.PREPARING).length;
    const readyOrders = orders.filter((o) => o.status === OrderStatus.READY).length;

    // Top menu items
    const itemCounts: Record<string, { name: string; count: number; revenue: number }> = {};
    orders.forEach((order) => {
      if (order.items) {
        order.items.forEach((item) => {
          const menuItemId = item.menuItem?.id || 'unknown';
          if (!itemCounts[menuItemId]) {
            itemCounts[menuItemId] = {
              name: item.menuItem?.name || 'Unknown',
              count: 0,
              revenue: 0,
            };
          }
          itemCounts[menuItemId].count += item.quantity;
          itemCounts[menuItemId].revenue += parseFloat(item.price.toString()) * item.quantity;
        });
      }
    });

    const topItems = Object.values(itemCounts)
      .sort((a, b) => b.count - a.count)
      .slice(0, 10);

    return {
      totalOrders,
      totalRevenue,
      pendingOrders,
      preparingOrders,
      readyOrders,
      topItems,
      averageOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0,
    };
  }

  // Vendor Staff Management
  async getVendorStaff(vendorId: string): Promise<VendorStaff[]> {
    return this.staffRepository.find({
      where: { vendorId },
      relations: ['user'],
      order: { createdAt: 'DESC' },
    });
  }

  async addStaff(
    vendorId: string,
    data: {
      email: string;
      name: string;
      phone: string;
      role: StaffRole;
      permissions?: string[];
    },
  ): Promise<VendorStaff> {
    // Check if user exists
    let user = await this.userRepository.findOne({ where: { email: data.email } });

    if (!user) {
      // Create new user account for staff
      user = this.userRepository.create({
        email: data.email,
        phone: data.phone,
        name: data.name,
      });
      user = await this.userRepository.save(user);
    }

    // Check if staff already exists for this vendor
    const existingStaff = await this.staffRepository.findOne({
      where: { vendorId, userId: user.id },
    });

    if (existingStaff) {
      throw new ConflictException('Staff member already exists for this vendor');
    }

    const staff = this.staffRepository.create({
      vendorId,
      userId: user.id,
      role: data.role,
      permissions: data.permissions || [],
      isActive: true,
    });

    return this.staffRepository.save(staff);
  }

  async updateStaff(
    vendorId: string,
    staffId: string,
    data: {
      role?: StaffRole;
      permissions?: string[];
      isActive?: boolean;
    },
  ): Promise<VendorStaff> {
    const staff = await this.staffRepository.findOne({
      where: { id: staffId, vendorId },
    });

    if (!staff) {
      throw new NotFoundException('Staff member not found');
    }

    if (data.role !== undefined) staff.role = data.role;
    if (data.permissions !== undefined) staff.permissions = data.permissions;
    if (data.isActive !== undefined) staff.isActive = data.isActive;

    return this.staffRepository.save(staff);
  }

  async removeStaff(vendorId: string, staffId: string): Promise<void> {
    const staff = await this.staffRepository.findOne({
      where: { id: staffId, vendorId },
    });

    if (!staff) {
      throw new NotFoundException('Staff member not found');
    }

    // Don't allow removing owner
    if (staff.role === StaffRole.OWNER) {
      throw new BadRequestException('Cannot remove owner');
    }

    await this.staffRepository.remove(staff);
  }
}
