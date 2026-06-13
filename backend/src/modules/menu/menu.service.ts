import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MenuItem } from './entities/menu-item.entity';
import { VideoAsset } from './entities/video-asset.entity';
import { toPublicMenuItems } from './menu-item.presenter';

@Injectable()
export class MenuService {
  constructor(
    @InjectRepository(MenuItem)
    private readonly menuItemRepository: Repository<MenuItem>,
    @InjectRepository(VideoAsset)
    private readonly videoAssetRepository: Repository<VideoAsset>,
  ) {}

  async getVendorMenu(vendorId: string) {
    const items = await this.menuItemRepository.find({
      where: { vendorId, isAvailable: true },
    });
    return toPublicMenuItems(items);
  }

  async getSignatureItems(vendorId: string) {
    const items = await this.menuItemRepository.find({
      where: { vendorId, isSignature: true, isAvailable: true },
    });
    return toPublicMenuItems(items);
  }
}
