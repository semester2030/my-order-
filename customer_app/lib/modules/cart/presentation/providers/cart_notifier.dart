import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/cart_repo.dart';
import 'cart_state.dart';

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository repository;

  CartNotifier(this.repository) : super(const CartState.initial()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = const CartState.loading();
    try {
      final cart = await repository.getCart();
      state = CartState.loaded(cart);
    } catch (e) {
      state = CartState.error(e.toString());
    }
  }

  Future<void> addToCart(String menuItemId, int quantity) async {
    state = const CartState.loading();
    try {
      final cart = await repository.addToCart(menuItemId, quantity);
      state = CartState.loaded(cart);
    } catch (e) {
      state = CartState.error(e.toString());
      rethrow; // Re-throw to show error in UI
    }
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    state = const CartState.loading();
    try {
      final cart = await repository.updateCartItem(itemId, quantity);
      state = CartState.loaded(cart);
    } catch (e) {
      state = CartState.error(e.toString());
    }
  }

  Future<void> removeCartItem(String itemId) async {
    state = const CartState.loading();
    try {
      final cart = await repository.removeCartItem(itemId);
      state = CartState.loaded(cart);
    } catch (e) {
      state = CartState.error(e.toString());
    }
  }

  Future<void> clearCart() async {
    state = const CartState.loading();
    try {
      await repository.clearCart();
      // Reload cart to get empty cart
      await loadCart();
    } catch (e) {
      state = CartState.error(e.toString());
    }
  }
}
