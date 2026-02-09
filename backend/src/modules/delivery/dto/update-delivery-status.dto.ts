import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty } from 'class-validator';
import { OrderStatus } from '../../orders/entities/order.entity';

export class UpdateDeliveryStatusDto {
  @ApiProperty({
    example: 'picked_up',
    enum: [
      OrderStatus.OUT_FOR_DELIVERY,
      'picked_up', // Custom status for driver
      'delivered',
    ],
    description: 'Delivery status',
  })
  @IsEnum([
    OrderStatus.OUT_FOR_DELIVERY,
    'picked_up',
    OrderStatus.DELIVERED,
  ])
  @IsNotEmpty()
  status: OrderStatus | 'picked_up';
}
