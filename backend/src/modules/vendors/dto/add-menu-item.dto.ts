import {
  IsString,
  IsNumber,
  IsOptional,
  IsBoolean,
  IsNotEmpty,
  Min,
  MinLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AddMenuItemDto {
  @ApiProperty({ example: 'Grilled Chicken', description: 'Menu item name' })
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name: string;

  @ApiPropertyOptional({
    example: 'Delicious grilled chicken with herbs',
    description: 'Menu item description',
  })
  @IsOptional()
  @IsString()
  description?: string;

  /** اختياري لمطبخ منزلي (null/إهمال = بدون سعر معروض — التسعير عند الطلب) */
  @ApiPropertyOptional({ example: 45.5, description: 'Menu item price' })
  @IsOptional()
  @IsNumber()
  @Min(0)
  price?: number;

  @ApiPropertyOptional({ example: true, description: 'Is signature dish' })
  @IsOptional()
  @IsBoolean()
  isSignature?: boolean;

  @ApiPropertyOptional({ example: true, description: 'Is available' })
  @IsOptional()
  @IsBoolean()
  isAvailable?: boolean;
}
