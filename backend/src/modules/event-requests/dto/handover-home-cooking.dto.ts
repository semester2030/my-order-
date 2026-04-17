import { IsOptional, IsString, MaxLength } from 'class-validator';

/** تأكيد تسليم الطلب من المطبخ (للعميل بنفسه أو لمندوب/وسيط). */
export class HandoverHomeCookingDto {
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  handoverNotes?: string;
}
