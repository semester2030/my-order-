import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { ServiceReviewSubjectType } from '../service-experience.constants';

export class SubmitServiceReviewDto {
  @ApiProperty({ enum: ServiceReviewSubjectType })
  @IsEnum(ServiceReviewSubjectType)
  subjectType: ServiceReviewSubjectType;

  @ApiProperty()
  @IsUUID()
  subjectId: string;

  @ApiProperty({ minimum: 1, maximum: 5 })
  @IsInt()
  @Min(1)
  @Max(5)
  stars: number;

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  publicComment?: string;
}
