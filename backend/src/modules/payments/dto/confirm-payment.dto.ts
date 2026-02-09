import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ConfirmPaymentDto {
  @ApiProperty({ example: 'uuid', description: 'Payment ID' })
  @IsString()
  @IsNotEmpty()
  paymentId: string;

  @ApiProperty({ example: 'txn_123456', description: 'Transaction ID from gateway' })
  @IsString()
  @IsNotEmpty()
  transactionId: string;
}
