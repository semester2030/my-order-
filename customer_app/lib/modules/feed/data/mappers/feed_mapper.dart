import '../../domain/entities/feed_item.dart';
import '../../domain/entities/video_asset.dart';
import '../models/feed_item_dto.dart' as dto;

class FeedMapper {
  static VideoAsset? mapVideoFromDto(dto.VideoDto? videoDto) {
    if (videoDto == null) return null;

    return VideoAsset(
      id: videoDto.id,
      playbackUrl: videoDto.playbackUrl,
      thumbnailUrl: videoDto.thumbnailUrl,
      duration: videoDto.duration,
    );
  }

  static Vendor mapVendorFromDto(dto.VendorDto vendorDto) {
    return Vendor(
      id: vendorDto.id,
      name: vendorDto.name,
      logo: vendorDto.logo,
      rating: vendorDto.rating,
      ratingCount: vendorDto.ratingCount,
      type: vendorDto.type,
      acceptsCustomRequests: vendorDto.acceptsCustomRequests,
      providerCategory: vendorDto.providerCategory,
    );
  }

  static MenuItem mapMenuItemFromDto(dto.FeedItemDto itemDto) {
    return MenuItem(
      id: itemDto.id,
      name: itemDto.name,
      description: itemDto.description,
      price: itemDto.price,
      image: itemDto.image,
      isSignature: itemDto.isSignature,
    );
  }

  static FeedItem mapFeedItemFromDto(dto.FeedItemDto itemDto) {
    return FeedItem(
      id: itemDto.id,
      menuItem: mapMenuItemFromDto(itemDto),
      vendor: mapVendorFromDto(itemDto.vendor),
      video: mapVideoFromDto(itemDto.video),
      distance: itemDto.distance,
    );
  }

  static List<FeedItem> mapFeedItemsFromDto(List<dto.FeedItemDto> dtos) {
    return dtos.map((dto) => mapFeedItemFromDto(dto)).toList();
  }
}
