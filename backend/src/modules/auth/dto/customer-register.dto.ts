import { IsEmail, IsString, IsNotEmpty, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CustomerRegisterDto {
  @ApiProperty({ example: 'أحمد محمد', description: 'الاسم' })
  @IsString()
  @IsNotEmpty({ message: 'الاسم مطلوب' })
  @MinLength(2, { message: 'الاسم قصير جداً' })
  name: string;

  @ApiProperty({ example: 'customer@example.com', description: 'البريد الإلكتروني' })
  @IsEmail({}, { message: 'بريد إلكتروني غير صحيح' })
  @IsNotEmpty({ message: 'البريد مطلوب' })
  email: string;

  @ApiProperty({ example: 'password123', description: 'الرمز السري (6 أحرف على الأقل)' })
  @IsString()
  @IsNotEmpty({ message: 'الرمز السري مطلوب' })
  @MinLength(6, { message: 'الرمز السري يجب أن يكون 6 أحرف على الأقل' })
  password: string;
}
