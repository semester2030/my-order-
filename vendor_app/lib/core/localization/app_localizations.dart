import 'package:flutter/material.dart';

import 'strings_ar.dart';
import 'strings_en.dart';

/// واجهة الترجمة ودعم Locale (ar / en) — Phase 16.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(l != null, 'AppLocalizations not found. Add AppLocalizations.delegate to localizationsDelegates.');
    return l!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  bool get isAr => locale.languageCode == 'ar';
  bool get isEn => locale.languageCode == 'en';

  String get appTitle => isAr ? StringsAr.appTitle : StringsEn.appTitle;
  String get splashTagline => isAr ? StringsAr.splashTagline : StringsEn.splashTagline;
  String get dashboard => isAr ? StringsAr.dashboard : StringsEn.dashboard;
  String get orders => isAr ? StringsAr.orders : StringsEn.orders;
  String get menu => isAr ? StringsAr.menu : StringsEn.menu;
  String get services => isAr ? StringsAr.services : StringsEn.services;
  String get staff => isAr ? StringsAr.staff : StringsEn.staff;
  String get settings => isAr ? StringsAr.settings : StringsEn.settings;
  String get sideOrders => isAr ? StringsAr.sideOrders : StringsEn.sideOrders;
  String get analytics => isAr ? StringsAr.analytics : StringsEn.analytics;

  String get login => isAr ? StringsAr.login : StringsEn.login;
  String get register => isAr ? StringsAr.register : StringsEn.register;
  String get loginChecking => isAr ? StringsAr.loginChecking : StringsEn.loginChecking;
  String get haveAccountLogin => isAr ? StringsAr.haveAccountLogin : StringsEn.haveAccountLogin;
  String get backToLogin => isAr ? StringsAr.backToLogin : StringsEn.backToLogin;
  String get welcomeBack => isAr ? StringsAr.welcomeBack : StringsEn.welcomeBack;
  String get enterEmailPassword => isAr ? StringsAr.enterEmailPassword : StringsEn.enterEmailPassword;
  String get emailLabel => isAr ? StringsAr.emailLabel : StringsEn.emailLabel;
  String get passwordLabel => isAr ? StringsAr.passwordLabel : StringsEn.passwordLabel;
  String get createAccount => isAr ? StringsAr.createAccount : StringsEn.createAccount;
  String get registerSubtitleWithLocation =>
      isAr ? StringsAr.registerSubtitleWithLocation : StringsEn.registerSubtitleWithLocation;
  String get registerServiceLocationTitle =>
      isAr ? StringsAr.registerServiceLocationTitle : StringsEn.registerServiceLocationTitle;
  String get registerStreetAddressLabel =>
      isAr ? StringsAr.registerStreetAddressLabel : StringsEn.registerStreetAddressLabel;
  String get registerStreetAddressHint =>
      isAr ? StringsAr.registerStreetAddressHint : StringsEn.registerStreetAddressHint;
  String get registerCityLabel => isAr ? StringsAr.registerCityLabel : StringsEn.registerCityLabel;
  String get registerCityHint => isAr ? StringsAr.registerCityHint : StringsEn.registerCityHint;
  String get registerLatitudeLabel =>
      isAr ? StringsAr.registerLatitudeLabel : StringsEn.registerLatitudeLabel;
  String get registerLongitudeLabel =>
      isAr ? StringsAr.registerLongitudeLabel : StringsEn.registerLongitudeLabel;
  String get registerCoordinatesHint =>
      isAr ? StringsAr.registerCoordinatesHint : StringsEn.registerCoordinatesHint;
  String get registerCoordinatesZero =>
      isAr ? StringsAr.registerCoordinatesZero : StringsEn.registerCoordinatesZero;
  String get registerUseMyLocation =>
      isAr ? StringsAr.registerUseMyLocation : StringsEn.registerUseMyLocation;
  String get registerFetchingLocation =>
      isAr ? StringsAr.registerFetchingLocation : StringsEn.registerFetchingLocation;
  String get registerLocationServiceDisabled =>
      isAr ? StringsAr.registerLocationServiceDisabled : StringsEn.registerLocationServiceDisabled;
  String get registerLocationPermissionDenied =>
      isAr ? StringsAr.registerLocationPermissionDenied : StringsEn.registerLocationPermissionDenied;
  String get registerLocationPermissionForever =>
      isAr ? StringsAr.registerLocationPermissionForever : StringsEn.registerLocationPermissionForever;
  String get registerLocationPositionUnavailable =>
      isAr ? StringsAr.registerLocationPositionUnavailable : StringsEn.registerLocationPositionUnavailable;
  String get registerSuccessTitle =>
      isAr ? StringsAr.registerSuccessTitle : StringsEn.registerSuccessTitle;
  String get registerSuccessBody =>
      isAr ? StringsAr.registerSuccessBody : StringsEn.registerSuccessBody;
  String get registerSuccessGoLogin =>
      isAr ? StringsAr.registerSuccessGoLogin : StringsEn.registerSuccessGoLogin;
  String get errorInvalidCredentials => isAr ? StringsAr.errorInvalidCredentials : StringsEn.errorInvalidCredentials;
  String get errorNetwork => isAr ? StringsAr.errorNetwork : StringsEn.errorNetwork;
  String get errorServer => isAr ? StringsAr.errorServer : StringsEn.errorServer;
  String get errorValidation => isAr ? StringsAr.errorValidation : StringsEn.errorValidation;
  String get errorGeneric => isAr ? StringsAr.errorGeneric : StringsEn.errorGeneric;

  /// رسالة خطأ مصادقة حسب النوع (Phase 17). [key] = credentials|network|validation|server|generic.
  String messageForAuthError(String? key, {String? fallbackMessage}) {
    if (fallbackMessage != null && fallbackMessage.trim().isNotEmpty) {
      return fallbackMessage;
    }
    switch (key) {
      case 'credentials':
        return errorInvalidCredentials;
      case 'network':
        return errorNetwork;
      case 'validation':
        return errorValidation;
      case 'server':
        return errorServer;
      default:
        return errorGeneric;
    }
  }

  String get editProfile => isAr ? StringsAr.editProfile : StringsEn.editProfile;
  String get changePassword => isAr ? StringsAr.changePassword : StringsEn.changePassword;
  String get verifyEmail => isAr ? StringsAr.verifyEmail : StringsEn.verifyEmail;
  String get verifyEmailDescription =>
      isAr ? StringsAr.verifyEmailDescription : StringsEn.verifyEmailDescription;
  String get verifyEmailSendOtp =>
      isAr ? StringsAr.verifyEmailSendOtp : StringsEn.verifyEmailSendOtp;
  String get verifyEmailOtpLabel =>
      isAr ? StringsAr.verifyEmailOtpLabel : StringsEn.verifyEmailOtpLabel;
  String get verifyEmailConfirm =>
      isAr ? StringsAr.verifyEmailConfirm : StringsEn.verifyEmailConfirm;
  String get verifyEmailSuccess =>
      isAr ? StringsAr.verifyEmailSuccess : StringsEn.verifyEmailSuccess;
  String get verifyEmailAlreadyDone =>
      isAr ? StringsAr.verifyEmailAlreadyDone : StringsEn.verifyEmailAlreadyDone;
  String get verifyEmailDevCodeTitle =>
      isAr ? StringsAr.verifyEmailDevCodeTitle : StringsEn.verifyEmailDevCodeTitle;
  String get verifyEmailDevCodeHint =>
      isAr ? StringsAr.verifyEmailDevCodeHint : StringsEn.verifyEmailDevCodeHint;
  String get logout => isAr ? StringsAr.logout : StringsEn.logout;
  String get language => isAr ? StringsAr.language : StringsEn.language;
  String get languageAr => StringsAr.languageAr;
  String get languageEn => StringsEn.languageEn;

  String get privacyPolicy => isAr ? StringsAr.privacyPolicy : StringsEn.privacyPolicy;
  String get readPrivacy => isAr ? StringsAr.readPrivacy : StringsEn.readPrivacy;
  String get termsConditions => isAr ? StringsAr.termsConditions : StringsEn.termsConditions;
  String get readTerms => isAr ? StringsAr.readTerms : StringsEn.readTerms;
  String get deleteAccount => isAr ? StringsAr.deleteAccount : StringsEn.deleteAccount;
  String get deleteAccountSubtitle =>
      isAr ? StringsAr.deleteAccountSubtitle : StringsEn.deleteAccountSubtitle;
  String get deleteAccountTitle =>
      isAr ? StringsAr.deleteAccountTitle : StringsEn.deleteAccountTitle;
  String get deleteAccountWarning =>
      isAr ? StringsAr.deleteAccountWarning : StringsEn.deleteAccountWarning;
  String get deleteAccountPasswordLabel =>
      isAr ? StringsAr.deleteAccountPasswordLabel : StringsEn.deleteAccountPasswordLabel;
  String get deleteAccountSubmit =>
      isAr ? StringsAr.deleteAccountSubmit : StringsEn.deleteAccountSubmit;
  String get deleteAccountSuccess =>
      isAr ? StringsAr.deleteAccountSuccess : StringsEn.deleteAccountSuccess;
  String get passwordMinHint => isAr ? StringsAr.passwordMinHint : StringsEn.passwordMinHint;
  String get couldNotOpenLink => isAr ? StringsAr.couldNotOpenLink : StringsEn.couldNotOpenLink;
  String get loading => isAr ? StringsAr.loading : StringsEn.loading;

  String get ordersSummary => isAr ? StringsAr.ordersSummary : StringsEn.ordersSummary;
  String get menuItemsCount => isAr ? StringsAr.menuItemsCount : StringsEn.menuItemsCount;
  String get analyticsSummary => isAr ? StringsAr.analyticsSummary : StringsEn.analyticsSummary;
  String get pendingOrders => isAr ? StringsAr.pendingOrders : StringsEn.pendingOrders;
  String get completedOrders => isAr ? StringsAr.completedOrders : StringsEn.completedOrders;
  String get totalRevenue => isAr ? StringsAr.totalRevenue : StringsEn.totalRevenue;

  String get addMeal => isAr ? StringsAr.addMeal : StringsEn.addMeal;
  String get editMeal => isAr ? StringsAr.editMeal : StringsEn.editMeal;
  String get mealName => isAr ? StringsAr.mealName : StringsEn.mealName;
  String get description => isAr ? StringsAr.description : StringsEn.description;
  String get priceSar => isAr ? StringsAr.priceSar : StringsEn.priceSar;
  String get priceSarOptional => isAr ? StringsAr.priceSarOptional : StringsEn.priceSarOptional;
  String get priceRequired => isAr ? StringsAr.priceRequired : StringsEn.priceRequired;
  String get enterValidPrice => isAr ? StringsAr.enterValidPrice : StringsEn.enterValidPrice;
  String get addImage => isAr ? StringsAr.addImage : StringsEn.addImage;
  String get imageSelected => isAr ? StringsAr.imageSelected : StringsEn.imageSelected;
  String get save => isAr ? StringsAr.save : StringsEn.save;
  String get saving => isAr ? StringsAr.saving : StringsEn.saving;
  String get cancel => isAr ? StringsAr.cancel : StringsEn.cancel;
  String get noMeals => isAr ? StringsAr.noMeals : StringsEn.noMeals;
  String get mealNotFound => isAr ? StringsAr.mealNotFound : StringsEn.mealNotFound;
  String get available => isAr ? StringsAr.available : StringsEn.available;
  String get unavailable => isAr ? StringsAr.unavailable : StringsEn.unavailable;

  String get addService => isAr ? StringsAr.addService : StringsEn.addService;
  String get editService => isAr ? StringsAr.editService : StringsEn.editService;
  String get serviceName => isAr ? StringsAr.serviceName : StringsEn.serviceName;
  String get myServices => isAr ? StringsAr.myServices : StringsEn.myServices;
  String get noServices => isAr ? StringsAr.noServices : StringsEn.noServices;
  String get serviceNotFound => isAr ? StringsAr.serviceNotFound : StringsEn.serviceNotFound;
  String get active => isAr ? StringsAr.active : StringsEn.active;
  String get inactive => isAr ? StringsAr.inactive : StringsEn.inactive;

  String get addStaff => isAr ? StringsAr.addStaff : StringsEn.addStaff;
  String get editStaff => isAr ? StringsAr.editStaff : StringsEn.editStaff;
  String get staffName => isAr ? StringsAr.staffName : StringsEn.staffName;
  String get roleOptional => isAr ? StringsAr.roleOptional : StringsEn.roleOptional;
  String get emailOptional => isAr ? StringsAr.emailOptional : StringsEn.emailOptional;
  String get phoneOptional => isAr ? StringsAr.phoneOptional : StringsEn.phoneOptional;
  String get noStaff => isAr ? StringsAr.noStaff : StringsEn.noStaff;
  String get staffNotFound => isAr ? StringsAr.staffNotFound : StringsEn.staffNotFound;

  String get sideOrdersTitle => isAr ? StringsAr.sideOrdersTitle : StringsEn.sideOrdersTitle;
  String get noSideOrderAddOns => isAr ? StringsAr.noSideOrderAddOns : StringsEn.noSideOrderAddOns;
  String get addSideOrderItem => isAr ? StringsAr.addSideOrderItem : StringsEn.addSideOrderItem;
  String get editSideOrderItem => isAr ? StringsAr.editSideOrderItem : StringsEn.editSideOrderItem;
  String get itemName => isAr ? StringsAr.itemName : StringsEn.itemName;
  String get enterPrice => isAr ? StringsAr.enterPrice : StringsEn.enterPrice;

  String get chooseImageOrVideo => isAr ? StringsAr.chooseImageOrVideo : StringsEn.chooseImageOrVideo;
  String get imageFromGallery => isAr ? StringsAr.imageFromGallery : StringsEn.imageFromGallery;
  String get imageFromCamera => isAr ? StringsAr.imageFromCamera : StringsEn.imageFromCamera;
  String get videoFromGallery => isAr ? StringsAr.videoFromGallery : StringsEn.videoFromGallery;
  String get recordVideo => isAr ? StringsAr.recordVideo : StringsEn.recordVideo;

  String get orderDetails => isAr ? StringsAr.orderDetails : StringsEn.orderDetails;
  String get orderAccepted => isAr ? StringsAr.orderAccepted : StringsEn.orderAccepted;
  String get orderRejected => isAr ? StringsAr.orderRejected : StringsEn.orderRejected;
  String get noData => isAr ? StringsAr.noData : StringsEn.noData;
  String get noOrders => isAr ? StringsAr.noOrders : StringsEn.noOrders;
  String get uploadingImage => isAr ? StringsAr.uploadingImage : StringsEn.uploadingImage;
  String get uploadingVideo => isAr ? StringsAr.uploadingVideo : StringsEn.uploadingVideo;
  String get retry => isAr ? StringsAr.retry : StringsEn.retry;

  String get videos => isAr ? StringsAr.videos : StringsEn.videos;
  String get videosCountOfMax => isAr ? StringsAr.videosCountOfMax : StringsEn.videosCountOfMax;
  String get videosMaxReached => isAr ? StringsAr.videosMaxReached : StringsEn.videosMaxReached;
  String get videosDeleteConfirm => isAr ? StringsAr.videosDeleteConfirm : StringsEn.videosDeleteConfirm;
  String get videosDeleted => isAr ? StringsAr.videosDeleted : StringsEn.videosDeleted;
  String get videoMealLabel => isAr ? StringsAr.videoMealLabel : StringsEn.videoMealLabel;
  String get delete => isAr ? StringsAr.delete : StringsEn.delete;
  String get copy => isAr ? StringsAr.copy : StringsEn.copy;

  // المناسبات الخاصة
  String get eventOffers => isAr ? StringsAr.eventOffers : StringsEn.eventOffers;
  String get eventRequests => isAr ? StringsAr.eventRequests : StringsEn.eventRequests;
  String get eventOfferBuffet => isAr ? StringsAr.eventOfferBuffet : StringsEn.eventOfferBuffet;
  String get eventOfferDesserts => isAr ? StringsAr.eventOfferDesserts : StringsEn.eventOfferDesserts;
  String get eventOfferDrinks => isAr ? StringsAr.eventOfferDrinks : StringsEn.eventOfferDrinks;
  String get eventOfferStaff => isAr ? StringsAr.eventOfferStaff : StringsEn.eventOfferStaff;
  String get eventTypeWedding => isAr ? StringsAr.eventTypeWedding : StringsEn.eventTypeWedding;
  String get eventTypeGraduation => isAr ? StringsAr.eventTypeGraduation : StringsEn.eventTypeGraduation;
  String get eventTypeHenna => isAr ? StringsAr.eventTypeHenna : StringsEn.eventTypeHenna;
  String get eventTypeEngagement => isAr ? StringsAr.eventTypeEngagement : StringsEn.eventTypeEngagement;
  String get eventTypeOther => isAr ? StringsAr.eventTypeOther : StringsEn.eventTypeOther;
  String get addEventOffer => isAr ? StringsAr.addEventOffer : StringsEn.addEventOffer;
  String get editEventOffer => isAr ? StringsAr.editEventOffer : StringsEn.editEventOffer;
  String get noEventOffers => isAr ? StringsAr.noEventOffers : StringsEn.noEventOffers;
  String get noEventRequests => isAr ? StringsAr.noEventRequests : StringsEn.noEventRequests;
  String get accept => isAr ? StringsAr.accept : StringsEn.accept;
  String get reject => isAr ? StringsAr.reject : StringsEn.reject;
  String get eventStatusPending => isAr ? StringsAr.eventStatusPending : StringsEn.eventStatusPending;
  String get eventType => isAr ? StringsAr.eventType : StringsEn.eventType;
  String get serviceType => isAr ? StringsAr.serviceType : StringsEn.serviceType;
  String get titleOptional => isAr ? StringsAr.titleOptional : StringsEn.titleOptional;
  String get minGuests => isAr ? StringsAr.minGuests : StringsEn.minGuests;
  String get maxGuests => isAr ? StringsAr.maxGuests : StringsEn.maxGuests;
  String get pricePerPersonOptional => isAr ? StringsAr.pricePerPersonOptional : StringsEn.pricePerPersonOptional;
  String get priceTotalOptional => isAr ? StringsAr.priceTotalOptional : StringsEn.priceTotalOptional;
  String guestsCount(int n) => isAr ? StringsAr.guestsCount(n) : StringsEn.guestsCount(n);

  String get menuOfferingTermsTitle =>
      isAr ? StringsAr.menuOfferingTermsTitle : StringsEn.menuOfferingTermsTitle;
  String get menuOfferingTermsSubtitle =>
      isAr ? StringsAr.menuOfferingTermsSubtitle : StringsEn.menuOfferingTermsSubtitle;
  String get menuOfferingTermsNotice =>
      isAr ? StringsAr.menuOfferingTermsNotice : StringsEn.menuOfferingTermsNotice;
  String get menuOfferingTermsBullet1 =>
      isAr ? StringsAr.menuOfferingTermsBullet1 : StringsEn.menuOfferingTermsBullet1;
  String get menuOfferingTermsBullet2 =>
      isAr ? StringsAr.menuOfferingTermsBullet2 : StringsEn.menuOfferingTermsBullet2;
  String get menuOfferingTermsBullet3 =>
      isAr ? StringsAr.menuOfferingTermsBullet3 : StringsEn.menuOfferingTermsBullet3;
  String get menuOfferingTermsBullet4 =>
      isAr ? StringsAr.menuOfferingTermsBullet4 : StringsEn.menuOfferingTermsBullet4;
  String get menuOfferingTermsBullet5 =>
      isAr ? StringsAr.menuOfferingTermsBullet5 : StringsEn.menuOfferingTermsBullet5;
  String get menuOfferingTermsReadCheckbox =>
      isAr ? StringsAr.menuOfferingTermsReadCheckbox : StringsEn.menuOfferingTermsReadCheckbox;
  String get menuOfferingTermsAgreeButton =>
      isAr ? StringsAr.menuOfferingTermsAgreeButton : StringsEn.menuOfferingTermsAgreeButton;
  String get menuOfferingTermsVersionLabel =>
      isAr ? StringsAr.menuOfferingTermsVersionLabel : StringsEn.menuOfferingTermsVersionLabel;
  String get menuOfferingTermsLoading =>
      isAr ? StringsAr.menuOfferingTermsLoading : StringsEn.menuOfferingTermsLoading;
  String get menuOfferingTermsSubmitting =>
      isAr ? StringsAr.menuOfferingTermsSubmitting : StringsEn.menuOfferingTermsSubmitting;

  String get vendorCombinedTermsTitle =>
      isAr ? StringsAr.vendorCombinedTermsTitle : StringsEn.vendorCombinedTermsTitle;
  String get vendorPlatformTermsSectionTitle =>
      isAr ? StringsAr.vendorPlatformTermsSectionTitle : StringsEn.vendorPlatformTermsSectionTitle;
  String get vendorPlatformTermsIntro =>
      isAr ? StringsAr.vendorPlatformTermsIntro : StringsEn.vendorPlatformTermsIntro;
  String get vendorPlatformTermsFeesTitle =>
      isAr ? StringsAr.vendorPlatformTermsFeesTitle : StringsEn.vendorPlatformTermsFeesTitle;
  String get vendorPlatformTermsFeesBody =>
      isAr ? StringsAr.vendorPlatformTermsFeesBody : StringsEn.vendorPlatformTermsFeesBody;
  String get vendorPlatformTermsPayoutTitle =>
      isAr ? StringsAr.vendorPlatformTermsPayoutTitle : StringsEn.vendorPlatformTermsPayoutTitle;
  String get vendorPlatformTermsPayoutBody =>
      isAr ? StringsAr.vendorPlatformTermsPayoutBody : StringsEn.vendorPlatformTermsPayoutBody;
  String get vendorPlatformTermsComplianceTitle =>
      isAr ? StringsAr.vendorPlatformTermsComplianceTitle : StringsEn.vendorPlatformTermsComplianceTitle;
  String get vendorPlatformTermsComplianceBody =>
      isAr ? StringsAr.vendorPlatformTermsComplianceBody : StringsEn.vendorPlatformTermsComplianceBody;
  String get vendorCombinedTermsMenuSectionTitle =>
      isAr ? StringsAr.vendorCombinedTermsMenuSectionTitle : StringsEn.vendorCombinedTermsMenuSectionTitle;
  String get vendorCategoryTermsSectionTitle =>
      isAr ? StringsAr.vendorCategoryTermsSectionTitle : StringsEn.vendorCategoryTermsSectionTitle;
  String get vendorCategoryTermsPlaceholder =>
      isAr ? StringsAr.vendorCategoryTermsPlaceholder : StringsEn.vendorCategoryTermsPlaceholder;
  String get vendorLegalAlreadyAccepted =>
      isAr ? StringsAr.vendorLegalAlreadyAccepted : StringsEn.vendorLegalAlreadyAccepted;
  String get vendorMenuTermsAlreadyAccepted =>
      isAr ? StringsAr.vendorMenuTermsAlreadyAccepted : StringsEn.vendorMenuTermsAlreadyAccepted;
  String get vendorCombinedTermsReadCheckbox =>
      isAr ? StringsAr.vendorCombinedTermsReadCheckbox : StringsEn.vendorCombinedTermsReadCheckbox;
  String get vendorCombinedTermsLegalVersionLabel =>
      isAr ? StringsAr.vendorCombinedTermsLegalVersionLabel : StringsEn.vendorCombinedTermsLegalVersionLabel;

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
