import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsDateString,
  IsOptional,
  IsNumber,
  Min,
} from 'class-validator';

export class RegisterDriverStep3Dto {
  // Insurance
  @ApiProperty({ example: 'شركة التأمين', description: 'Insurance company' })
  @IsString()
  @IsNotEmpty()
  insuranceCompany: string;

  @ApiProperty({ example: 'POL123456', description: 'Insurance policy number' })
  @IsString()
  @IsNotEmpty()
  insurancePolicyNumber: string;

  @ApiProperty({ example: '2024-01-01', description: 'Insurance start date' })
  @IsDateString()
  @IsNotEmpty()
  insuranceStartDate: string;

  @ApiProperty({ example: '2025-01-01', description: 'Insurance expiry date' })
  @IsDateString()
  @IsNotEmpty()
  insuranceExpiryDate: string;

  @ApiProperty({ example: 'comprehensive', description: 'Insurance coverage type' })
  @IsString()
  @IsNotEmpty()
  insuranceCoverageType: string;

  @ApiProperty({ example: 'https://...', description: 'Insurance photo URL' })
  @IsString()
  @IsNotEmpty()
  insurancePhoto: string;

  // Banking
  @ApiProperty({ example: 'البنك الأهلي', description: 'Bank name' })
  @IsString()
  @IsNotEmpty()
  bankName: string;

  @ApiProperty({ example: '1234567890', description: 'Account number' })
  @IsString()
  @IsNotEmpty()
  accountNumber: string;

  @ApiProperty({ example: 'أحمد محمد علي', description: 'Account holder name' })
  @IsString()
  @IsNotEmpty()
  accountHolderName: string;

  @ApiPropertyOptional({ example: 'SA1234567890123456789012', description: 'IBAN' })
  @IsString()
  @IsOptional()
  iban?: string;

  @ApiPropertyOptional({ example: 'NCBKSARI', description: 'SWIFT code' })
  @IsString()
  @IsOptional()
  swiftCode?: string;

  // Optional: Health
  @ApiPropertyOptional({ example: false, description: 'Has medical conditions' })
  @IsOptional()
  hasMedicalConditions?: boolean;

  @ApiPropertyOptional({ example: ['diabetes'], description: 'Medical conditions' })
  @IsOptional()
  medicalConditions?: string[];

  @ApiPropertyOptional({ example: 'O+', description: 'Blood type' })
  @IsString()
  @IsOptional()
  bloodType?: string;

  @ApiPropertyOptional({ example: ['peanuts'], description: 'Allergies' })
  @IsOptional()
  allergies?: string[];

  // Optional: Additional
  @ApiPropertyOptional({ example: 'https://...', description: 'Profile photo URL' })
  @IsString()
  @IsOptional()
  profilePhoto?: string;

  @ApiPropertyOptional({ example: ['Arabic', 'English'], description: 'Languages' })
  @IsOptional()
  languages?: string[];

  @ApiPropertyOptional({ example: 5, description: 'Experience years' })
  @IsNumber()
  @Min(0)
  @IsOptional()
  experienceYears?: number;
}
