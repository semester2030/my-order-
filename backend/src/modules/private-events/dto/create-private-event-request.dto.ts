import {
  IsString,
  IsUUID,
  IsArray,
  ValidateNested,
  IsNumber,
  Min,
  IsOptional,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class PrivateEventServiceDto {
  @ApiProperty({
    example: 'buffet',
    description: 'buffet | desserts | drinks | staff',
  })
  @IsString()
  serviceType: string;

  @ApiProperty({ example: 50 })
  @IsNumber()
  @Min(1)
  guestsCount: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;
}

export class CreatePrivateEventRequestDto {
  @ApiProperty()
  @IsUUID()
  vendorId: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  addressId?: string;

  @ApiProperty({
    example: 'wedding',
    description: 'wedding | graduation | henna | engagement | other',
  })
  @IsString()
  eventType: string;

  @ApiProperty({ example: '2025-02-15', description: 'YYYY-MM-DD' })
  @IsString()
  eventDate: string;

  @ApiProperty({ example: '18:00', description: 'HH:mm' })
  @IsString()
  eventTime: string;

  @ApiProperty({ example: 50 })
  @IsNumber()
  @Min(1)
  guestsCount: number;

  @ApiProperty({ type: [PrivateEventServiceDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PrivateEventServiceDto)
  services: PrivateEventServiceDto[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;
}
