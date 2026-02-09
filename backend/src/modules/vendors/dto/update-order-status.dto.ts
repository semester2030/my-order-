import { IsEnum, IsOptional, IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { OrderStatus } from '../../orders/entities/order.entity';

export class UpdateOrderStatusDto {
  @ApiProperty({
    example: 'preparing',
    enum: OrderStatus,
    description: 'New order status',
  })
  @IsEnum(OrderStatus)
  @IsNotEmpty()
  status: OrderStatus;

  @ApiPropertyOptional({ example: 'Order is being prepared', description: 'Status note' })
  @IsOptional()
  @IsString()
  note?: string;
}
