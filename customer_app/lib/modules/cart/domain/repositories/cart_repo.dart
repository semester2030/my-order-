import '../entities/cart.dart';

abstract class CartRepository {
  Future<Cart> getCart();
  Future<Cart> addToCart(String menuItemId, int quantity);
  Future<Cart> updateCartItem(String itemId, int quantity);
  Future<Cart> removeCartItem(String itemId);
  Future<void> clearCart();
}
