// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  const AddCardScreen({super.key});

  @override
  ConsumerState<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends ConsumerState<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isSaving = false;
  String _cardType = 'Mada'; // Default to Mada

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _formatCardNumber(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    // Format as XXXX XXXX XXXX XXXX
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digitsOnly[i]);
    }
    
    final formatted = buffer.toString();
    if (formatted != _cardNumberController.text) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _formatExpiryDate(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    // Format as MM/YY
    String formatted = digitsOnly;
    if (digitsOnly.length >= 2) {
      formatted = '${digitsOnly.substring(0, 2)}/${digitsOnly.length > 2 ? digitsOnly.substring(2, digitsOnly.length > 4 ? 4 : digitsOnly.length) : ''}';
    }
    
    if (formatted != _expiryDateController.text) {
      _expiryDateController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _handleSaveCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // TODO: Implement API call to save card
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.cardAddedSuccess),
          backgroundColor: SemanticColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.addCardFailed}: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l.addPaymentCardTitle,
          style: TextStyles.titleLarge,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Type Selection
              Text(
                'Card Type',
                style: TextStyles.titleMedium,
              ),
              Gaps.smV,
              Container(
                padding: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _CardTypeOption(
                        title: 'Mada',
                        icon: Icons.credit_card,
                        isSelected: _cardType == 'Mada',
                        onTap: () {
                          setState(() {
                            _cardType = 'Mada';
                          });
                        },
                      ),
                    ),
                    Gaps.smH,
                    Expanded(
                      child: _CardTypeOption(
                        title: 'Visa/Mastercard',
                        icon: Icons.payment,
                        isSelected: _cardType == 'Visa/Mastercard',
                        onTap: () {
                          setState(() {
                            _cardType = 'Visa/Mastercard';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.xlV,
              // Card Number
              Text(
                'Card Number',
                style: TextStyles.titleMedium,
              ),
              Gaps.smV,
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                ],
                decoration: InputDecoration(
                  hintText: '1234 5678 9012 3456',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  final digitsOnly = value.replaceAll(' ', '');
                  if (digitsOnly.length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
                onChanged: _formatCardNumber,
              ),
              Gaps.lgV,
              // Card Holder Name
              Text(
                'Card Holder Name',
                style: TextStyles.titleMedium,
              ),
              Gaps.smV,
              TextFormField(
                controller: _cardHolderNameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              Gaps.lgV,
              // Expiry Date and CVV
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expiry Date',
                          style: TextStyles.titleMedium,
                        ),
                        Gaps.smV,
                        TextFormField(
                          controller: _expiryDateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5), // MM/YY
                          ],
                          decoration: InputDecoration(
                            hintText: 'MM/YY',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                              return 'Invalid format';
                            }
                            return null;
                          },
                          onChanged: _formatExpiryDate,
                        ),
                      ],
                    ),
                  ),
                  Gaps.mdH,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CVV',
                          style: TextStyles.titleMedium,
                        ),
                        Gaps.smV,
                        TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            hintText: '123',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Invalid CVV';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.xlV,
              // Save Button
              PrimaryButton(
                onPressed: _isSaving ? null : _handleSaveCard,
                text: _isSaving ? l.saving : l.saveCard,
                width: double.infinity,
              ),
              Gaps.mdV,
              // Security Note
              Container(
                padding: const EdgeInsets.all(Insets.md),
                decoration: BoxDecoration(
                  color: AppColors.infoContainer,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppColors.info,
                      size: IconSizes.md,
                    ),
                    Gaps.smH,
                    Expanded(
                      child: Text(
                        'Your card information is encrypted and secure',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTypeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardTypeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: AppRadius.smAll,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: IconSizes.md,
            ),
            Gaps.smH,
            Text(
              title,
              style: TextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
