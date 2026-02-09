// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../domain/entities/vendor.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorHeader extends StatelessWidget {
  final Vendor vendor;

  const VendorHeader({
    super.key,
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (vendor.cover != null)
            CachedNetworkImage(
              imageUrl: vendor.cover!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                color: AppColors.primaryContainer,
                child: Icon(
                  Icons.ramen_dining,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            Container(
              color: AppColors.primaryContainer,
              child: Icon(
                Icons.ramen_dining,
                size: 64,
                color: AppColors.primary,
              ),
            ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.secondary.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
