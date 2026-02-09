import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service locator for accessing providers
class ServiceLocator {
  ServiceLocator._();

  /// Get provider value from container
  static T read<T>(Ref ref, ProviderBase<T> provider) {
    return ref.read(provider);
  }

  /// Watch provider value from container
  static T watch<T>(WidgetRef ref, ProviderBase<T> provider) {
    return ref.watch(provider);
  }
}
