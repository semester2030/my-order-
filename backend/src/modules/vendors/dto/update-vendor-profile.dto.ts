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
  Min,
  Max,
  IsArray,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { VendorType } from '../entities/vendor.entity';

export class PopularCookingAddOnItemDto {
  @ApiProperty({ example: 'جريش', description: 'اسم الطبق الجانبي' })
  @IsString()
  @MinLength(1)
  name: string;

  @ApiProperty({ example: 50, description: 'السعر' })
  @IsNumber()
  @Min(0)
  price: number;
}

export class UpdateVendorProfileDto {
  @ApiPropertyOptional({ example: 'Al Baik Restaurant', description: 'Restaurant name' })
  @IsOptional()
  @IsString()
  @MinLength(2)
  name?: string;

  @ApiPropertyOptional({ example: 'Al Baik Trading Co.', description: 'Trade name' })
  @IsOptional()
  @IsString()
  @MinLength(2)
  tradeName?: string;

  @ApiPropertyOptional({
    example: 'premium_casual',
    enum: VendorType,
    description: 'Restaurant type',
  })
  @IsOptional()
  @IsEnum(VendorType)
  type?: VendorType;

  @ApiPropertyOptional({ example: 'Best fried chicken in town', description: 'Description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ example: 'restaurant@example.com', description: 'Email address' })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ example: '0501234567', description: 'Phone number' })
  @IsOptional()
  @IsString()
  @Matches(/^[0-9+\-\s()]+$/, {
    message: 'Phone number must contain only digits, +, -, spaces, or parentheses',
  })
  phoneNumber?: string;

  @ApiPropertyOptional({ example: 'https://www.restaurant.com', description: 'Website URL' })
  @IsOptional()
  @IsUrl()
  website?: string;

  // Location
  @ApiPropertyOptional({ example: 24.7136, description: 'Latitude' })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude?: number;

  @ApiPropertyOptional({ example: 46.6753, description: 'Longitude' })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude?: number;

  @ApiPropertyOptional({ example: '123 Main Street', description: 'Full address' })
  @IsOptional()
  @IsString()
  address?: string;

  @ApiPropertyOptional({ example: 'Riyadh', description: 'City' })
  @IsOptional()
  @IsString()
  city?: string;

  @ApiPropertyOptional({ example: 'Al Olaya', description: 'District' })
  @IsOptional()
  @IsString()
  district?: string;

  @ApiPropertyOptional({ example: '12345', description: 'Postal code' })
  @IsOptional()
  @IsString()
  postalCode?: string;

  // Delivery
  @ApiPropertyOptional({ example: 15.0, description: 'Delivery fee' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  deliveryFee?: number;

  @ApiPropertyOptional({ example: 10, description: 'Delivery radius in kilometers' })
  @IsOptional()
  @IsNumber()
  @Min(1)
  deliveryRadius?: number;

  @ApiPropertyOptional({ example: 30, description: 'Estimated delivery time in minutes' })
  @IsOptional()
  @IsNumber()
  @Min(5)
  estimatedDeliveryTime?: number;

  // Working Hours
  @ApiPropertyOptional({
    example: [
      { day: 'monday', open: '09:00', close: '22:00', isOpen: true },
      { day: 'tuesday', open: '09:00', close: '22:00', isOpen: true },
    ],
    description: 'Working hours',
  })
  @IsOptional()
  @IsArray()
  workingHours?: Array<{
    day: string;
    open: string;
    close: string;
    isOpen: boolean;
  }>;

  // Status
  @ApiPropertyOptional({ example: true, description: 'Is accepting orders' })
  @IsOptional()
  @IsBoolean()
  isAcceptingOrders?: boolean;

  @ApiPropertyOptional({ example: true, description: 'Is active (for development/testing)' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  /** للطبخ الشعبي فقط: الطلبات الجانبية (جريش، قرصان، ادامات…) */
  @ApiPropertyOptional({
    description: 'Popular cooking: side orders (name + price each)',
    type: [PopularCookingAddOnItemDto],
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PopularCookingAddOnItemDto)
  popularCookingAddOns?: { name: string; price: number }[];
}
