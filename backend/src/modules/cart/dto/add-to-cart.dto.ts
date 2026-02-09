import { IsString, IsInt, Min, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class AddToCartDto {
  @ApiProperty({ example: 'uuid', description: 'Menu item ID' })
  @IsString()
  @IsNotEmpty()
  menuItemId: string;

  @ApiProperty({ example: 1, description: 'Quantity', minimum: 1 })
  @IsInt()
  @Min(1)
  quantity: number;
}
