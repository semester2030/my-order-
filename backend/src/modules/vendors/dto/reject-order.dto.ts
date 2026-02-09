import { IsString, IsNotEmpty, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RejectOrderDto {
  @ApiProperty({ example: 'Out of stock', description: 'Rejection reason' })
  @IsString()
  @IsNotEmpty()
  @MinLength(5)
  reason: string;
}
