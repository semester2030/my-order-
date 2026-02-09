import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/locale_notifier.dart';
import '../routing/app_router.dart';

import 'storage_providers.dart';

export 'storage_providers.dart';
import '../network/api_client.dart';
import '../../modules/auth/data/datasources/auth_remote_ds.dart';
import '../../modules/auth/data/datasources/auth_remote_ds_impl.dart';
import '../../modules/auth/data/repositories/auth_repo_impl.dart';
import '../../modules/auth/domain/repositories/auth_repo.dart';
import '../../modules/auth/presentation/providers/auth_notifier.dart';
import '../../modules/auth/presentation/providers/auth_state.dart';
import '../../modules/auth/presentation/providers/session_notifier.dart';
import '../../modules/auth/presentation/providers/session_state.dart';
import '../../modules/dashboard/data/datasources/dashboard_remote_ds.dart';
import '../../modules/dashboard/data/datasources/dashboard_remote_ds_impl.dart';
import '../../modules/dashboard/data/repositories/dashboard_repo_impl.dart';
import '../../modules/dashboard/domain/repositories/dashboard_repo.dart';
import '../../modules/dashboard/presentation/providers/dashboard_notifier.dart';
import '../../modules/dashboard/presentation/providers/dashboard_state.dart';
import '../../modules/profile/data/datasources/profile_remote_ds.dart';
import '../../modules/profile/data/datasources/profile_remote_ds_impl.dart';
import '../../modules/profile/data/repositories/profile_repo_impl.dart';
import '../../modules/profile/domain/repositories/profile_repo.dart';
import '../../modules/profile/presentation/providers/profile_notifier.dart';
import '../../modules/profile/presentation/providers/profile_state.dart';
import '../../modules/orders/data/datasources/orders_remote_ds.dart';
import '../../modules/orders/data/datasources/orders_remote_ds_impl.dart';
import '../../modules/orders/data/repositories/orders_repo_impl.dart';
import '../../modules/orders/domain/repositories/orders_repo.dart';
import '../../modules/orders/presentation/providers/order_detail_notifier.dart';
import '../../modules/orders/presentation/providers/order_detail_state.dart';
import '../../modules/orders/presentation/providers/orders_notifier.dart';
import '../../modules/orders/presentation/providers/orders_state.dart';
import '../../modules/menu/data/datasources/menu_remote_ds.dart';
import '../../modules/menu/data/datasources/menu_remote_ds_impl.dart';
import '../../modules/menu/data/repositories/menu_repo_impl.dart';
import '../../modules/menu/domain/entities/menu_item.dart';
import '../../modules/menu/domain/repositories/menu_repo.dart';
import '../../modules/menu/presentation/providers/menu_notifier.dart';
import '../../modules/menu/presentation/providers/menu_state.dart';
import '../../modules/services/data/datasources/services_remote_ds.dart';
import '../../modules/services/data/datasources/services_remote_ds_impl.dart';
import '../../modules/services/data/repositories/services_repo_impl.dart';
import '../../modules/services/domain/entities/service_item.dart';
import '../../modules/services/domain/repositories/services_repo.dart';
import '../../modules/services/presentation/providers/services_notifier.dart';
import '../../modules/services/presentation/providers/services_state.dart';
import '../../modules/analytics/data/datasources/analytics_remote_ds.dart';
import '../../modules/analytics/data/datasources/analytics_remote_ds_impl.dart';
import '../../modules/analytics/data/repositories/analytics_repo_impl.dart';
import '../../modules/analytics/domain/repositories/analytics_repo.dart';
import '../../modules/analytics/presentation/providers/analytics_notifier.dart';
import '../../modules/analytics/presentation/providers/analytics_state.dart';
import '../../modules/side_orders/presentation/providers/side_orders_notifier.dart';
import '../../modules/side_orders/presentation/providers/side_orders_state.dart';
import '../../modules/staff/data/datasources/staff_remote_ds.dart';
import '../../modules/staff/data/datasources/staff_remote_ds_impl.dart';
import '../../modules/staff/data/repositories/staff_repo_impl.dart';
import '../../modules/staff/domain/entities/staff_member.dart';
import '../../modules/staff/domain/repositories/staff_repo.dart';
import '../../modules/staff/presentation/providers/staff_notifier.dart';
import '../../modules/staff/presentation/providers/staff_state.dart';
import '../../modules/videos/data/datasources/videos_remote_ds.dart';
import '../../modules/videos/data/datasources/videos_remote_ds_impl.dart';
import '../../modules/videos/data/repositories/videos_repo_impl.dart';
import '../../modules/videos/domain/repositories/videos_repo.dart';
import '../utils/result.dart';

