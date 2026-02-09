import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { CloudflareStreamService } from './cloudflare-stream.service';

@Module({
  imports: [ConfigModule],
  providers: [CloudflareStreamService],
  exports: [CloudflareStreamService],
})
export class CloudflareStreamModule {}
