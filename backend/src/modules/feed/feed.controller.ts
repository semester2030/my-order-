import { Controller, Get, UseGuards, Request, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { FeedService } from './feed.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { GetFeedDto } from './dto/get-feed.dto';

@ApiTags('feed')
@Controller('feed')
export class FeedController {
  constructor(private readonly feedService: FeedService) {}

  @Get('browse')
  @ApiOperation({
    summary: 'Public feed browse (no account — App Store guest exploration)',
  })
  async browseFeed(@Query() query: GetFeedDto) {
    return this.feedService.getFeed(null, query);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get feed page with video-first content' })
  async getFeed(@Request() req: { user: User }, @Query() query: GetFeedDto) {
    return this.feedService.getFeed(req.user.id, query);
  }
}
