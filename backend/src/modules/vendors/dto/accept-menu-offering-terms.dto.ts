import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class AcceptMenuOfferingTermsDto {
  @ApiProperty({
    description: 'يجب أن يطابق GENERAL_MENU_OFFERING_TERMS_VERSION في الخادم',
    example: '2026.04.01',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(64)
  documentVersion: string;
}
