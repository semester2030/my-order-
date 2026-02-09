import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/address.dart';

part 'address_state.freezed.dart';

@freezed
class AddressState with _$AddressState {
  const factory AddressState.initial() = _Initial;
  const factory AddressState.loading() = _Loading;
  const factory AddressState.loaded(List<Address> addresses) = _Loaded;
  const factory AddressState.error(String message) = _Error;
}
