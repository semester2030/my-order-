import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final bool readOnly;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.readOnly = false,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;

        return GestureDetector(
          onTap: readOnly
              ? null
              : () => onRatingChanged?.call(starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: size,
              color: isFilled ? AppColors.accent : AppColors.border,
            ),
          ),
        );
      }),
    );
  }
}
