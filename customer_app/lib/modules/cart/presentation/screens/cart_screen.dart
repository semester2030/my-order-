import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/cart_notifier.dart';
import '../widgets/cart_item_row.dart';
import '../widgets/cart_summary.dart';
import '../widgets/checkout_button.dart';
import '../../../../core/di/providers.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartNotifierProvider.notifier).loadCart();
    });
  }


  Future<void> _handleCheckout() async {
    if (!mounted) return;
    
    final cartState = ref.read(cartNotifierProvider);
    await cartState.when(
      initial: () async {},
      loading: () async {},
      loaded: (cart) async {
        if (cart.isEmpty) {
          if (!mounted) return;
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.cartEmpty),
              backgroundColor: AppColors.warning,
            ),
          );
          return;
        }

        // Create order from cart
        try {
          final ordersRepo = ref.read(ordersRepositoryProvider);
          final addressesRepo = ref.read(addressesRepositoryProvider);
          
          // Get default address
          final defaultAddress = await addressesRepo.getDefaultAddress();
          if (defaultAddress == null) {
            if (!mounted) return;
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.selectAddressFirst),
                backgroundColor: SemanticColors.error,
                action: SnackBarAction(
                  label: l10n.selectAddress,
                  onPressed: () {
                    context.push(RouteNames.selectAddressMap);
                  },
                ),
              ),
            );
            return;
          }
          
          final order = await ordersRepo.createOrder(defaultAddress.id);
          
          // Navigate to payment screen
          if (!mounted) return;
          context.push(
            '${RouteNames.payment}/${order.id}',
            extra: {'amount': order.total},
          );
        } catch (e) {
          if (!mounted) return;
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.createOrderFailed}: ${e.toString()}'),
              backgroundColor: SemanticColors.error,
            ),
          );
        }
      },
      error: (_) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cartState = ref.watch(cartNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.cart,
          style: TextStyles.headlineMedium,
        ),
        actions: [
          cartState.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            loaded: (cart) {
              if (cart.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.clearCartTitle),
                        content: Text(l10n.clearCartConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                            child: Text(l10n.clearCart),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && mounted) {
                      await ref.read(cartNotifierProvider.notifier).clearCart();
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
            error: (_) => const SizedBox.shrink(),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
      body: cartState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (cart) {
          if (cart.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: l10n.cartEmptyTitle,
              message: l10n.cartEmptyMessage,
              actionText: l10n.browseFeed,
              onAction: () => context.go(RouteNames.categories),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Insets.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Cart items
                      ...cart.items.map(
                        (item) => CartItemRow(
                          item: item,
                          onQuantityChanged: (quantity) async {
                            await ref
                                .read(cartNotifierProvider.notifier)
                                .updateCartItem(item.id, quantity);
                          },
                          onRemove: () async {
                            await ref
                                .read(cartNotifierProvider.notifier)
                                .removeCartItem(item.id);
                          },
                        ),
                      ),
                      Gaps.lgV,
                      // Cart summary
                      CartSummary(cart: cart),
                    ],
                  ),
                ),
              ),
              // Checkout button
              CheckoutButton(
                total: cart.total,
                onPressed: _handleCheckout,
              ),
            ],
          );
        },
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(cartNotifierProvider.notifier).loadCart();
          },
        ),
      ),
    );
  }
}
