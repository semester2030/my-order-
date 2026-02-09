import '../../domain/entities/vendor.dart';
import '../../domain/entities/menu_item.dart';
import '../models/vendor_dto.dart';
import '../models/menu_item_dto.dart';

class VendorsMapper {
  static Vendor mapVendorFromDto(VendorDto dto) {
    return Vendor(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      logo: dto.logo,
      cover: dto.cover,
      rating: dto.rating,
      ratingCount: dto.ratingCount,
      type: dto.type,
      address: dto.address,
      phoneNumber: dto.phoneNumber,
      isActive: dto.isActive,
      isAcceptingOrders: dto.isAcceptingOrders,
      providerCategory: dto.providerCategory,
      popularCookingAddOns: dto.popularCookingAddOns
          ?.map((e) => PopularCookingAddOn(name: e.name, price: e.price))
          .toList(),
    );
  }

  static MenuItem mapMenuItemFromDto(MenuItemDto dto) {
    return MenuItem(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      image: dto.image,
      isSignature: dto.isSignature,
      isAvailable: dto.isAvailable,
    );
  }

  static List<MenuItem> mapMenuItemsFromDto(List<MenuItemDto> dtos) {
    return dtos.map((dto) => mapMenuItemFromDto(dto)).toList();
  }
}
