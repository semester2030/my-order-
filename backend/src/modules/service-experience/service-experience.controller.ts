import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { ServiceExperienceService } from './service-experience.service';
import { SubmitServiceReviewDto } from './dto/submit-service-review.dto';
import { SubmitQualityTicketDto } from './dto/submit-quality-ticket.dto';

@ApiTags('service-experience')
@Controller('service-experience')
export class ServiceExperienceController {
  constructor(private readonly serviceExperienceService: ServiceExperienceService) {}

  @Get('public/vendors/:vendorId/reviews')
  @ApiOperation({ summary: 'تقييمات عامة للمقدّم (بدون مصادقة)' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async listPublicVendorReviews(
    @Param('vendorId') vendorId: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.serviceExperienceService.listPublicVendorReviews(
      vendorId,
      page ? parseInt(page, 10) : 1,
      limit ? parseInt(limit, 10) : 20,
    );
  }

  @Post('reviews')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'إرسال تقييم نجمي + تعليق عام (مرة واحدة لكل خدمة)' })
  async submitReview(
    @Request() req: { user: User },
    @Body() dto: SubmitServiceReviewDto,
  ) {
    return this.serviceExperienceService.submitReview(req.user.id, dto);
  }

  @Post('quality-tickets')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'بلاغ جودة خاص للإدارة (رسالة خاصة + درجات فرعية اختيارية)' })
  async submitQualityTicket(
    @Request() req: { user: User },
    @Body() dto: SubmitQualityTicketDto,
  ) {
    return this.serviceExperienceService.submitQualityTicket(req.user.id, dto);
  }
}
