import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MinLength } from 'class-validator';

export class DeleteAccountDto {
  @ApiProperty({ description: 'كلمة المرور الحالية للتأكيد' })
  @IsString()
  @IsNotEmpty()
  @MinLength(6, { message: 'كلمة المرور قصيرة جداً' })
  currentPassword: string;
}
