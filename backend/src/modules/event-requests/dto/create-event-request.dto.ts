import { IsEnum, IsString, IsOptional, IsArray, IsBoolean, IsNumber, Min, IsUUID } from 'class-validator';
import { EventRequestType } from '../entities/event-request.entity';

export class AddOnDto {
  name: string;
  price?: number;
}

export class CreateEventRequestDto {
  @IsUUID()
  vendorId: string;

  @IsEnum(EventRequestType)
  requestType: EventRequestType;

  @IsString()
  scheduledDate: string; // YYYY-MM-DD

  @IsString()
  scheduledTime: string; // HH:mm

  @IsOptional()
  @IsNumber()
  @Min(1)
  guestsCount?: number;

  @IsOptional()
  @IsUUID()
  addressId?: string;

  @IsOptional()
  @IsArray()
  addOns?: AddOnDto[];

  @IsOptional()
  @IsArray()
  dishIds?: string[];

  @IsOptional()
  @IsBoolean()
  delivery?: boolean;

  @IsOptional()
  @IsString()
  notes?: string;
}
