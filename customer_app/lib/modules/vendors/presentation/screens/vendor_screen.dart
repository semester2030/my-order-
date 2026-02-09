// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/entities/menu_item.dart';
import '../providers/vendor_notifier.dart';
import '../widgets/menu_item_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';

class VendorScreen extends ConsumerStatefulWidget {
  final String vendorId;

  const VendorScreen({
    super.key,
    required this.vendorId,
  });

  @override
  ConsumerState<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends ConsumerState<VendorScreen> {
  String _selectedCategory = 'الكل';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorState = ref.watch(vendorNotifierProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: vendorState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (vendor, menuItems) => _buildVendorContent(vendor, menuItems),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(vendorNotifierProvider(widget.vendorId).notifier).refresh();
          },
        ),
      ),
    );
  }

  Widget _buildVendorContent(Vendor vendor, List<MenuItem> menuItems) {
    final filteredItems = _selectedCategory == 'الكل'
        ? menuItems
        : _selectedCategory == 'Signature'
            ? menuItems.where((item) => item.isSignature).toList()
            : menuItems.where((item) => !item.isSignature).toList();

    final categories = ['الكل', 'Signature', 'عادي'];

    return CustomScrollView(
      slivers: [
        // App Bar with vendor header
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _VendorHeaderImage(vendor: vendor),
            title: Text(
              vendor.name,
              style: TextStyles.titleLarge.copyWith(
                color: AppColors.textInverse,
                shadows: [
                  Shadow(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Vendor info
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rating and info
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.accent,
                      size: IconSizes.md,
                    ),
                    Gaps.smH,
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: TextStyles.titleMedium,
                    ),
                    Gaps.smH,
                    Text(
                      '(${vendor.ratingCount} reviews)',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (vendor.isAcceptingOrders)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.sm,
                          vertical: Insets.xs,
                        ),
                        decoration: BoxDecoration(
                          color: SemanticColors.success.withValues(alpha: 0.1),
                          borderRadius: AppRadius.smAll,
                        ),
                        child: Text(
                          'يقبل الطلبات',
                          style: TextStyles.bodySmall.copyWith(
                            color: SemanticColors.success,
                          ),
                        ),
                      ),
                    Gaps.smH,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Insets.sm,
                        vertical: Insets.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: AppRadius.smAll,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.ramen_dining, size: 14, color: AppColors.primary),
                          Gaps.xsH,
                          Text(
                            'طباخ منزلي',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.mdV,
                // Description
                if (vendor.description != null) ...[
                  Text(
                    vendor.description!,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Gaps.mdV,
                ],
                // Address and phone
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: IconSizes.sm,
                      color: AppColors.textSecondary,
                    ),
                    Gaps.xsH,
                    Expanded(
                      child: Text(
                        vendor.address,
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.xsV,
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: IconSizes.sm,
                      color: AppColors.textSecondary,
                    ),
                    Gaps.xsH,
                    Text(
                      vendor.phoneNumber,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Gaps.lgV,
                // Reviews button
                OutlinedButton.icon(
                  onPressed: () {
                    context.push(
                      '${RouteNames.vendorDetails}/${widget.vendorId}/reviews',
                    );
                  },
                  icon: Icon(Icons.reviews, size: IconSizes.sm),
                  label: const Text('المراجعات'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Insets.lg,
                      vertical: Insets.md,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // الوجبات المتاحة — فلتر التصنيف
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوجبات المتاحة',
                  style: TextStyles.titleMedium,
                ),
                Gaps.smV,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: Insets.sm),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                      selectedColor: AppColors.primaryContainer,
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // قائمة الوجبات
        if (filteredItems.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lunch_dining,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  Gaps.mdV,
                  Text(
                    'لا توجد وجبات متاحة حالياً',
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(Insets.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filteredItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Insets.md),
                    child: MenuItemTile(
                      menuItem: item,
                      onTap: () => _handleAddToCart(item),
                    ),
                  );
                },
                childCount: filteredItems.length,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleAddToCart(MenuItem item) async {
    if (!item.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} is not available'),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }

    try {
      await ref.read(cartNotifierProvider.notifier).addToCart(item.id, 1);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          backgroundColor: SemanticColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
        ),
      );
    }
  }
}

class _VendorHeaderImage extends StatelessWidget {
  final Vendor vendor;

  const _VendorHeaderImage({
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (vendor.cover != null)
          CachedNetworkImage(
            imageUrl: vendor.cover!,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              color: AppColors.primaryContainer,
              child: Icon(
                Icons.ramen_dining,
                size: 64,
                color: AppColors.primary,
              ),
            ),
          )
        else
          Container(
            color: AppColors.primaryContainer,
            child: Icon(
              Icons.ramen_dining,
              size: 64,
              color: AppColors.primary,
            ),
          ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.secondary.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
