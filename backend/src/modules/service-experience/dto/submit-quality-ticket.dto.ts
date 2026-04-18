import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
  MinLength,
  IsIn,
} from 'class-validator';
import {
  QUALITY_TICKET_CATEGORIES,
  ServiceReviewSubjectType,
} from '../service-experience.constants';

export class SubmitQualityTicketDto {
  @ApiProperty({ enum: ServiceReviewSubjectType })
  @IsEnum(ServiceReviewSubjectType)
  subjectType: ServiceReviewSubjectType;

  @ApiProperty()
  @IsUUID()
  subjectId: string;

  @ApiProperty({ enum: QUALITY_TICKET_CATEGORIES })
  @IsString()
  @IsIn([...QUALITY_TICKET_CATEGORIES])
  category: string;

  @ApiProperty({ minLength: 5, maxLength: 4000 })
  @IsString()
  @MinLength(5)
  @MaxLength(4000)
  privateMessage: string;

  @ApiPropertyOptional({
    description: 'درجات فرعية اختيارية (مثلاً { "cleanliness": 2, "punctuality": 4 })',
    type: 'object',
    additionalProperties: { type: 'number' },
  })
  @IsOptional()
  @IsObject()
  detailScores?: Record<string, number>;
}
