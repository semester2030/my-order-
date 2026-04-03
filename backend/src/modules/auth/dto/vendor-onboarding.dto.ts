import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, Length } from 'class-validator';

export class VendorOnboardingVerifyEmailDto {
  @ApiProperty({ example: '123456' })
  @IsString()
  @IsNotEmpty()
  @Length(4, 8)
  code: string;
}

export class VendorOnboardingAcceptLegalDto {
  @ApiProperty({
    description: 'يجب أن يطابق LEGAL_TERMS_VERSION في الخادم',
    example: '2026.04.01',
  })
  @IsString()
  @IsNotEmpty()
  documentVersion: string;
}
