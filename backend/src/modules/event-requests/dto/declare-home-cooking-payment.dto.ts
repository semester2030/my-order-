import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';

export enum ServicePaymentMethod {
  STC_BANK = 'stc_bank',
  CASH = 'cash',
}

export class DeclareHomeCookingPaymentDto {
  @IsOptional()
  @IsEnum(ServicePaymentMethod)
  paymentMethod?: ServicePaymentMethod;

  /** اختياري — لا يُطلب من العميل؛ يُستخدم للأرشفة فقط إن وُجد */
  @IsOptional()
  @IsString()
  @MaxLength(500)
  paymentReference?: string;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  notes?: string;
}
