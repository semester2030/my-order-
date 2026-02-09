import { IsEnum, IsString, IsOptional, IsArray, IsEmail, IsNotEmpty, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { StaffRole } from '../enums';

export class AddStaffDto {
  @ApiProperty({ example: 'john@example.com', description: 'Staff email' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'John Doe', description: 'Staff name' })
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name: string;

  @ApiProperty({ example: '+966501234567', description: 'Staff phone number' })
  @IsString()
  @IsNotEmpty()
  phone: string;

  @ApiProperty({ example: 'manager', enum: StaffRole, description: 'Staff role' })
  @IsEnum(StaffRole)
  @IsNotEmpty()
  role: StaffRole;

  @ApiPropertyOptional({ example: ['orders.view', 'orders.update'], description: 'Custom permissions' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  permissions?: string[];
}
