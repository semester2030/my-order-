import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';
import 'package:vendor_app/modules/profile/presentation/widgets/profile_header.dart';
import 'package:vendor_app/modules/profile/presentation/widgets/settings_tile.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';

/// شاشة الإعدادات — ثيم موحد (Phase 6).
/// [showDrawerButton]: عند true تُعرض أيقونة القائمة لفتح Drawer الـ Shell.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.showDrawerButton = false});

  final bool showDrawerButton;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  Future<void> _logout() async {
    await ref.read(sessionNotifierProvider.notifier).setUnauthenticated();
    if (mounted) context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(profileNotifierProvider);

    if (state is ProfileLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is ProfileError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(profileNotifierProvider.notifier).loadProfile(),
        ),
      );
    }

    if (state is ProfileLoaded) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.lgV,
                ProfileHeader(profile: state.profile),
                Gaps.xlV,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.lgAll,
                    boxShadow: const [AppShadows.sm],
                  ),
                  child: Column(
                    children: [
                      SettingsTile(
                        title: l10n.editProfile,
                        icon: Icons.person_outline,
                        onTap: () => context.push(RouteNames.editProfile),
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      SettingsTile(
                        title: l10n.changePassword,
                        icon: Icons.lock_outline,
                        onTap: () => context.push(RouteNames.changePassword),
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      SettingsTile(
                        title: l10n.language,
                        icon: Icons.language,
                        onTap: () => _showLanguageSheet(context, ref),
                      ),
                    ],
                  ),
                ),
                Gaps.xlV,
                SettingsTile(
                  title: l10n.logout,
                  icon: Icons.logout,
                  onTap: _logout,
                ),
                Gaps.xxlV,
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: const Center(child: LoadingView()),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: widget.showDrawerButton
          ? IconButton(
              icon: Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Text(
        AppLocalizations.maybeOf(context)?.settings ?? 'الإعدادات',
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topLG),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.languageAr),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              title: Text(l10n.languageEn),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