/// Router provider (Phase 7: redirect guard for protected routes).
final routerProvider = Provider<GoRouter>((ref) {
  return createAppRouter(ref);
});

/// Locale provider (Phase 16: ar / en مع الحفظ في local_storage).
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// Re-export storage providers (defined in storage_providers.dart to avoid cycle with locale).

/// API client (Dio) — Phase 7.
final apiClientProvider = Provider<Dio>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return createApiClient(secureStorage);
});

/// Auth remote datasource (Phase 7: real API).
final authRemoteDsProvider = Provider<AuthRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRemoteDsImpl(dio);
});

/// Auth repository (Phase 7: saves tokens).
final authRepoProvider = Provider<AuthRepo>((ref) {
  final ds = ref.watch(authRemoteDsProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepoImpl(ds, secureStorage);
});

/// Auth notifier (login / register state).
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepoProvider);
  return AuthNotifier(repo);
});

/// Session notifier (Phase 7: token + profile + registrationStatus).
final sessionNotifierProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  final profileRepo = ref.watch(profileRepoProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return SessionNotifier(authNotifier, profileRepo, secureStorage);
});

/// Profile remote datasource (Phase 7: real API).
final profileRemoteDsProvider = Provider<ProfileRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ProfileRemoteDsImpl(dio);
});

/// Profile repository.
final profileRepoProvider = Provider<ProfileRepo>((ref) {
  final ds = ref.watch(profileRemoteDsProvider);
  return ProfileRepoImpl(ds);
});

/// Profile notifier (Phase 6: load, update, changePassword).
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repo = ref.watch(profileRepoProvider);
  return ProfileNotifier(repo);
});

/// Dashboard remote datasource (Phase 18: real API).
final dashboardRemoteDsProvider = Provider<DashboardRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return DashboardRemoteDsImpl(dio);
});

/// Dashboard repository.
final dashboardRepoProvider = Provider<DashboardRepo>((ref) {
  final ds = ref.watch(dashboardRemoteDsProvider);
  return DashboardRepoImpl(ds);
});

/// Dashboard notifier.
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return DashboardNotifier(repo);
});

/// Shell tab index (0 = Dashboard, 1 = Orders, 2 = Menu, 3 = Services, 4 = Staff, 5 = Settings). Phase 13.
final selectedShellTabIndexProvider = StateProvider<int>((ref) => 0);

/// Orders remote datasource (Phase 18: real API).
final ordersRemoteDsProvider = Provider<OrdersRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return OrdersRemoteDsImpl(dio);
});

/// Orders repository.
final ordersRepoProvider = Provider<OrdersRepo>((ref) {
  final ds = ref.watch(ordersRemoteDsProvider);
  return OrdersRepoImpl(ds);
});

/// Orders list notifier (Phase 9).
final ordersNotifierProvider =
    StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final repo = ref.watch(ordersRepoProvider);
  return OrdersNotifier(repo);
});

/// Order detail notifier (Phase 9).
final orderDetailNotifierProvider =
    StateNotifierProvider<OrderDetailNotifier, OrderDetailState>((ref) {
  final repo = ref.watch(ordersRepoProvider);
  return OrderDetailNotifier(repo);
});

/// Menu remote datasource (Phase 18: real API).
final menuRemoteDsProvider = Provider<MenuRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return MenuRemoteDsImpl(dio);
});

