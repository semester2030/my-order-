// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../providers/address_notifier.dart';
import '../widgets/address_tile.dart';

class AddressesListScreen extends ConsumerStatefulWidget {
  const AddressesListScreen({super.key});

  @override
  ConsumerState<AddressesListScreen> createState() => _AddressesListScreenState();
}

class _AddressesListScreenState extends ConsumerState<AddressesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressNotifierProvider.notifier).loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final addressState = ref.watch(addressNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l.myAddresses,
          style: TextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.push(RouteNames.selectAddressMap);
            },
            tooltip: l.addNewAddress,
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
      body: addressState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (addresses) {
          if (addresses.isEmpty) {
            return EmptyState(
              icon: Icons.location_on_outlined,
              title: l.noAddressesSaved,
              message: l.addFirstAddress,
              actionText: l.addAddress,
              onAction: () {
                context.push(RouteNames.selectAddressMap);
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(addressNotifierProvider.notifier).refresh();
            },
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(Insets.md),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return AddressTile(
                  address: address,
                  onTap: () {
                    // Navigate to edit address (using map screen)
                    context.push(RouteNames.selectAddressMap);
                  },
                  onEdit: () {
                    // Navigate to edit address
                    context.push(RouteNames.selectAddressMap);
                  },
                  onDelete: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          l.deleteAddress,
                          style: TextStyles.titleMedium,
                        ),
                        content: Text(
                          l.deleteAddressConfirm,
                          style: TextStyles.bodyMedium,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              l.cancel,
                              style: TextStyles.button.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              l.delete,
                              style: TextStyles.button.copyWith(
                                color: SemanticColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && mounted) {
                      try {
                        await ref.read(addressNotifierProvider.notifier).deleteAddress(address.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.addressDeletedSuccess),
                              backgroundColor: SemanticColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${l.deleteAddressFailed}: ${e.toString()}'),
                              backgroundColor: SemanticColors.error,
                            ),
                          );
                        }
                      }
                    }
                  },
                  onSetDefault: address.isDefault
                      ? null
                      : () async {
                          try {
                            await ref.read(addressNotifierProvider.notifier).setDefaultAddress(address.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l.defaultAddressUpdated),
                                  backgroundColor: SemanticColors.success,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${l.setDefaultAddressFailed}: ${e.toString()}'),
                                  backgroundColor: SemanticColors.error,
                                ),
                              );
                            }
                          }
                        },
                );
              },
            ),
          );
        },
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(addressNotifierProvider.notifier).refresh();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RouteNames.selectAddressMap);
        },
        icon: Icon(Icons.add),
        label: Text(l.addAddress),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
    );
  }
}
