import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class VendorPasswordResetRequestDto {
  @ApiProperty({ example: 'vendor@example.com' })
  @IsEmail()
  @IsNotEmpty()
  email: string;
}
