import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsOptional, IsString, MinLength } from 'class-validator';
import { Type } from 'class-transformer';

export class UpdateAdminUserDto {
  @ApiPropertyOptional({ example: 'اسم محدّث' })
  @IsOptional()
  @IsString()
  @MinLength(2)
  name?: string;

  @ApiPropertyOptional({
    example: 'finance',
    description: 'تغيير دور المستخدم (مع حماية آخر super_admin)',
  })
  @IsOptional()
  @IsString()
  roleSlug?: string;

  @ApiPropertyOptional({ example: false })
  @IsOptional()
  @Type(() => Boolean)
  @IsBoolean()
  isActive?: boolean;
}
