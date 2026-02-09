import { IsString, IsNumber, IsOptional, IsBoolean, IsNotEmpty, Min, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AddMenuItemDto {
  @ApiProperty({ example: 'Grilled Chicken', description: 'Menu item name' })
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name: string;

  @ApiPropertyOptional({ example: 'Delicious grilled chicken with herbs', description: 'Menu item description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ example: 45.50, description: 'Menu item price' })
  @IsNumber()
  @Min(0)
  price: number;

  @ApiPropertyOptional({ example: true, description: 'Is signature dish' })
  @IsOptional()
  @IsBoolean()
  isSignature?: boolean;

  @ApiPropertyOptional({ example: true, description: 'Is available' })
  @IsOptional()
  @IsBoolean()
  isAvailable?: boolean;
}
