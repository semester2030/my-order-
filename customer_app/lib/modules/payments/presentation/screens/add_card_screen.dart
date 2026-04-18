// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/network_exceptions.dart';
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

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _formatCardNumber(String value) {
    // Remove all non-digits (مدى قد تصل 19 رقماً)
    var digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 19) {
      digitsOnly = digitsOnly.substring(0, 19);
    }
    
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

  String _digitsOnly(String raw) => raw.replaceAll(RegExp(r'\D'), '');

  String _deriveLast4() {
    final d = _digitsOnly(_cardNumberController.text);
    if (d.length < 4) return '';
    return d.substring(d.length - 4);
  }

  ({int month, int year})? _parseExpiry() {
    final t = _expiryDateController.text.trim();
    final m = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(t);
    if (m == null) return null;
    final month = int.tryParse(m.group(1)!);
    final yy = int.tryParse(m.group(2)!);
    if (month == null || yy == null || month < 1 || month > 12) return null;
    return (month: month, year: 2000 + yy);
  }

  Future<void> _handleSaveCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final expiry = _parseExpiry();
      if (expiry == null) {
        throw Exception('Invalid expiry');
      }
      final last4 = _deriveLast4();
      if (last4.length != 4) {
        throw Exception('last4');
      }

      await ref.read(paymentsRepositoryProvider).createSavedPaymentMethod(
            holderName: _cardHolderNameController.text.trim(),
            last4: last4,
            expMonth: expiry.month,
            expYear: expiry.year,
          );

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
      final msg = e is NetworkException ? e.message : '${l.addCardFailed}: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
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
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.cardType,
                style: TextStyles.titleMedium,
              ),
              Gaps.smV,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Insets.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: AppColors.primary),
                    Gaps.mdH,
                    Expanded(
                      child: Text(
                        'Mada / مدى',
                        style: TextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
                  if (digitsOnly.length < 16 || digitsOnly.length > 19) {
                    return 'Card number must be 16–19 digits';
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                            LengthLimitingTextInputFormatter(5),
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
                        l.saveCardServerPrivacyNote,
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
