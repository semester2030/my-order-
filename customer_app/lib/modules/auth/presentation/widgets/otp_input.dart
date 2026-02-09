// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/design_system.dart';

class OtpInput extends StatelessWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;

  const OtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.autoFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => _OtpDigitField(
          index: index,
          length: length,
          onCompleted: onCompleted,
          onChanged: onChanged,
          autoFocus: autoFocus && index == 0,
        ),
      ),
    );
  }
}

class _OtpDigitField extends StatefulWidget {
  final int index;
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;

  const _OtpDigitField({
    required this.index,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.autoFocus = false,
  });

  @override
  State<_OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<_OtpDigitField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _value = '';

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    if (value.length > 1) {
      // Handle paste
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length >= widget.length) {
        widget.onCompleted(digits.substring(0, widget.length));
        return;
      }
    }

    setState(() {
      _value = value.isNotEmpty ? value[value.length - 1] : '';
      _controller.text = _value;
    });

    if (_value.isNotEmpty) {
      widget.onChanged?.call(_value);
      // Move to next field
      if (widget.index < widget.length - 1) {
        FocusScope.of(context).nextFocus();
      } else {
        // Last field, collect all values
        _collectOtp();
      }
    } else {
      // Move to previous field
      if (widget.index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  void _collectOtp() {
    // This will be handled by parent widget through onChanged callback
    // The parent collects all values from individual fields
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: Insets.xs),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: AppRadius.mdAll,
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdAll,
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdAll,
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2.0,
            ),
          ),
        ),
        onChanged: _handleChanged,
        onTap: () {
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        },
      ),
    );
  }
}
