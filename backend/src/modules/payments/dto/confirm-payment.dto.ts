import { IsString, IsNotEmpty, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ConfirmPaymentDto {
  @ApiProperty({ example: 'uuid', description: 'Payment ID' })
  @IsString()
  @IsNotEmpty()
  paymentId: string;

  @ApiPropertyOptional({
    deprecated: true,
    description:
      'يُتجاهَل أمنياً — لا يُستخدم لإثبات نجاح الدفع. الإكمال من السيرفر/webhook فقط.',
  })
  @IsOptional()
  @IsString()
  transactionId?: string;
}
