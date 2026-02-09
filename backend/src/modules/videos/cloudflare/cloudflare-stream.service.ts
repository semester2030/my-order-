import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';

@Injectable()
export class CloudflareStreamService {
  private readonly accountId: string;
  private readonly apiToken: string;
  private readonly client: AxiosInstance;

  constructor(private configService: ConfigService) {
    this.accountId = this.configService.get<string>('CLOUDFLARE_ACCOUNT_ID');
    this.apiToken = this.configService.get<string>('CLOUDFLARE_API_TOKEN');

    // Validate configuration
    if (!this.accountId) {
      console.error('CLOUDFLARE_ACCOUNT_ID is not configured');
      throw new Error('CLOUDFLARE_ACCOUNT_ID is required but not found in environment variables');
    }
    if (!this.apiToken) {
      console.error('CLOUDFLARE_API_TOKEN is not configured');
      throw new Error('CLOUDFLARE_API_TOKEN is required but not found in environment variables');
    }

    this.client = axios.create({
      baseURL: `https://api.cloudflare.com/client/v4/accounts/${this.accountId}/stream`,
      headers: {
        Authorization: `Bearer ${this.apiToken}`,
        'Content-Type': 'application/json',
      },
    });
  }

  async initUpload(fileName: string, fileSize: number): Promise<{ uploadURL: string; uid: string }> {
    // Initialize Cloudflare Stream direct upload
    // Returns both upload URL and asset ID (uid)
    try {
      const response = await this.client.post('/direct_upload', {
        maxDurationSeconds: 300, // 5 minutes max
        requireSignedURLs: false, // Set to false for direct uploads
        allowedOrigins: ['*'], // Configure based on your domain
      });

      return {
        uploadURL: response.data.result.uploadURL,
        uid: response.data.result.uid, // This is the asset ID
      };
    } catch (error: any) {
      console.error('Cloudflare Stream initUpload error:', error.response?.data || error.message);
      throw new Error(`Failed to initialize upload: ${error.response?.data?.errors?.[0]?.message || error.message}`);
    }
  }

  async getAssetDetails(assetId: string) {
    // Get asset details from Cloudflare Stream
    // Note: After upload, video may still be processing, so we may need to retry
    try {
      const response = await this.client.get(`/${assetId}`);

      const result = response.data.result;

      // Cloudflare Stream provides different playback URLs based on status
      let playbackUrl = '';
      if (result.playback?.hls) {
        playbackUrl = result.playback.hls;
      } else if (result.playback?.dash) {
        playbackUrl = result.playback.dash;
      } else if (result.playback?.mp4) {
        playbackUrl = result.playback.mp4;
      }

      return {
        playbackUrl: playbackUrl || `https://customer-${this.accountId}.cloudflarestream.com/${assetId}/manifest/video.m3u8`,
        thumbnailUrl: result.thumbnail || result.thumbnailTimestamp || null,
        duration: result.duration || 0,
      };
    } catch (error: any) {
      console.error('Cloudflare Stream getAssetDetails error:', error.response?.data || error.message);
      // If asset is still processing, return default values
      if (error.response?.status === 404 || error.response?.status === 400) {
        // Use the account ID from config
        const accountId = this.accountId || this.configService.get<string>('CLOUDFLARE_ACCOUNT_ID');
        return {
          playbackUrl: `https://customer-${accountId}.cloudflarestream.com/${assetId}/manifest/video.m3u8`,
          thumbnailUrl: null,
          duration: 0,
        };
      }
      throw new Error(`Failed to get asset details: ${error.response?.data?.errors?.[0]?.message || error.message}`);
    }
  }

  async generateSignedURL(assetId: string, expiresIn: number = 3600): Promise<string> {
    // TODO: Implement signed URL generation
    // This should generate a temporary signed URL for video playback
    try {
      const response = await this.client.post(`/${assetId}/token`, {
        exp: Math.floor(Date.now() / 1000) + expiresIn,
      });

      return response.data.result.token;
    } catch (error) {
      throw new Error(`Failed to generate signed URL: ${error.message}`);
    }
  }
}
