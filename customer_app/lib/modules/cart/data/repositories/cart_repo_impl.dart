import '../../domain/repositories/cart_repo.dart';
import '../../domain/entities/cart.dart';
import '../datasources/cart_remote_ds.dart';
import '../mappers/cart_mapper.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Cart> getCart() async {
    final dto = await remoteDataSource.getCart();
    return CartMapper.mapCartFromDto(dto);
  }

  @override
  Future<Cart> addToCart(String menuItemId, int quantity) async {
    final dto = await remoteDataSource.addToCart(menuItemId, quantity);
    return CartMapper.mapCartFromDto(dto);
  }

  @override
  Future<Cart> updateCartItem(String itemId, int quantity) async {
    final dto = await remoteDataSource.updateCartItem(itemId, quantity);
    return CartMapper.mapCartFromDto(dto);
  }

  @override
  Future<Cart> removeCartItem(String itemId) async {
    final dto = await remoteDataSource.removeCartItem(itemId);
    return CartMapper.mapCartFromDto(dto);
  }

  @override
  Future<void> clearCart() async {
    await remoteDataSource.clearCart();
  }
}
