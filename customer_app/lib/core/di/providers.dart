import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../storage/local_storage.dart';
import '../../modules/cart/domain/repositories/cart_repo.dart';
import '../../modules/cart/data/repositories/cart_repo_impl.dart';
import '../../modules/cart/data/datasources/cart_remote_ds.dart';
import '../../modules/orders/domain/repositories/orders_repo.dart';
import '../../modules/orders/data/repositories/orders_repo_impl.dart';
import '../../modules/orders/data/datasources/orders_remote_ds.dart';
import '../../modules/payments/domain/repositories/payments_repo.dart';
import '../../modules/payments/data/repositories/payments_repo_impl.dart';
import '../../modules/payments/data/datasources/payments_remote_ds.dart';
import '../../modules/vendors/domain/repositories/vendors_repo.dart';
import '../../modules/vendors/data/repositories/vendors_repo_impl.dart';
import '../../modules/vendors/data/datasources/vendors_remote_ds.dart';
import '../../modules/profile/domain/repositories/profile_repo.dart';
import '../../modules/profile/data/repositories/profile_repo_impl.dart';
import '../../modules/profile/data/datasources/profile_remote_ds.dart';
import '../../modules/search/domain/repositories/search_repo.dart';
import '../../modules/search/data/repositories/search_repo_impl.dart';
import '../../modules/search/data/datasources/search_remote_ds.dart';
import '../../modules/addresses/domain/repositories/addresses_repo.dart';
import '../../modules/addresses/data/repositories/addresses_repo_impl.dart';
import '../../modules/addresses/data/datasources/addresses_remote_ds.dart';

/// Core providers for dependency injection
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

/// Cart repository provider
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = CartRemoteDataSourceImpl(apiClient: apiClient);
  return CartRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Orders repository provider
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = OrdersRemoteDataSourceImpl(apiClient: apiClient);
  return OrdersRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Payments repository provider
final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = PaymentsRemoteDataSourceImpl(apiClient: apiClient);
  return PaymentsRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Vendors repository provider
final vendorsRepositoryProvider = Provider<VendorsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = VendorsRemoteDataSourceImpl(apiClient: apiClient);
  return VendorsRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = ProfileRemoteDataSourceImpl(apiClient: apiClient);
  return ProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Search repository provider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = SearchRemoteDataSourceImpl(apiClient: apiClient);
  return SearchRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Addresses repository provider
final addressesRepositoryProvider = Provider<AddressesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = AddressesRemoteDataSourceImpl(apiClient: apiClient);
  return AddressesRepositoryImpl(remoteDataSource: remoteDataSource);
});
