// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';

/// بلاغ جودة خاص بالإدارة — نفس مسار الخلفية لكل أنواع الخدمات.
class ServiceQualityTicketScreen extends ConsumerStatefulWidget {
  const ServiceQualityTicketScreen({
    super.key,
    required this.subjectType,
    required this.subjectId,
  });

  final String subjectType;
  final String subjectId;

  @override
  ConsumerState<ServiceQualityTicketScreen> createState() =>
      _ServiceQualityTicketScreenState();
}

class _ServiceQualityTicketScreenState extends ConsumerState<ServiceQualityTicketScreen> {
  static const _codes = ['quality', 'hygiene', 'delay', 'billing', 'other'];
  String _category = 'quality';
  final _messageCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  String _labelFor(AppLocalizations l, String code) {
    switch (code) {
      case 'hygiene':
        return l.qualityCategoryHygiene;
      case 'delay':
        return l.qualityCategoryDelay;
      case 'billing':
        return l.qualityCategoryBilling;
      case 'other':
        return l.qualityCategoryOther;
      case 'quality':
      default:
        return l.qualityCategoryQuality;
    }
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final msg = _messageCtrl.text.trim();
    if (msg.length < 5) return;
    setState(() => _busy = true);
    try {
      await ref.read(serviceExperienceRepositoryProvider).submitQualityTicket(
            subjectType: widget.subjectType,
            subjectId: widget.subjectId,
            category: _category,
            privateMessage: msg,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.serviceQualitySentSnack)),
      );
      context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (widget.subjectId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.serviceQualityReportTitle, style: TextStyles.titleLarge)),
        body: Center(child: Text(l.isAr ? 'معرّف غير صالح' : 'Invalid link')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.serviceQualityReportTitle, style: TextStyles.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Insets.lg),
        children: [
          Text(
            l.serviceQualityCategoryLabel,
            style: TextStyles.titleSmall,
          ),
          Gaps.smV,
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.mdAll,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.md),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _category,
                  items: _codes
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(_labelFor(l, c)),
                        ),
                      )
                      .toList(),
                  onChanged: _busy
                      ? null
                      : (v) {
                          if (v != null) setState(() => _category = v);
                        },
                ),
              ),
            ),
          ),
          Gaps.lgV,
          Text(l.serviceQualityMessageLabel, style: TextStyles.titleSmall),
          Gaps.smV,
          TextField(
            controller: _messageCtrl,
            maxLines: 6,
            minLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
              hintText: l.isAr ? 'اكتب تفاصيل البلاغ (5 أحرف على الأقل)' : 'Details (at least 5 characters)',
            ),
          ),
          Gaps.xlV,
          PrimaryButton(
            onPressed: _busy ? null : _submit,
            text: l.serviceQualitySubmit,
            width: double.infinity,
            isLoading: _busy,
          ),
        ],
      ),
    );
  }
}
