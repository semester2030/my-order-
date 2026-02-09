// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class PinPad extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onBiometricPressed;

  const PinPad({
    super.key,
    required this.onDigitPressed,
    this.onDeletePressed,
    this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        Gaps.mdV,
        _buildRow(['4', '5', '6']),
        Gaps.mdV,
        _buildRow(['7', '8', '9']),
        Gaps.mdV,
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((digit) => _buildDigitButton(digit)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onBiometricPressed != null)
          _buildBiometricButton()
        else
          const SizedBox(width: 80),
        Gaps.mdH,
        _buildDigitButton('0'),
        Gaps.mdH,
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(Insets.sm),
      child: ElevatedButton(
        onPressed: () => onDigitPressed(digit),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.fullAll,
          ),
        ),
        child: Text(
          digit,
          style: TextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(Insets.sm),
      child: ElevatedButton(
        onPressed: onDeletePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.fullAll,
          ),
        ),
        child: Icon(Icons.backspace, size: IconSizes.lg),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(Insets.sm),
      child: ElevatedButton(
        onPressed: onBiometricPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.fullAll,
          ),
        ),
        child: const Icon(Icons.fingerprint, size: IconSizes.lg),
      ),
    );
  }
}
