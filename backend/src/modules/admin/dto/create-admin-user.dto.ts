import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  IsString,
  MinLength,
  Matches,
} from 'class-validator';

export class CreateAdminUserDto {
  @ApiProperty({ example: 'ops@platform.com' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'اسم المشرف' })
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name: string;

  @ApiProperty({
    example: 'SecurePass123',
    description: '8+ أحرف، حرف كبير وصغير ورقم',
  })
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, {
    message:
      'Password must contain at least one lowercase, one uppercase, and one number',
  })
  password: string;

  @ApiProperty({
    example: 'ops',
    description:
      'slug من admin_roles: super_admin, ops, finance, support, quality',
  })
  @IsString()
  @IsNotEmpty()
  roleSlug: string;
}
