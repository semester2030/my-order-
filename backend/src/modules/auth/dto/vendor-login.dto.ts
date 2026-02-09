import { IsEmail, IsString, IsNotEmpty, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VendorLoginDto {
  @ApiProperty({ example: 'vendor@restaurant.com', description: 'Vendor email' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'password123', description: 'Vendor password' })
  @IsString()
  @IsNotEmpty()
  @MinLength(6)
  password: string;
}
