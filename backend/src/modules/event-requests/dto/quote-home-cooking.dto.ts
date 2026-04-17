import { IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';

export class QuoteHomeCookingDto {
  @IsNumber()
  @Min(0.01)
  quotedAmount: number;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  quoteNotes?: string;
}
