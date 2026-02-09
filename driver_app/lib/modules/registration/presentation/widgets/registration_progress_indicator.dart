import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            totalSteps,
            (index) => Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? Insets.xs : 0,
                ),
                decoration: BoxDecoration(
                  color: index < currentStep
                      ? SemanticColors.success
                      : index == currentStep - 1
                          ? AppColors.primary
                          : AppColors.border,
                  borderRadius: AppRadius.smAll,
                ),
              ),
            ),
          ),
        ),
        Gaps.smV,
        Text(
          'Step $currentStep of $totalSteps',
          style: TextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
