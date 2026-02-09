import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as FormData from 'form-data';
import { CloudflareStreamService } from './cloudflare/cloudflare-stream.service';
import { VideoAsset, VideoStatus } from '../menu/entities/video-asset.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';

/** أقصى عدد مقاطع فيديو لكل حساب طباخ — لا يمكن تجاوزه دون حذف مقطع */
export const MAX_VIDEOS_PER_VENDOR = 20;

@Injectable()
export class VideosService {
  constructor(
    private readonly cloudflareStreamService: CloudflareStreamService,
    @InjectRepository(VideoAsset)
    private readonly videoAssetRepository: Repository<VideoAsset>,
    @InjectRepository(MenuItem)
    private readonly menuItemRepository: Repository<MenuItem>,
    private readonly configService: ConfigService,
  ) {}

  /** عدد مقاطع الفيديو الحالية لهذا المورد */
  async getVendorVideoCount(vendorId: string): Promise<number> {
    const menuItems = await this.menuItemRepository.find({
      where: { vendorId },
      select: ['id'],
    });
    const menuItemIds = menuItems.map((m) => m.id);
    if (menuItemIds.length === 0) return 0;
    return this.videoAssetRepository.count({
      where: { menuItemId: In(menuItemIds) },
    });
  }

  /** التأكد أن المورد لم يصل للحد الأقصى قبل إضافة فيديو جديد */
  async ensureVendorCanAddVideo(menuItemId: string, vendorId: string): Promise<void> {
    const menuItem = await this.menuItemRepository.findOne({
      where: { id: menuItemId, vendorId },
    });
    if (!menuItem) {
      throw new NotFoundException('MenuItem not found or not owned by this vendor');
    }
    const count = await this.getVendorVideoCount(vendorId);
    if (count >= MAX_VIDEOS_PER_VENDOR) {
      throw new BadRequestException(
        `Maximum ${MAX_VIDEOS_PER_VENDOR} videos per vendor. Delete one to add a new video. / الحد الأقصى ${MAX_VIDEOS_PER_VENDOR} مقطع. احذف مقطعاً لإضافة جديد.`,
      );
    }
  }

  async initUpload(menuItemId: string, fileName: string, fileSize: number, vendorId: string) {
    await this.ensureVendorCanAddVideo(menuItemId, vendorId);
    // Validate file size (max 500MB)
    if (fileSize > 500 * 1024 * 1024) {
      throw new Error('File size must be less than 500MB');
    }

    // Call Cloudflare Stream API to get upload URL and asset ID
    const { uploadURL, uid } = await this.cloudflareStreamService.initUpload(
      fileName,
      fileSize,
    );

    return {
      uploadId: uid, // Use Cloudflare's uid as uploadId
      uploadUrl: uploadURL,
      cloudflareAssetId: uid, // Also return asset ID for frontend
      expiresAt: new Date(Date.now() + 3600000).toISOString(), // 1 hour
    };
  }

  async completeUpload(
    uploadId: string,
    menuItemId: string,
    cloudflareAssetId: string,
    vendorId: string,
  ) {
    await this.ensureVendorCanAddVideo(menuItemId, vendorId);
    // Wait a bit for Cloudflare to process the video after upload
    // Videos may take a few seconds to be ready
    await new Promise(resolve => setTimeout(resolve, 3000));

    // Get asset details from Cloudflare (with retry logic)
    let assetDetails;
    let retries = 3;
    while (retries > 0) {
      try {
        assetDetails = await this.cloudflareStreamService.getAssetDetails(
          cloudflareAssetId,
        );
        break;
      } catch (error) {
        retries--;
        if (retries === 0) {
          // If still failing, use default values and set status to PROCESSING
          // We'll construct a default playback URL - Cloudflare will process it
          const accountId = this.configService.get<string>('CLOUDFLARE_ACCOUNT_ID') || 'unknown';
          assetDetails = {
            playbackUrl: `https://customer-${accountId}.cloudflarestream.com/${cloudflareAssetId}/manifest/video.m3u8`,
            thumbnailUrl: null,
            duration: 0,
          };
        } else {
          // Wait before retry
          await new Promise(resolve => setTimeout(resolve, 2000));
        }
      }
    }

    // Check if this is the first video for this menu item
    const existingVideos = await this.videoAssetRepository.find({
      where: { menuItemId },
    });

    // If this is the first video, set it as primary
    // Otherwise, if there's no primary video yet, set this one as primary
    const hasPrimaryVideo = existingVideos.some((v) => v.isPrimary);
    const isPrimary = existingVideos.length === 0 || !hasPrimaryVideo;

    // If we're setting this as primary, unset other primary videos for this menu item
    if (isPrimary && hasPrimaryVideo) {
      await this.videoAssetRepository.update(
        { menuItemId, isPrimary: true },
        { isPrimary: false },
      );
    }

    // Determine status - if duration is 0, video is still processing
    const status = assetDetails.duration > 0 ? VideoStatus.READY : VideoStatus.PROCESSING;

    // Convert duration to integer (round to nearest second)
    // Cloudflare returns decimal duration, but database expects integer
    const durationInSeconds = Math.round(assetDetails.duration);

    // Save to database
    const videoAsset = this.videoAssetRepository.create({
      menuItemId,
      cloudflareAssetId,
      playbackUrl: assetDetails.playbackUrl,
      thumbnailUrl: assetDetails.thumbnailUrl,
      duration: durationInSeconds, // Convert to integer
      status,
      isPrimary, // Set to true if it's the first video or if no primary exists
    });

    const savedVideoAsset = await this.videoAssetRepository.save(videoAsset);

    return savedVideoAsset;
  }

