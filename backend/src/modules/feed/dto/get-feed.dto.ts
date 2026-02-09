import { IsOptional, IsInt, Min, Max, IsIn, IsString } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

export const FEED_SORT_VALUES = ['distance', 'rating', 'newest'] as const;
export type FeedSortBy = (typeof FEED_SORT_VALUES)[number];

export class GetFeedDto {
  @ApiPropertyOptional({ example: 1, description: 'Page number', default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ example: 10, description: 'Items per page', default: 10 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number = 10;

  @ApiPropertyOptional({ example: 'fine_dining', description: 'Filter by vendor type' })
  @IsOptional()
  vendorType?: string;

  @ApiPropertyOptional({ example: 'home_cooking', description: 'Filter by provider category' })
  @IsOptional()
  category?: string;

  @ApiPropertyOptional({
    example: 'distance',
    description: 'Sort by: distance | rating | newest',
    enum: FEED_SORT_VALUES,
  })
  @IsOptional()
  @IsIn(FEED_SORT_VALUES)
  sortBy?: FeedSortBy;

  @ApiPropertyOptional({ example: 'الرياض', description: 'Filter by vendor city' })
  @IsOptional()
  @IsString()
  city?: string;
}
