import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNotEmpty } from 'class-validator';

export class UpdateDriverAvailabilityDto {
  @ApiProperty({
    example: true,
    description: 'Driver online status',
  })
  @IsBoolean()
  @IsNotEmpty()
  isOnline: boolean;
}
