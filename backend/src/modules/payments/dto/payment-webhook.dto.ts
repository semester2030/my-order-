import { IsIn, IsNotEmpty, IsString, IsUUID } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class PaymentWebhookDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  paymentId: string;

  @ApiProperty({
    description: 'معرّف الجلسة كما أعيد من initiate (للمزوّد الوهمي: mock_pi_<paymentId>)',
  })
  @IsString()
  @IsNotEmpty()
  paymentIntentId: string;

  @ApiProperty({ example: 'payment.completed' })
  @IsString()
  @IsIn(['payment.completed'])
  event: string;
}
