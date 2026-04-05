import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/utils/result.dart';

/// نتيجة التحقق قبل فتح شاشة الشروط الموحّدة أو إضافة وجبة.
class VendorTermsPrecheckResult {
  const VendorTermsPrecheckResult({
    required this.allComplete,
    this.errorMessage,
  });

  final bool allComplete;
  final String? errorMessage;
}

/// يتطلّب إكمال [legalAccepted] وشروط عرض الوجبات ([MenuOfferingTermsStatus.isCurrent]).
Future<VendorTermsPrecheckResult> precheckVendorCombinedTerms(WidgetRef ref) async {
  final menuRes = await ref.read(menuRepoProvider).getMenuOfferingTermsStatus();
  switch (menuRes) {
    case Failure(:final error):
      return VendorTermsPrecheckResult(
        allComplete: false,
        errorMessage: error.message,
      );
    case Success(:final value):
      final ms = value;
      final authRes = await ref.read(authRepoProvider).getVendorOnboardingStatus();
      switch (authRes) {
        case Failure(:final error):
          return VendorTermsPrecheckResult(
            allComplete: false,
            errorMessage: error.message,
          );
        case Success(:final value):
          final a = value;
          final ok = ms.isCurrent && a.legalAccepted;
          return VendorTermsPrecheckResult(allComplete: ok, errorMessage: null);
      }
  }
}
