import { IsString, IsNotEmpty, IsOptional, IsIn } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateOrderDto {
  @ApiProperty({ example: 'uuid', description: 'Address ID for delivery' })
  @IsString()
  @IsNotEmpty()
  addressId: string;

  @ApiPropertyOptional({
    example: 'Special instructions',
    description: 'Order notes',
  })
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({
    example: '2025-01-29T14:00:00.000Z',
    description: 'When customer wants order ready (ISO string)',
  })
  @IsOptional()
  @IsString()
  requestedReadyAt?: string;

  @ApiPropertyOptional({
    example: 'ready_now',
    description: 'ready_now | scheduled',
  })
  @IsOptional()
  @IsIn(['ready_now', 'scheduled'])
  orderType?: 'ready_now' | 'scheduled';
}
