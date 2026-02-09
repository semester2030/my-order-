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
  String get logout => isAr ? StringsAr.logout : StringsEn.logout;
  String get language => isAr ? StringsAr.language : StringsEn.language;
  String get languageAr => StringsAr.languageAr;
  String get languageEn => StringsEn.languageEn;

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
