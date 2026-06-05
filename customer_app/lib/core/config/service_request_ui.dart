import '../localization/app_localizations.dart';
import 'app_features.dart';

/// نص حالة «تم عرض السعر» في قوائم وتفاصيل طلبات الخدمة (ذبائح/شواء/منزلي).
String quotedServiceStatusLabel(AppLocalizations l10n) {
  if (AppFeatures.electronicPaymentEnabled) {
    return l10n.homeCookingStatusQuoted;
  }
  return l10n.homeCookingStatusQuotedPaymentComingSoon;
}

/// زر الدخول لتفاصيل الحجز من القائمة.
String chefBookingListActionLabel(AppLocalizations l10n) {
  if (AppFeatures.electronicPaymentEnabled) {
    return l10n.chefBookingDetailsAndPaymentButton;
  }
  return l10n.chefBookingDetailsButton;
}
