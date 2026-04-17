import { IsString, IsNotEmpty, IsEnum, IsUUID } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { PaymentMethod } from '../entities/payment.entity';

export class InitiateHomeCookingCardPaymentDto {
  @ApiProperty({ format: 'uuid', description: 'Home cooking event_request id (quoted)' })
  @IsUUID()
  @IsNotEmpty()
  eventRequestId: string;

  @ApiProperty({
    example: 'mada',
    enum: PaymentMethod,
    description: 'Payment method',
  })
  @IsEnum(PaymentMethod)
  method: PaymentMethod;
}
