import {
  IsString,
  IsNotEmpty,
  IsEmail,
  IsOptional,
  IsEnum,
  IsNumber,
  IsBoolean,
  Matches,
  MinLength,
  IsUrl,
  IsDateString,
  ValidateIf,
  Min,
  Max,
} from 'class-validator';
import { Type, Transform } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { VendorType } from '../entities/vendor.entity';

/** FormData sends strings; coerce to number or undefined when empty */
function toNumber(v: unknown): number | undefined {
  if (v === undefined || v === null || v === '') return undefined;
  const n = Number(v);
  return Number.isNaN(n) ? undefined : n;
}
/** FormData sends "true"/"false"; coerce to boolean or undefined when empty */
function toBoolean(v: unknown): boolean | undefined {
  if (v === undefined || v === null || v === '') return undefined;
  if (typeof v === 'boolean') return v;
  const s = String(v).toLowerCase();
  return s === 'true' || s === '1' ? true : s === 'false' || s === '0' ? false : undefined;
}

/**
 * تسجيل مقدم الخدمة — الضروري فقط: الاسم، الإيميل، كلمة المرور.
 * باقي الحقول اختيارية ويمكن إكمالها لاحقاً من لوحة التحكم.
 */
export class RegisterVendorDto {
  // --- الضروري فقط ---
  @ApiProperty({ example: 'مطبخ أم محمد', description: 'اسم مقدم الخدمة / المنشأة' })
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name: string;

  @ApiProperty({ example: 'vendor@example.com', description: 'البريد الإلكتروني' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'SecurePass123', description: 'كلمة المرور (8+ أحرف، حرف كبير وصغير ورقم)' })
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, {
    message: 'Password must contain at least one lowercase, one uppercase, and one number',
  })
  password: string;

  // --- اختياري: باقي البيانات ---
  @ApiPropertyOptional({ example: 'Al Baik Trading Co.', description: 'الاسم التجاري' })
  @IsOptional()
  @IsString()
  @MinLength(2)
  tradeName?: string;

  @ApiPropertyOptional({ example: 'premium_casual', enum: VendorType })
  @IsOptional()
  @IsEnum(VendorType)
  type?: VendorType;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({
    example: 'home_cooking',
    description: 'فئة الخدمة: home_cooking | popular_cooking | private_events | grilling',
  })
  @IsOptional()
  @IsString()
  @ValidateIf((o) => o.providerCategory != null && o.providerCategory !== '')
  @Matches(/^(home_cooking|popular_cooking|private_events|grilling)$/, {
    message: 'providerCategory must be one of: home_cooking, popular_cooking, private_events, grilling',
  })
  providerCategory?: string;

  @ApiPropertyOptional({ example: '0501234567' })
  @IsOptional()
  @IsString()
  @Matches(/^[0-9+\-\s()]*$/, {
    message: 'Phone must contain only digits, +, -, spaces, or parentheses',
  })
  phoneNumber?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUrl()
  website?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  commercialRegistrationNumber?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  commercialRegistrationIssueDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  commercialRegistrationExpiryDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  address?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  city?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  district?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  postalCode?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  deliveryFee?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  deliveryRadius?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(5)
  estimatedDeliveryTime?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  ownerName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Matches(/^[0-9+\-\s()]*$/, { message: 'Owner phone: digits, +, -, spaces, parentheses only' })
  ownerPhone?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsEmail()
  ownerEmail?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  ownerIdNumber?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  ownerNationality?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  ownerAddress?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  bankName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  bankAccountNumber?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @ValidateIf((o) => o.iban !== undefined && o.iban !== '')
  @Matches(/^SA\d{22}$/, { message: 'IBAN must be SA + 22 digits' })
  iban?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  accountHolderName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  swiftCode?: string;

  @ApiPropertyOptional({ description: 'قبول الشروط والأحكام' })
  @IsOptional()
  @Transform(({ value }) => toBoolean(value))
  @IsBoolean()
  termsAccepted?: boolean;

  @ApiPropertyOptional({ description: 'قبول سياسة الخصوصية' })
  @IsOptional()
  @Transform(({ value }) => toBoolean(value))
  @IsBoolean()
  privacyAccepted?: boolean;

  /** للطبخ الشعبي: خدمات إضافية (جريش، قرصان، ادامات…) — JSON string: [{ name, price }] */
  @ApiPropertyOptional({
    description: 'Popular cooking add-ons: JSON array of { name, price }. e.g. [{"name":"جريش","price":50}]',
  })
  @IsOptional()
  @IsString()
  popularCookingAddOns?: string;
}
