import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class DeclareHomeCookingPaymentDto {
  @IsString()
  @MinLength(3)
  @MaxLength(500)
  paymentReference: string;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  notes?: string;
}
