import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeedController } from './feed.controller';
import { FeedService } from './feed.service';
import { Vendor } from '../vendors/entities/vendor.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { VideoAsset } from '../menu/entities/video-asset.entity';
import { Address } from '../addresses/entities/address.entity';
import { VendorsModule } from '../vendors/vendors.module';
import { MenuModule } from '../menu/menu.module';
import { AddressesModule } from '../addresses/addresses.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Vendor, MenuItem, VideoAsset, Address]),
    VendorsModule,
    MenuModule,
    AddressesModule,
  ],
  controllers: [FeedController],
  providers: [FeedService],
  exports: [FeedService],
})
export class FeedModule {}
