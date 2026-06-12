import '../localization/app_localizations.dart';
import 'app_features.dart';

/// نص حالة «تم عرض السعر» في قوائم وتفاصيل طلبات الخدمة (ذبائح/شواء/منزلي).
String quotedServiceStatusLabel(AppLocalizations l10n) {
  if (AppFeatures.electronicPaymentEnabled) {
    return l10n.homeCookingStatusQuoted;
  }
  return l10n.homeCookingStatusQuotedStcTransfer;
}

/// عنوان زر إعلان التحويل اليدوي.
String manualTransferDeclareTitle(AppLocalizations l10n) {
  if (AppFeatures.electronicPaymentEnabled) {
    return l10n.homeCookingDeclarePayment;
  }
  return l10n.stcBankTransferConfirmButton;
}

/// تلميح حوار إعلان التحويل اليدوي.
String manualTransferDeclareHint(AppLocalizations l10n) {
  if (AppFeatures.electronicPaymentEnabled) {
    return l10n.homeCookingDeclarePaymentHint;
  }
  return l10n.stcBankTransferDeclareHint;
}

/// زر الدخول لتفاصيل الحجز من القائمة.
String chefBookingListActionLabel(AppLocalizations l10n) {
  if (AppFeatures.electronicPaymentEnabled) {
    return l10n.chefBookingDetailsAndPaymentButton;
  }
  return l10n.chefBookingDetailsButton;
}
