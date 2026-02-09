// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class MapPin extends StatelessWidget {
  final bool isSelected;

  const MapPin({
    super.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 3 : 2,
        ),
        boxShadow: AppShadows.elevation2,
      ),
      child: Icon(
        Icons.location_on,
        color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
        size: IconSizes.md,
      ),
    );
  }
}