  async uploadVideoFromServer(menuItemId: string, file: Express.Multer.File, vendorId: string) {
    await this.ensureVendorCanAddVideo(menuItemId, vendorId);
    console.log('Starting server-side video upload:', {
      menuItemId,
      fileName: file.originalname,
      fileSize: file.size,
      mimeType: file.mimetype,
    });

    // Step 1: Initialize upload
    const { uploadURL, uid } = await this.cloudflareStreamService.initUpload(
      file.originalname,
      file.size,
    );

    console.log('Got upload URL from Cloudflare:', uploadURL, 'Asset ID:', uid);

    // Step 2: Upload video file to Cloudflare from server (no CORS issues)
    // Cloudflare Stream direct upload requires multipart/form-data
    console.log('Uploading video buffer to Cloudflare using multipart/form-data...');
    console.log('Buffer size:', file.buffer.length, 'Expected size:', file.size);
    
    try {
      // Create FormData with the video file
      // IMPORTANT: Use Buffer directly, form-data will handle it correctly
      const formData = new FormData();
      formData.append('file', file.buffer, {
        filename: file.originalname,
        contentType: file.mimetype,
        knownLength: file.size, // Help form-data calculate Content-Length correctly
      });

      // Upload to Cloudflare using POST with multipart/form-data
      const uploadResponse = await axios.post(uploadURL, formData, {
        headers: {
          ...formData.getHeaders(), // This sets Content-Type: multipart/form-data with boundary
        },
        maxContentLength: Infinity,
        maxBodyLength: Infinity,
        timeout: 300000, // 5 minutes timeout for large files
        validateStatus: (status) => status < 500, // Don't throw on 4xx errors so we can see the error message
      });

      console.log('Cloudflare upload response status:', uploadResponse.status);
      console.log('Cloudflare upload response data:', uploadResponse.data);

      if (uploadResponse.status !== 200 && uploadResponse.status !== 201 && uploadResponse.status !== 204) {
        const errorMessage = uploadResponse.data?.errors?.[0]?.message 
          || uploadResponse.data?.message 
          || uploadResponse.statusText 
          || 'Unknown error';
        console.error('Cloudflare upload error details:', {
          status: uploadResponse.status,
          statusText: uploadResponse.statusText,
          data: uploadResponse.data,
          headers: uploadResponse.headers,
        });
        throw new Error(`Failed to upload video to Cloudflare: ${uploadResponse.status} - ${errorMessage}`);
      }

      console.log('Video uploaded successfully to Cloudflare');
    } catch (error: any) {
      console.error('Cloudflare upload exception:', {
        message: error.message,
        response: error.response?.data,
        status: error.response?.status,
        statusText: error.response?.statusText,
        stack: error.stack,
      });
      throw error;
    }

    // Step 3: Wait for Cloudflare to process
    console.log('Waiting for Cloudflare to process video...');
    await new Promise(resolve => setTimeout(resolve, 3000));

    // Step 4: Complete upload
    console.log('Completing upload...');
    return this.completeUpload(uid, menuItemId, uid, vendorId);
  }

  /** قائمة كل مقاطع الفيديو للمورد (للعرض الموحد — نفس الحجم والإطار) */
  async getVendorVideos(vendorId: string): Promise<Array<{ id: string; menuItemId: string; playbackUrl: string; thumbnailUrl: string | null; duration: number; menuItemName: string }>> {
    const menuItems = await this.menuItemRepository.find({
      where: { vendorId },
      relations: ['videoAssets'],
    });
    const result: Array<{ id: string; menuItemId: string; playbackUrl: string; thumbnailUrl: string | null; duration: number; menuItemName: string }> = [];
    for (const mi of menuItems) {
      for (const va of mi.videoAssets || []) {
        result.push({
          id: va.id,
          menuItemId: va.menuItemId,
          playbackUrl: va.playbackUrl,
          thumbnailUrl: va.thumbnailUrl ?? null,
          duration: va.duration,
          menuItemName: mi.name,
        });
      }
    }
    return result.sort((a, b) => 0); // ترتيب ثابت؛ الواجهة تعرض بنفس الحجم
  }

  /** حذف مقطع فيديو — فقط إذا كان تابعاً لوجبة يملكها هذا المورد */
  async deleteVideo(videoId: string, vendorId: string): Promise<void> {
    const video = await this.videoAssetRepository.findOne({
      where: { id: videoId },
      relations: ['menuItem'],
    });
    if (!video?.menuItem) {
      throw new NotFoundException('Video not found');
    }
    if ((video.menuItem as MenuItem).vendorId !== vendorId) {
      throw new ForbiddenException('You can only delete videos that belong to your menu items');
    }
    await this.videoAssetRepository.remove(video);
  }
}
