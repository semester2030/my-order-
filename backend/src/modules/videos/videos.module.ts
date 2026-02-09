import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VideosController } from './videos.controller';
import { VideosService } from './videos.service';
import { CloudflareStreamModule } from './cloudflare/cloudflare-stream.module';
import { VideoAsset } from '../menu/entities/video-asset.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { VendorsModule } from '../vendors/vendors.module';

@Module({
  imports: [
    ConfigModule,
    CloudflareStreamModule,
    TypeOrmModule.forFeature([VideoAsset, MenuItem]),
    VendorsModule,
  ],
  controllers: [VideosController],
  providers: [VideosService],
  exports: [VideosService, TypeOrmModule],
})
export class VideosModule {}
