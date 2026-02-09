import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/side_order_item.dart';
import '../../../profile/domain/entities/vendor_profile.dart';
import '../../../profile/domain/repositories/profile_repo.dart';
import 'side_orders_state.dart';

/// Notifier للطلبات الجانبية — Phase 12 (البيانات من profile popularCookingAddOns).
class SideOrdersNotifier extends StateNotifier<SideOrdersState> {
  SideOrdersNotifier(this._profileRepo) : super(const SideOrdersInitial());

  final ProfileRepo _profileRepo;

  static List<SideOrderItem> _parseAddOns(String? jsonStr) {
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>?;
      if (list == null) return [];
      final items = <SideOrderItem>[];
      for (var i = 0; i < list.length; i++) {
        final m = list[i] as Map<String, dynamic>?;
        if (m == null) continue;
        final name = m['name'] as String? ?? '';
        final price = (m['price'] as num?)?.toDouble() ?? 0.0;
        items.add(SideOrderItem(id: 'addon-$i', name: name, price: price));
      }
      return items;
    } catch (_) {
      return [];
    }
  }

  static String _toJson(List<SideOrderItem> items) {
    final list = items
        .map((e) => <String, dynamic>{'name': e.name, 'price': e.price})
        .toList();
    return jsonEncode(list);
  }

  Future<void> load() async {
    state = const SideOrdersLoading();
    final result = await _profileRepo.getProfile();
    result.when(
      success: (VendorProfile profile) {
        final items = _parseAddOns(profile.popularCookingAddOns);
        state = SideOrdersLoaded(List<SideOrderItem>.from(items));
      },
      failure: (f) => state = SideOrdersError(f.message),
    );
  }

  Future<bool> save(List<SideOrderItem> items) async {
    state = const SideOrdersSaving();
    final current = await _profileRepo.getProfile();
    final profile = current.valueOrNull;
    if (profile == null) {
      state = SideOrdersError('تعذر تحميل البروفايل');
      return false;
    }
    final updated = VendorProfile(
      id: profile.id,
      name: profile.name,
      tradeName: profile.tradeName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      description: profile.description,
      address: profile.address,
      city: profile.city,
      providerCategory: profile.providerCategory,
      popularCookingAddOns: _toJson(items),
      isActive: profile.isActive,
      isAcceptingOrders: profile.isAcceptingOrders,
      registrationStatus: profile.registrationStatus,
    );
    final result = await _profileRepo.updateProfile(updated);
    return result.when(
      success: (_) {
        state = SideOrdersLoaded(List<SideOrderItem>.from(items));
        return true;
      },
      failure: (f) {
        state = SideOrdersError(f.message);
        return false;
      },
    );
  }

  Future<bool> addItem(SideOrderItem item) async {
    final current = state;
    if (current is! SideOrdersLoaded) return false;
    final items = List<SideOrderItem>.from(current.items)
      ..add(SideOrderItem(
        id: 'addon-${DateTime.now().millisecondsSinceEpoch}',
        name: item.name,
        price: item.price,
      ));
    return save(items);
  }

  Future<bool> updateItem(SideOrderItem item) async {
    final current = state;
    if (current is! SideOrdersLoaded) return false;
    final items = current.items.map((e) {
      if (e.id == item.id) return item;
      return e;
    }).toList();
    return save(items);
  }

  Future<bool> removeItem(String id) async {
    final current = state;
    if (current is! SideOrdersLoaded) return false;
    final items = current.items.where((e) => e.id != id).toList();
    return save(items);
  }
}
