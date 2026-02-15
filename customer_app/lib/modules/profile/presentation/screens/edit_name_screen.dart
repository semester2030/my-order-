// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/profile_notifier.dart';

class EditNameScreen extends ConsumerStatefulWidget {
  const EditNameScreen({super.key});

  @override
  ConsumerState<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends ConsumerState<EditNameScreen> {
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(profileNotifierProvider);
    profileState.when(
      initial: () {},
      loading: () {},
      loaded: (profile) {
        _nameController.text = profile.name ?? '';
      },
      error: (_) {},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l.editName,
          style: TextStyles.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gaps.xlV,
            Text(
              l.enterYourName,
              style: TextStyles.titleMedium,
            ),
            Gaps.mdV,
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: l.yourNameHint,
                hintStyle: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdAll,
                  borderSide: BorderSide(
                    color: AppColors.border,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.mdAll,
                  borderSide: BorderSide(
                    color: AppColors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.mdAll,
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(Insets.md),
              ),
              style: TextStyles.bodyLarge,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              autofocus: true,
            ),
            Gaps.xlV,
            PrimaryButton(
              onPressed: _isSaving ? null : _handleSave,
              text: l.save,
              width: double.infinity,
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(l.pleaseEnterName),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(profileNotifierProvider.notifier).updateProfile(name: name);
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(l.nameUpdatedSuccess),
          backgroundColor: SemanticColors.success,
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.updateNameFailed}: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
        ),
      );
    }
  }
}
