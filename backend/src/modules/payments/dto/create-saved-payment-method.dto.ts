import { ApiProperty } from '@nestjs/swagger';
import {
  IsInt,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

/**
 * إضافة بطاقة مدا محفوظة — لا يُرسل رقم البطاقة الكامل ولا CVV.
 * العميل يرسل last4 + الصلاحية + اسم الحامل فقط (بعد التحقق محلياً).
 */
export class CreateSavedPaymentMethodDto {
  @ApiProperty({ example: 'Ahmed Ali' })
  @IsString()
  @MinLength(2)
  @MaxLength(120)
  holderName: string;

  @ApiProperty({ example: '4242', description: 'آخر 4 أرقام' })
  @IsString()
  @Matches(/^\d{4}$/)
  last4: string;

  @ApiProperty({ example: 12, minimum: 1, maximum: 12 })
  @IsInt()
  @Min(1)
  @Max(12)
  expMonth: number;

  @ApiProperty({
    example: 2028,
    description: 'سنة كاملة (مثلاً 2028) أو رقمان للسنة (يُحوَّل في الخدمة)',
  })
  @IsInt()
  @Min(2024)
  @Max(2100)
  expYear: number;
}
