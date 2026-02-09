import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/design_system.dart';
import '../../data/models/delivery_details_dto.dart';

class CustomerContactBar extends StatelessWidget {
  final CustomerDetails customer;
  final DeliveryAddress address;

  const CustomerContactBar({
    super.key,
    required this.customer,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer & Delivery Address',
              style: TextStyles.titleLarge,
            ),
            Gaps.mdV,
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: IconSizes.md,
                  color: AppColors.textSecondary,
                ),
                Gaps.smH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name ?? 'Customer',
                        style: TextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.xsV,
                      Text(
                        customer.phone,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _callCustomer(context, customer.phone),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.phone, color: AppColors.primary, size: 28),
                    ),
                  ),
                ),
              ],
            ),
            Gaps.mdV,
            Divider(color: AppColors.border),
            Gaps.mdV,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  size: IconSizes.md,
                  color: AppColors.textSecondary,
                ),
                Gaps.smH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.streetAddress,
                        style: TextStyles.bodyMedium,
                      ),
                      Gaps.xsV,
                      Text(
                        '${address.district}, ${address.city}',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callCustomer(BuildContext context, String phone) async {
    if (phone.isEmpty) return;
    final uri = Uri.parse('tel:${phone.replaceAll(RegExp(r'\s'), '')}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open phone dialer')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not start call')),
        );
      }
    }
  }
}
