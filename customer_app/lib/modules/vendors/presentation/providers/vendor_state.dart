import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/entities/menu_item.dart';

part 'vendor_state.freezed.dart';

@freezed
class VendorState with _$VendorState {
  const factory VendorState.initial() = _Initial;
  const factory VendorState.loading() = _Loading;
  const factory VendorState.loaded(
    Vendor vendor,
    List<MenuItem> menuItems,
  ) = _Loaded;
  const factory VendorState.error(String message) = _Error;
}
