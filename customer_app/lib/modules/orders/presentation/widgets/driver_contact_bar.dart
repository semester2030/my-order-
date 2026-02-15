// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/design_system.dart';

class DriverContactBar extends StatelessWidget {
  final String? driverId;
  final String? driverPhone;
  final String? driverName;

  const DriverContactBar({
    super.key,
    this.driverId,
    this.driverPhone,
    this.driverName,
  });

  Future<void> _callDriver(BuildContext context) async {
    if (driverPhone == null || driverPhone!.isEmpty) {
      if (context.mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.driverPhoneNotAvailable)),
        );
      }
      return;
    }
    final phone = driverPhone!.replaceAll(RegExp(r'\s'), '');
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.cannotOpenDialer)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotStartCall)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (driverId == null) {
      return const SizedBox.shrink();
    }
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.textOnPrimary,
            ),
          ),
          Gaps.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.driverAssigned,
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xsV,
                Text(
                  driverName != null && driverName!.isNotEmpty
                      ? driverName!
                      : l.contactYourDriver,
                  style: TextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (driverPhone != null && driverPhone!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      driverPhone!,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Material(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _callDriver(context),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.phone,
                  color: (driverPhone != null && driverPhone!.isNotEmpty)
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
