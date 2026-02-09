import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../../feed/domain/entities/feed_item.dart';
import '../models/cart_dto.dart' as cart_dto;
import '../models/cart_item_dto.dart' as cart_item_dto;

class CartMapper {
  static Vendor? mapVendorFromDto(cart_dto.VendorDto? dto) {
    if (dto == null) return null;

    return Vendor(
      id: dto.id,
      name: dto.name,
      logo: dto.logo,
      rating: 0.0, // Not provided in cart DTO
      ratingCount: 0, // Not provided in cart DTO
      type: '', // Not provided in cart DTO
    );
  }

  static MenuItem mapMenuItemFromDto(cart_item_dto.MenuItemDto dto) {
    return MenuItem(
      id: dto.id,
      name: dto.name,
      image: dto.image,
      price: dto.price,
      isSignature: false, // Not provided in cart DTO
    );
  }

  static CartItem mapCartItemFromDto(cart_item_dto.CartItemDto dto) {
    return CartItem(
      id: dto.id,
      menuItemId: dto.menuItem.id,
      menuItem: mapMenuItemFromDto(dto.menuItem),
      quantity: dto.quantity,
      price: dto.price,
    );
  }

  static List<CartItem> mapCartItemsFromDto(
      List<cart_item_dto.CartItemDto> dtos,) {
    return dtos.map((dto) => mapCartItemFromDto(dto)).toList();
  }

  static Cart mapCartFromDto(cart_dto.CartDto dto) {
    return Cart(
      id: dto.id,
      vendorId: dto.vendor?.id,
      vendor: mapVendorFromDto(dto.vendor),
      items: mapCartItemsFromDto(dto.items),
      subtotal: dto.subtotal,
      deliveryFee: dto.deliveryFee,
      total: dto.total,
    );
  }
}
