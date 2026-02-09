import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsDateString,
  IsEnum,
  IsOptional,
  IsBoolean,
  Matches,
  Length,
} from 'class-validator';
import { LicenseType, VehicleType } from '../enums/driver-status.enum';

export class RegisterDriverStep2Dto {
  // Personal Identity
  @ApiProperty({ example: 'أحمد محمد علي', description: 'Full name' })
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @ApiProperty({ example: '1990-01-01', description: 'Date of birth' })
  @IsDateString()
  @IsNotEmpty()
  dateOfBirth: string;

  @ApiProperty({ example: 'male', enum: ['male', 'female'], description: 'Gender' })
  @IsEnum(['male', 'female'])
  @IsNotEmpty()
  gender: 'male' | 'female';

  @ApiProperty({ example: 'Saudi', description: 'Nationality' })
  @IsString()
  @IsNotEmpty()
  nationality: string;

  // Driver License
  @ApiProperty({ example: '1234567890', description: 'License number' })
  @IsString()
  @IsNotEmpty()
  licenseNumber: string;

  @ApiProperty({
    example: 'transport',
    enum: LicenseType,
    description: 'License type',
  })
  @IsEnum(LicenseType)
  @IsNotEmpty()
  licenseType: LicenseType;

  @ApiProperty({ example: '2020-01-01', description: 'License issue date' })
  @IsDateString()
  @IsNotEmpty()
  licenseIssueDate: string;

  @ApiProperty({ example: '2025-01-01', description: 'License expiry date' })
  @IsDateString()
  @IsNotEmpty()
  licenseExpiryDate: string;

  @ApiProperty({ example: 'إدارة المرور', description: 'Issuing authority' })
  @IsString()
  @IsNotEmpty()
  licenseIssuingAuthority: string;

  @ApiProperty({ example: 'https://...', description: 'License photo front URL' })
  @IsString()
  @IsNotEmpty()
  licensePhotoFront: string;

  @ApiProperty({ example: 'https://...', description: 'License photo back URL' })
  @IsString()
  @IsNotEmpty()
  licensePhotoBack: string;

  // Vehicle Information
  @ApiProperty({
    example: 'car',
    enum: VehicleType,
    description: 'Vehicle type',
  })
  @IsEnum(VehicleType)
  @IsNotEmpty()
  vehicleType: VehicleType;

  @ApiProperty({ example: 'Toyota', description: 'Vehicle make' })
  @IsString()
  @IsNotEmpty()
  vehicleMake: string;

  @ApiProperty({ example: 'Camry', description: 'Vehicle model' })
  @IsString()
  @IsNotEmpty()
  vehicleModel: string;

  @ApiProperty({ example: 2020, description: 'Vehicle year' })
  @IsString()
  @IsNotEmpty()
  vehicleYear: string;

  @ApiProperty({ example: 'White', description: 'Vehicle color' })
  @IsString()
  @IsNotEmpty()
  vehicleColor: string;

  @ApiProperty({ example: 'ABC1234', description: 'Plate number' })
  @IsString()
  @IsNotEmpty()
  plateNumber: string;

  @ApiProperty({ example: 'الرياض', description: 'Plate region' })
  @IsString()
  @IsNotEmpty()
  plateRegion: string;

  @ApiProperty({ example: 'REG123456', description: 'Vehicle registration number' })
  @IsString()
  @IsNotEmpty()
  vehicleRegistrationNumber: string;

  @ApiProperty({ example: '2025-01-01', description: 'Vehicle registration expiry' })
  @IsDateString()
  @IsNotEmpty()
  vehicleRegistrationExpiry: string;

  @ApiProperty({ example: 'https://...', description: 'Vehicle photo URL' })
  @IsString()
  @IsNotEmpty()
  vehiclePhoto: string;

  @ApiPropertyOptional({
    example: 'https://...',
    description: 'Vehicle authorization photo (for lease/rental)',
  })
  @IsString()
  @IsOptional()
  vehicleAuthorizationPhoto?: string;

  // Contact
  @ApiPropertyOptional({ example: 'ahmed@example.com', description: 'Email' })
  @IsString()
  @IsOptional()
  email?: string;

  @ApiProperty({ example: 'محمد علي', description: 'Emergency contact name' })
  @IsString()
  @IsNotEmpty()
  emergencyContactName: string;

  @ApiProperty({ example: '0501234567', description: 'Emergency contact phone' })
  @IsString()
  @IsNotEmpty()
  emergencyContactPhone: string;

  @ApiProperty({
    example: { street: '123 Main St', city: 'Riyadh', region: 'Riyadh' },
    description: 'Address',
  })
  @IsNotEmpty()
  address: {
    street: string;
    city: string;
    region: string;
    postalCode?: string;
  };

  // Legal Consents
  @ApiProperty({ example: true, description: 'Terms and conditions accepted' })
  @IsBoolean()
  @IsNotEmpty()
  termsAndConditionsAccepted: boolean;

  @ApiProperty({ example: true, description: 'Privacy policy accepted' })
  @IsBoolean()
  @IsNotEmpty()
  privacyPolicyAccepted: boolean;

  @ApiProperty({ example: true, description: 'Background check consent' })
  @IsBoolean()
  @IsNotEmpty()
  backgroundCheckConsent: boolean;

  @ApiProperty({ example: true, description: 'Location tracking consent' })
  @IsBoolean()
  @IsNotEmpty()
  locationTrackingConsent: boolean;

  @ApiProperty({ example: true, description: 'Data processing consent' })
  @IsBoolean()
  @IsNotEmpty()
  dataProcessingConsent: boolean;
}