/// Menu repository.
final menuRepoProvider = Provider<MenuRepo>((ref) {
  final ds = ref.watch(menuRemoteDsProvider);
  return MenuRepoImpl(ds);
});

/// Menu list notifier (Phase 10).
final menuNotifierProvider =
    StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  final repo = ref.watch(menuRepoProvider);
  return MenuNotifier(repo);
});

/// Single menu item by id (Phase 10: for edit screen).
/// الباك اند لا يوفر GET /menu/:id — نأخذ الوجبة من القائمة المحمّلة أولاً.
final menuItemByIdProvider = FutureProvider.family<MenuItem?, String>((ref, id) async {
  final menuState = ref.read(menuNotifierProvider);
  if (menuState is MenuLoaded) {
    for (final e in menuState.result.data) {
      if (e.id == id) return e;
    }
  }
  final repo = ref.watch(menuRepoProvider);
  final result = await repo.getItemById(id);
  return result.valueOrNull;
});

/// Services remote datasource (Phase 18: real API).
final servicesRemoteDsProvider = Provider<ServicesRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ServicesRemoteDsImpl(dio);
});

/// Services repository.
final servicesRepoProvider = Provider<ServicesRepo>((ref) {
  final ds = ref.watch(servicesRemoteDsProvider);
  return ServicesRepoImpl(ds);
});

/// Services list notifier (Phase 11).
final servicesNotifierProvider =
    StateNotifierProvider<ServicesNotifier, ServicesState>((ref) {
  final repo = ref.watch(servicesRepoProvider);
  return ServicesNotifier(repo);
});

/// Single service item by id (Phase 11: for edit screen).
final serviceItemByIdProvider = FutureProvider.family<ServiceItem?, String>((ref, id) async {
  final repo = ref.watch(servicesRepoProvider);
  final result = await repo.getItemById(id);
  return result.valueOrNull;
});

/// Analytics remote datasource (Phase 18: real API).
final analyticsRemoteDsProvider = Provider<AnalyticsRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AnalyticsRemoteDsImpl(dio);
});

/// Analytics repository.
final analyticsRepoProvider = Provider<AnalyticsRepo>((ref) {
  final ds = ref.watch(analyticsRemoteDsProvider);
  return AnalyticsRepoImpl(ds);
});

/// Analytics notifier (Phase 14).
final analyticsNotifierProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final repo = ref.watch(analyticsRepoProvider);
  return AnalyticsNotifier(repo);
});

/// Side orders notifier (Phase 12: بيانات من profile popularCookingAddOns).
final sideOrdersNotifierProvider =
    StateNotifierProvider<SideOrdersNotifier, SideOrdersState>((ref) {
  final profileRepo = ref.watch(profileRepoProvider);
  return SideOrdersNotifier(profileRepo);
});

/// Staff remote datasource (Phase 18: real API).
final staffRemoteDsProvider = Provider<StaffRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return StaffRemoteDsImpl(dio);
});

/// Staff repository.
final staffRepoProvider = Provider<StaffRepo>((ref) {
  final ds = ref.watch(staffRemoteDsProvider);
  return StaffRepoImpl(ds);
});

/// Staff list notifier (Phase 13).
final staffNotifierProvider =
    StateNotifierProvider<StaffNotifier, StaffState>((ref) {
  final repo = ref.watch(staffRepoProvider);
  return StaffNotifier(repo);
});

/// Single staff member by id (Phase 13: for edit screen).
final staffMemberByIdProvider = FutureProvider.family<StaffMember?, String>((ref, id) async {
  final repo = ref.watch(staffRepoProvider);
  final result = await repo.getItemById(id);
  return result.valueOrNull;
});

/// Videos remote datasource (Phase 18: real API).
final videosRemoteDsProvider = Provider<VideosRemoteDs>((ref) {
  final dio = ref.watch(apiClientProvider);
  return VideosRemoteDsImpl(dio);
});

/// Videos repo (Phase 18: real API for upload init/complete).
final videosRepoProvider = Provider<VideosRepo>((ref) {
  final ds = ref.watch(videosRemoteDsProvider);
  return VideosRepoImpl(ds);
});
