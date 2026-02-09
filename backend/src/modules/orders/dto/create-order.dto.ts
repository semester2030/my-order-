import { IsString, IsNotEmpty, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateOrderDto {
  @ApiProperty({ example: 'uuid', description: 'Address ID for delivery' })
  @IsString()
  @IsNotEmpty()
  addressId: string;

  @ApiPropertyOptional({ example: 'Special instructions', description: 'Order notes' })
  @IsOptional()
  @IsString()
  notes?: string;
}
