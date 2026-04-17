import {
  IsEnum,
  IsString,
  IsOptional,
  IsArray,
  IsBoolean,
  IsNumber,
  Min,
  IsUUID,
  ValidateIf,
  IsNotEmpty,
  Matches,
} from 'class-validator';
import {
  EventRequestType,
  ChefMealSlot,
} from '../entities/event-request.entity';

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

  /** طبخ منزلي: وقت حر HH:mm — مطلوب فقط إن لم تختر وجبة (فطور/غداء/عشاء) عبر mealSlot */
  @ValidateIf(
    (o: CreateEventRequestDto) =>
      o.requestType === EventRequestType.HOME_COOKING && o.mealSlot == null,
  )
  @IsString()
  @IsNotEmpty()
  @Matches(/^\d{2}:\d{2}(:\d{2})?$/)
  scheduledTime?: string;

  /** ذبائح/شواء: غداء أو عشاء (إلزامي في الخدمة). منزلي: فطور/غداء/عشاء اختياري بدلاً من وقت حر */
  @IsOptional()
  @IsEnum(ChefMealSlot)
  mealSlot?: ChefMealSlot;

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

  /** أطباق مخصصة بنص حر — العميل يكتب ما يريد (كبسة، إدام، سلطة...) */
  @IsOptional()
  @IsString()
  customDishNames?: string;

  @IsOptional()
  @IsBoolean()
  delivery?: boolean;

  @IsOptional()
  @IsString()
  notes?: string;
}
