import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Vendor } from '../vendors/entities/vendor.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { VideoAsset } from '../menu/entities/video-asset.entity';
import { Address } from '../addresses/entities/address.entity';
import { User } from '../users/entities/user.entity';
import { GetFeedDto } from './dto/get-feed.dto';
import { VendorType } from '../vendors/entities/vendor.entity';
import { VideoStatus } from '../menu/entities/video-asset.entity';

interface FeedItem {
  menuItem: MenuItem;
  vendor: Vendor;
  primaryVideo: VideoAsset | null;
  distance: number; // in kilometers
}

@Injectable()
export class FeedService {
  private readonly MAX_DELIVERY_DISTANCE = 15; // 15 km
  private readonly EARTH_RADIUS_KM = 6371;

  constructor(
    @InjectRepository(Vendor)
    private readonly vendorRepository: Repository<Vendor>,
    @InjectRepository(MenuItem)
    private readonly menuItemRepository: Repository<MenuItem>,
    @InjectRepository(VideoAsset)
    private readonly videoAssetRepository: Repository<VideoAsset>,
    @InjectRepository(Address)
    private readonly addressRepository: Repository<Address>,
  ) {}

  /**
   * Calculate distance between two coordinates using Haversine formula
   */
  private calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number,
  ): number {
    const dLat = this.toRadians(lat2 - lat1);
    const dLon = this.toRadians(lon2 - lon1);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRadians(lat1)) *
        Math.cos(this.toRadians(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return this.EARTH_RADIUS_KM * c;
  }

  private toRadians(degrees: number): number {
    return degrees * (Math.PI / 180);
  }

  /**
   * Check if vendor delivers to user location
   */
  private isWithinDeliveryZone(
    vendorLat: number,
    vendorLon: number,
    userLat: number,
    userLon: number,
    deliveryZones?: string[],
  ): boolean {
    // Simple distance-based check (can be enhanced with zone IDs later)
    const distance = this.calculateDistance(vendorLat, vendorLon, userLat, userLon);
    return distance <= this.MAX_DELIVERY_DISTANCE;
  }

  /**
   * Get user's default address or first active address
   */
  private async getUserAddress(userId: string): Promise<Address | null> {
    // Try default address first
    let address = await this.addressRepository.findOne({
      where: { userId, isDefault: true, isActive: true },
    });

    // If no default, get first active address
    if (!address) {
      address = await this.addressRepository.findOne({
        where: { userId, isActive: true },
      });
    }

    return address;
  }

  /**
   * Get feed items with algorithm
   */
  async getFeed(userId: string, query: GetFeedDto) {
    const { page = 1, limit = 10, vendorType, category, sortBy = 'distance', city } = query;
    const skip = (page - 1) * limit;

    console.log('Feed request:', { userId, page, limit, vendorType, category, sortBy, city });

    // Get user address
    const userAddress = await this.getUserAddress(userId);

    if (!userAddress) {
      console.log('No user address found');
      throw new NotFoundException(
        'No delivery address found. Please add an address first.',
      );
    }

    console.log('User address:', userAddress);

    // Build vendor query
    const vendorWhere: any = {
      isActive: true,
      isAcceptingOrders: true,
    };

    if (vendorType && Object.values(VendorType).includes(vendorType as VendorType)) {
      vendorWhere.type = vendorType;
    }
    if (category && category.trim()) {
      vendorWhere.providerCategory = category.trim();
    }
    if (city && city.trim()) {
      vendorWhere.city = city.trim();
    }

    console.log('Vendor where clause:', vendorWhere);

    // Get eligible vendors
    const vendors = await this.vendorRepository.find({
      where: vendorWhere,
      relations: ['menuItems'],
    });

    console.log('Found vendors:', vendors.length, vendors.map(v => ({ id: v.id, name: v.name, isActive: v.isActive, isAcceptingOrders: v.isAcceptingOrders })));

    // Filter vendors by delivery zone
    // TEMPORARILY DISABLED FOR TESTING - Allow all vendors regardless of distance
    // const eligibleVendors = vendors.filter((vendor) =>
    //   this.isWithinDeliveryZone(
    //     vendor.latitude,
    //     vendor.longitude,
    //     userAddress.latitude,
    //     userAddress.longitude,
    //     vendor.deliveryZones,
    //   ),
    // );
    
    // For testing: Allow all vendors (no distance restriction)
    const eligibleVendors = vendors;

    console.log('Eligible vendors after distance filter (DISABLED FOR TESTING):', eligibleVendors.length);

    if (eligibleVendors.length === 0) {
      console.log('No eligible vendors found');
      return {
        items: [],
        pagination: {
          page,
          limit,
          total: 0,
          totalPages: 0,
          hasMore: false,
        },
      };
    }

    const vendorIds = eligibleVendors.map((v) => v.id);
    console.log('Vendor IDs:', vendorIds);

    // Get menu items with videos
    const menuItems = await this.menuItemRepository.find({
      where: {
        vendorId: In(vendorIds),
        isAvailable: true,
      },
      relations: ['videoAssets', 'vendor'],
      order: {
        isSignature: 'DESC', // Signature items first
        orderCount: 'DESC', // Popular items first
        createdAt: 'DESC',
      },
    });

    console.log('Menu items found:', menuItems.length);
    console.log('Menu items with videos:', menuItems.filter(item => item.videoAssets && item.videoAssets.length > 0).length);

    // Get primary videos for menu items
    const menuItemIds = menuItems.map((item) => item.id);
    const primaryVideos = await this.videoAssetRepository.find({
      where: {
        menuItemId: In(menuItemIds),
        isPrimary: true,
        status: VideoStatus.READY,
      },
    });

    console.log('Primary videos found:', primaryVideos.length);

    // Create video map
    const videoMap = new Map<string, VideoAsset>();
    primaryVideos.forEach((video) => {
      videoMap.set(video.menuItemId, video);
    });

    // Create vendor map
    const vendorMap = new Map<string, Vendor>();
    eligibleVendors.forEach((vendor) => {
      vendorMap.set(vendor.id, vendor);
    });

    // Build feed items with distance
    const feedItems: FeedItem[] = menuItems
      .map((menuItem) => {
        const vendor = vendorMap.get(menuItem.vendorId);
        if (!vendor) return null;

        const distance = this.calculateDistance(
          vendor.latitude,
          vendor.longitude,
          userAddress.latitude,
          userAddress.longitude,
        );

        return {
          menuItem,
          vendor,
          primaryVideo: videoMap.get(menuItem.id) || null,
          distance: Math.round(distance * 10) / 10, // Round to 1 decimal
        };
      })
      .filter((item): item is FeedItem => item !== null)
      .sort((a, b) => {
        // Signature items first when applicable
        if (a.menuItem.isSignature !== b.menuItem.isSignature) {
          return a.menuItem.isSignature ? -1 : 1;
        }
        switch (sortBy) {
          case 'rating':
            return Number(b.vendor.rating) - Number(a.vendor.rating);
          case 'newest':
            return (
              new Date(b.menuItem.createdAt).getTime() -
              new Date(a.menuItem.createdAt).getTime()
            );
          case 'distance':
          default:
            return (a.distance || 0) - (b.distance || 0);
        }
      });

    // Paginate
    const total = feedItems.length;
    const paginatedItems = feedItems.slice(skip, skip + limit);
    const totalPages = Math.ceil(total / limit);

    // Format response
    const formattedItems = paginatedItems.map((item) => ({
      id: item.menuItem.id,
      name: item.menuItem.name,
      description: item.menuItem.description,
      price: parseFloat(item.menuItem.price.toString()),
      image: item.menuItem.image,
      isSignature: item.menuItem.isSignature,
      vendor: {
        id: item.vendor.id,
        name: item.vendor.name,
        logo: item.vendor.logo,
        rating: parseFloat(item.vendor.rating.toString()),
        ratingCount: item.vendor.ratingCount,
        type: item.vendor.type,
        acceptsCustomRequests: true,
        providerCategory: item.vendor.providerCategory ?? null,
      },
      video: item.primaryVideo
        ? {
            id: item.primaryVideo.id,
            playbackUrl: item.primaryVideo.playbackUrl,
            thumbnailUrl: item.primaryVideo.thumbnailUrl,
            duration: item.primaryVideo.duration,
          }
        : null,
      distance: item.distance,
    }));

    return {
      items: formattedItems,
      pagination: {
        page,
        limit,
        total,
        totalPages,
        hasMore: page < totalPages,
      },
    };
  }
}
