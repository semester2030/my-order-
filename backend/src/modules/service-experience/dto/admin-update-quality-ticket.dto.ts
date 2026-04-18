import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { QualityTicketStatus } from '../service-experience.constants';

const ADMIN_STATUSES = [
  QualityTicketStatus.OPEN,
  QualityTicketStatus.IN_PROGRESS,
  QualityTicketStatus.CLOSED,
] as const;

export class AdminUpdateQualityTicketDto {
  @ApiPropertyOptional({ enum: ADMIN_STATUSES })
  @IsOptional()
  @IsString()
  @IsIn([...ADMIN_STATUSES])
  status?: QualityTicketStatus;

  @ApiPropertyOptional({ maxLength: 4000 })
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  adminNotes?: string;
}
