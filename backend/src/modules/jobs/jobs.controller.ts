import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
} from '@nestjs/swagger';
import { JobsService } from './jobs.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AcceptJobDto } from './dto/accept-job.dto';

@ApiTags('jobs')
@Controller('jobs')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class JobsController {
  constructor(private readonly jobsService: JobsService) {}

  @Get('inbox')
  @ApiOperation({ summary: 'Get available jobs (inbox)' })
  @ApiResponse({ status: 200, description: 'Jobs retrieved successfully' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async getInbox(@Request() req: any) {
    const userId = req.user.id;
    return this.jobsService.getInbox(userId);
  }

  @Get('active')
  @ApiOperation({ summary: 'Get active job' })
  @ApiResponse({ status: 200, description: 'Active job retrieved' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async getActiveJob(@Request() req: any) {
    const userId = req.user.id;
    return this.jobsService.getActiveJob(userId);
  }

  @Get('history')
  @ApiOperation({ summary: 'Get delivery history and total earnings' })
  @ApiResponse({ status: 200, description: 'Delivery history retrieved' })
  @ApiResponse({ status: 404, description: 'Driver not found' })
  async getDeliveryHistory(@Request() req: any) {
    const userId = req.user.id;
    return this.jobsService.getDeliveryHistory(userId);
  }

  @Post('accept')
  @ApiOperation({ summary: 'Accept job' })
  @ApiResponse({ status: 200, description: 'Job accepted successfully' })
  @ApiResponse({ status: 404, description: 'Job not found' })
  @ApiResponse({ status: 409, description: 'Job already taken' })
  async acceptJob(@Request() req: any, @Body() dto: AcceptJobDto) {
    const userId = req.user.id;
    return this.jobsService.acceptJob(dto.jobOfferId, userId);
  }

  @Post('reject/:jobOfferId')
  @ApiOperation({ summary: 'Reject job' })
  @ApiResponse({ status: 200, description: 'Job rejected' })
  @ApiResponse({ status: 404, description: 'Job not found' })
  async rejectJob(@Request() req: any, @Param('jobOfferId') jobOfferId: string) {
    const userId = req.user.id;
    return this.jobsService.rejectJob(jobOfferId, userId);
  }
}
