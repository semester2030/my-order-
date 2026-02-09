import {
  Controller,
  Post,
  Get,
  Delete,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  Param,
  Request,
  NotFoundException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import * as multer from 'multer';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';
import { VideosService } from './videos.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { VendorsService } from '../vendors/vendors.service';
import { User } from '../users/entities/user.entity';

@ApiTags('videos')
@Controller('videos')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class VideosController {
  constructor(
    private readonly videosService: VideosService,
    private readonly vendorsService: VendorsService,
  ) {}

  private async getVendorId(req: { user: User }): Promise<string> {
    const vendorId = await this.vendorsService.getVendorIdByUserId(req.user.id);
    if (!vendorId) throw new NotFoundException('Vendor not found for this user');
    return vendorId;
  }

  @Get('vendor')
  @ApiOperation({ summary: 'List all videos for current vendor (max 20)' })
  async getVendorVideos(@Request() req: { user: User }) {
    const vendorId = await this.getVendorId(req);
    return this.videosService.getVendorVideos(vendorId);
  }

  @Get('vendor/count')
  @ApiOperation({ summary: 'Get current video count and max (20)' })
  async getVendorVideoCount(@Request() req: { user: User }) {
    const vendorId = await this.getVendorId(req);
    const count = await this.videosService.getVendorVideoCount(vendorId);
    return { count, max: 20 };
  }

  // IMPORTANT: Specific routes must come BEFORE dynamic routes
  // Otherwise /upload/:menuItemId will catch /upload/init and /upload/complete

  @Post('upload/init')
  @ApiOperation({ summary: 'Initialize video upload' })
  @HttpCode(HttpStatus.OK)
  async initUpload(
    @Request() req: { user: User },
    @Body() body: { menuItemId: string; fileName: string; fileSize: number },
  ) {
    const vendorId = await this.getVendorId(req);
    return this.videosService.initUpload(
      body.menuItemId,
      body.fileName,
      body.fileSize,
      vendorId,
    );
  }

  @Post('upload/complete')
  @ApiOperation({ summary: 'Complete video upload' })
  @HttpCode(HttpStatus.OK)
  async completeUpload(
    @Request() req: { user: User },
    @Body()
    body: {
      uploadId: string;
      menuItemId: string;
      cloudflareAssetId: string;
    },
  ) {
    const vendorId = await this.getVendorId(req);
    return this.videosService.completeUpload(
      body.uploadId,
      body.menuItemId,
      body.cloudflareAssetId,
      vendorId,
    );
  }

  // Dynamic route must come AFTER specific routes
  @Post('upload/:menuItemId')
  @ApiOperation({ summary: 'Upload video file (server-side upload to avoid CORS)' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('video', {
      storage: multer.memoryStorage(), // Store in memory (we'll upload to Cloudflare immediately)
      limits: {
        fileSize: 500 * 1024 * 1024, // 500MB max
      },
      fileFilter: (req, file, cb) => {
        // Allow video files
        if (file.mimetype.startsWith('video/')) {
          cb(null, true);
        } else {
          cb(new Error('Invalid file type. Only video files are allowed.'), false);
        }
      },
    }),
  )
  @HttpCode(HttpStatus.OK)
  async uploadVideo(
    @Request() req: { user: User },
    @Param('menuItemId') menuItemId: string,
    @UploadedFile() file: Express.Multer.File,
  ) {
    if (!file) {
      throw new Error('Video file is required');
    }
    const vendorId = await this.getVendorId(req);
    console.log('Received video upload request:', {
      menuItemId,
      fileName: file.originalname,
      fileSize: file.size,
      mimeType: file.mimetype,
    });
    return this.videosService.uploadVideoFromServer(menuItemId, file, vendorId);
  }

  @Delete(':videoId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a video (to free a slot for a new one)' })
  async deleteVideo(@Request() req: { user: User }, @Param('videoId') videoId: string) {
    const vendorId = await this.getVendorId(req);
    await this.videosService.deleteVideo(videoId, vendorId);
  }
}
