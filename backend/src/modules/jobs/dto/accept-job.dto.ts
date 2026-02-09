import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';

export class AcceptJobDto {
  @ApiProperty({
    example: 'job-offer-id',
    description: 'Job offer ID',
  })
  @IsNotEmpty()
  jobOfferId: string;
}
