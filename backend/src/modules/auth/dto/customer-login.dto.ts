import { IsEmail, IsString, IsNotEmpty, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CustomerLoginDto {
  @ApiProperty({ example: 'customer@example.com', description: 'البريد الإلكتروني' })
  @IsEmail({}, { message: 'بريد إلكتروني غير صحيح' })
  @IsNotEmpty({ message: 'البريد مطلوب' })
  email: string;

  @ApiProperty({ example: 'password123', description: 'الرمز السري' })
  @IsString()
  @IsNotEmpty({ message: 'الرمز السري مطلوب' })
  @MinLength(6, { message: 'الرمز السري غير صحيح' })
  password: string;
}
