import { IsEnum, IsString, IsOptional, IsArray, IsBoolean } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { StaffRole } from '../enums';

export class UpdateStaffDto {
  @ApiPropertyOptional({ example: 'manager', enum: StaffRole, description: 'Staff role' })
  @IsOptional()
  @IsEnum(StaffRole)
  role?: StaffRole;

  @ApiPropertyOptional({ example: ['orders.view', 'orders.update'], description: 'Custom permissions' })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  permissions?: string[];

  @ApiPropertyOptional({ example: true, description: 'Is active' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
