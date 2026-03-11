import { IsString, IsNumber, Min, IsOptional, IsBoolean, IsIn } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EVENT_SERVICE_TYPES, EVENT_TYPES } from '../entities/event-offer.entity';

export class CreateEventOfferDto {
  @ApiProperty({ enum: EVENT_SERVICE_TYPES })
  @IsString()
  @IsIn(EVENT_SERVICE_TYPES)
  serviceType: string;

  @ApiProperty({ enum: EVENT_TYPES })
  @IsString()
  @IsIn(EVENT_TYPES)
  eventType: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(0)
  pricePerPerson?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(0)
  priceTotal?: number;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @IsNumber()
  @Min(1)
  minGuests?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(1)
  maxGuests?: number;

  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
