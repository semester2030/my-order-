import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Driver } from './entities/driver.entity';
import { User } from '../users/entities/user.entity';
import { UsersService } from '../users/users.service';
import { DriverStatus } from './enums/driver-status.enum';
import { RegisterDriverStep1Dto } from './dto/register-driver-step1.dto';
import { RegisterDriverStep2Dto } from './dto/register-driver-step2.dto';
import { RegisterDriverStep3Dto } from './dto/register-driver-step3.dto';
import { UpdateDriverAvailabilityDto } from './dto/update-driver-availability.dto';

@Injectable()
export class DriversService {
  constructor(
    @InjectRepository(Driver)
    private readonly driverRepository: Repository<Driver>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly usersService: UsersService,
  ) {}

  /**
   * Step 1: Register driver with basic info (nationalId + phoneNumber)
   */
  async registerStep1(dto: RegisterDriverStep1Dto) {
    // Check if driver already exists
    const existingDriver = await this.driverRepository.findOne({
      where: { nationalId: dto.nationalId },
    });

    if (existingDriver) {
      throw new ConflictException('Driver with this national ID already exists');
    }

    // Check if user with phone exists
    let user = await this.usersService.findByPhone(dto.phoneNumber);

    if (!user) {
      // Create new user
      user = await this.usersService.create({
        phone: dto.phoneNumber,
        isActive: true,
        isVerified: false,
      });
    }

    // Check if driver already linked to user
    const existingDriverByUser = await this.driverRepository.findOne({
      where: { userId: user.id },
    });

    if (existingDriverByUser) {
      throw new ConflictException('Driver already registered for this user');
    }

    // Create driver with basic info
    const driver = this.driverRepository.create({
      userId: user.id,
      nationalId: dto.nationalId,
      phoneNumber: dto.phoneNumber,
      status: DriverStatus.PENDING,
      user: user,
    });

    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      userId: user.id,
      status: driver.status,
      message: 'Registration step 1 completed. Please proceed to step 2.',
    };
  }

  /**
   * Step 2: Complete driver registration with documents
   */
  async registerStep2(driverId: string, dto: RegisterDriverStep2Dto) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    if (driver.status !== DriverStatus.PENDING) {
      throw new BadRequestException(
        `Cannot update driver. Current status: ${driver.status}`,
      );
    }

    // Validate license expiry
    const licenseExpiry = new Date(dto.licenseExpiryDate);
    if (licenseExpiry < new Date()) {
      throw new BadRequestException('License has expired');
    }

    // Validate vehicle registration expiry
    const vehicleExpiry = new Date(dto.vehicleRegistrationExpiry);
    if (vehicleExpiry < new Date()) {
      throw new BadRequestException('Vehicle registration has expired');
    }

    // Update driver with step 2 data
    Object.assign(driver, {
      fullName: dto.fullName,
      dateOfBirth: new Date(dto.dateOfBirth),
      gender: dto.gender,
      nationality: dto.nationality,
      licenseNumber: dto.licenseNumber,
      licenseType: dto.licenseType,
      licenseIssueDate: new Date(dto.licenseIssueDate),
      licenseExpiryDate: new Date(dto.licenseExpiryDate),
      licenseIssuingAuthority: dto.licenseIssuingAuthority,
      licensePhotoFront: dto.licensePhotoFront,
      licensePhotoBack: dto.licensePhotoBack,
      vehicleType: dto.vehicleType,
      vehicleMake: dto.vehicleMake,
      vehicleModel: dto.vehicleModel,
      vehicleYear: parseInt(dto.vehicleYear),
      vehicleColor: dto.vehicleColor,
      plateNumber: dto.plateNumber,
      plateRegion: dto.plateRegion,
      vehicleRegistrationNumber: dto.vehicleRegistrationNumber,
      vehicleRegistrationExpiry: new Date(dto.vehicleRegistrationExpiry),
      vehiclePhoto: dto.vehiclePhoto,
      vehicleAuthorizationPhoto: dto.vehicleAuthorizationPhoto,
      email: dto.email,
      emergencyContactName: dto.emergencyContactName,
      emergencyContactPhone: dto.emergencyContactPhone,
      address: dto.address,
      termsAndConditionsAccepted: dto.termsAndConditionsAccepted,
      termsAcceptedAt: dto.termsAndConditionsAccepted ? new Date() : null,
      privacyPolicyAccepted: dto.privacyPolicyAccepted,
      privacyAcceptedAt: dto.privacyPolicyAccepted ? new Date() : null,
      backgroundCheckConsent: dto.backgroundCheckConsent,
      locationTrackingConsent: dto.locationTrackingConsent,
      dataProcessingConsent: dto.dataProcessingConsent,
      status: DriverStatus.UNDER_REVIEW, // Move to under review
    });

    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      status: driver.status,
      message: 'Registration step 2 completed. Application is under review.',
    };
  }

  /**
   * Step 3: Add insurance and banking info (after approval or during registration)
   */
  async registerStep3(driverId: string, dto: RegisterDriverStep3Dto) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    // Validate insurance expiry
    const insuranceExpiry = new Date(dto.insuranceExpiryDate);
    if (insuranceExpiry < new Date()) {
      throw new BadRequestException('Insurance has expired');
    }

    // Update driver with step 3 data
    Object.assign(driver, {
      insuranceCompany: dto.insuranceCompany,
      insurancePolicyNumber: dto.insurancePolicyNumber,
      insuranceStartDate: new Date(dto.insuranceStartDate),
      insuranceExpiryDate: new Date(dto.insuranceExpiryDate),
      insuranceCoverageType: dto.insuranceCoverageType,
      insurancePhoto: dto.insurancePhoto,
      bankName: dto.bankName,
      accountNumber: dto.accountNumber,
      accountHolderName: dto.accountHolderName,
      iban: dto.iban,
      swiftCode: dto.swiftCode,
      hasMedicalConditions: dto.hasMedicalConditions || false,
      medicalConditions: dto.medicalConditions,
      bloodType: dto.bloodType,
      allergies: dto.allergies,
      profilePhoto: dto.profilePhoto,
      languages: dto.languages,
      experienceYears: dto.experienceYears,
    });

    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      status: driver.status,
      message: 'Registration step 3 completed.',
    };
  }

  /**
   * Get driver profile
   */
  async getProfile(driverId: string) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
      relations: ['user'],
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    return {
      id: driver.id,
      userId: driver.userId,
      fullName: driver.fullName,
      nationalId: driver.nationalId,
      phoneNumber: driver.phoneNumber,
      email: driver.email,
      status: driver.status,
      isOnline: driver.isOnline,
      licenseNumber: driver.licenseNumber,
      licenseType: driver.licenseType,
      licenseExpiryDate: driver.licenseExpiryDate,
      vehicleType: driver.vehicleType,
      plateNumber: driver.plateNumber,
      plateRegion: driver.plateRegion,
      insuranceCompany: driver.insuranceCompany,
      insuranceExpiryDate: driver.insuranceExpiryDate,
      currentLatitude: driver.currentLatitude,
      currentLongitude: driver.currentLongitude,
      lastOnlineAt: driver.lastOnlineAt,
      createdAt: driver.createdAt,
      updatedAt: driver.updatedAt,
    };
  }

  /**
   * Get driver by user ID
   */
  async getDriverByUserId(userId: string): Promise<Driver | null> {
    return this.driverRepository.findOne({
      where: { userId },
      relations: ['user'],
    });
  }

  /**
   * Get driver by national ID
   */
  async getDriverByNationalId(nationalId: string): Promise<Driver | null> {
    return this.driverRepository.findOne({
      where: { nationalId },
      relations: ['user'],
    });
  }

  /**
   * Update driver availability (online/offline)
   */
  async updateAvailability(
    driverId: string,
    dto: UpdateDriverAvailabilityDto,
  ) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    if (driver.status !== DriverStatus.APPROVED) {
      throw new ForbiddenException(
        'Only approved drivers can change availability',
      );
    }

    driver.isOnline = dto.isOnline;
    driver.lastOnlineAt = dto.isOnline ? new Date() : driver.lastOnlineAt;

    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      isOnline: driver.isOnline,
      lastOnlineAt: driver.lastOnlineAt,
    };
  }

  /**
   * Track application status
   */
  async trackApplication(nationalId: string) {
    const driver = await this.driverRepository.findOne({
      where: { nationalId },
      relations: ['user'],
    });

    if (!driver) {
      throw new NotFoundException('Application not found');
    }

    return {
      driverId: driver.id,
      status: driver.status,
      rejectionReason: driver.rejectionReason,
      identityVerified: driver.identityVerified,
      identityRejectionReason: driver.identityRejectionReason,
      licenseVerified: driver.licenseVerified,
      licenseRejectionReason: driver.licenseRejectionReason,
      vehicleVerified: driver.vehicleVerified,
      vehicleRejectionReason: driver.vehicleRejectionReason,
      insuranceVerified: driver.insuranceVerified,
      insuranceRejectionReason: driver.insuranceRejectionReason,
      backgroundCheckPassed: driver.backgroundCheckPassed,
      createdAt: driver.createdAt,
      updatedAt: driver.updatedAt,
    };
  }

  /**
   * Admin: Approve driver
   */
  async approveDriver(driverId: string, adminId: string) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    if (driver.status !== DriverStatus.UNDER_REVIEW) {
      throw new BadRequestException(
        `Cannot approve driver. Current status: ${driver.status}`,
      );
    }

    // Verify all required documents
    driver.identityVerified = true;
    driver.identityVerifiedAt = new Date();
    driver.identityVerifiedBy = adminId;

    driver.licenseVerified = true;
    driver.licenseVerifiedAt = new Date();

    driver.vehicleVerified = true;
    driver.vehicleVerifiedAt = new Date();

    driver.insuranceVerified = true;
    driver.insuranceVerifiedAt = new Date();

    driver.backgroundCheckPassed = true;
    driver.backgroundCheckDate = new Date();

    driver.status = DriverStatus.APPROVED;

    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      status: driver.status,
      message: 'Driver approved successfully',
    };
  }

  /**
   * Admin: Reject driver
   */
  async rejectDriver(driverId: string, rejectionReason: string, adminId: string) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    driver.status = DriverStatus.REJECTED;
    driver.rejectionReason = rejectionReason;

    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      status: driver.status,
      rejectionReason: driver.rejectionReason,
      message: 'Driver rejected',
    };
  }

  /**
   * Update FCM token for push notifications
   */
  async updateFcmToken(driverId: string, fcmToken: string) {
    const driver = await this.driverRepository.findOne({
      where: { id: driverId },
    });

    if (!driver) {
      throw new NotFoundException('Driver not found');
    }

    driver.fcmToken = fcmToken;
    await this.driverRepository.save(driver);

    return {
      driverId: driver.id,
      message: 'FCM token updated successfully',
    };
  }

  /**
   * Get all drivers (for admin)
   */
  async getAllDrivers(status?: DriverStatus) {
    const where: any = {};
    if (status) {
      where.status = status;
    }

    return this.driverRepository.find({
      where,
      relations: ['user'],
      order: { createdAt: 'DESC' },
    });
  }
}
