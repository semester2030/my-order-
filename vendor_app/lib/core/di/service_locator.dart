/// Service locator for Vendor App (Phase 1: minimal; extended in later phases).
/// Use Riverpod providers for most dependencies; use this for non-widget roots if needed.
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  final Map<Type, Object> _factories = {};

  void register<T>(T Function() factory) {
    _factories[T] = factory;
  }

  T get<T>() {
    final f = _factories[T];
    if (f == null) throw StateError('No registration for $T');
    return (f as T Function())();
  }

  bool isRegistered<T>() => _factories.containsKey(T);

  void reset() {
    _factories.clear();
  }
}
