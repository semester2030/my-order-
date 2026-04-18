import 'package:flutter/material.dart';

import 'strings_ar.dart';
import 'strings_en.dart';

/// واجهة الترجمة ودعم Locale (ar / en) — تطبيق العميل.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(
      l != null,
      'AppLocalizations not found. Add AppLocalizations.delegate to localizationsDelegates.',
    );
    return l!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  bool get isAr => locale.languageCode == 'ar';
  bool get isEn => locale.languageCode == 'en';

  // التنقل
  String get discover => isAr ? StringsAr.discover : StringsEn.discover;
  String get cart => isAr ? StringsAr.cart : StringsEn.cart;
  String get orders => isAr ? StringsAr.orders : StringsEn.orders;
  String get payment => isAr ? StringsAr.payment : StringsEn.payment;
  String get profile => isAr ? StringsAr.profile : StringsEn.profile;

  // البروفايل
  String get editName => isAr ? StringsAr.editName : StringsEn.editName;
  String get myAddresses => isAr ? StringsAr.myAddresses : StringsEn.myAddresses;
  String get manageAddresses =>
      isAr ? StringsAr.manageAddresses : StringsEn.manageAddresses;
  String get changeAddress =>
      isAr ? StringsAr.changeAddress : StringsEn.changeAddress;
  String get updateAddress =>
      isAr ? StringsAr.updateAddress : StringsEn.updateAddress;
  String get paymentMethods =>
      isAr ? StringsAr.paymentMethods : StringsEn.paymentMethods;
  String get managePaymentCards =>
      isAr ? StringsAr.managePaymentCards : StringsEn.managePaymentCards;
  String get myOrders => isAr ? StringsAr.myOrders : StringsEn.myOrders;
  String get viewOrderHistory =>
      isAr ? StringsAr.viewOrderHistory : StringsEn.viewOrderHistory;
  String get myChefBookings =>
      isAr ? StringsAr.myChefBookings : StringsEn.myChefBookings;
  String get myChefBookingsSubtitle =>
      isAr ? StringsAr.myChefBookingsSubtitle : StringsEn.myChefBookingsSubtitle;
  String get myHomeCookingRequests =>
      isAr ? StringsAr.myHomeCookingRequests : StringsEn.myHomeCookingRequests;
  String get myHomeCookingRequestsSubtitle =>
      isAr ? StringsAr.myHomeCookingRequestsSubtitle : StringsEn.myHomeCookingRequestsSubtitle;
  String get noHomeCookingRequests =>
      isAr ? StringsAr.noHomeCookingRequests : StringsEn.noHomeCookingRequests;
  String get homeCookingStatusPending =>
      isAr ? StringsAr.homeCookingStatusPending : StringsEn.homeCookingStatusPending;
  String get homeCookingStatusQuoted =>
      isAr ? StringsAr.homeCookingStatusQuoted : StringsEn.homeCookingStatusQuoted;
  String get homeCookingStatusPaymentPending =>
      isAr ? StringsAr.homeCookingStatusPaymentPending : StringsEn.homeCookingStatusPaymentPending;
  String get homeCookingStatusAccepted =>
      isAr ? StringsAr.homeCookingStatusAccepted : StringsEn.homeCookingStatusAccepted;
  String get homeCookingStatusReady =>
      isAr ? StringsAr.homeCookingStatusReady : StringsEn.homeCookingStatusReady;
  String get homeCookingStatusRejected =>
      isAr ? StringsAr.homeCookingStatusRejected : StringsEn.homeCookingStatusRejected;
  String get homeCookingStatusCancelled =>
      isAr ? StringsAr.homeCookingStatusCancelled : StringsEn.homeCookingStatusCancelled;
  String get homeCookingQuotedAmount =>
      isAr ? StringsAr.homeCookingQuotedAmount : StringsEn.homeCookingQuotedAmount;
  String get homeCookingQuoteNotes =>
      isAr ? StringsAr.homeCookingQuoteNotes : StringsEn.homeCookingQuoteNotes;
  String get homeCookingDeliveryYes =>
      isAr ? StringsAr.homeCookingDeliveryYes : StringsEn.homeCookingDeliveryYes;
  String get homeCookingDeliveryNo =>
      isAr ? StringsAr.homeCookingDeliveryNo : StringsEn.homeCookingDeliveryNo;
  String get homeCookingDeclarePayment =>
      isAr ? StringsAr.homeCookingDeclarePayment : StringsEn.homeCookingDeclarePayment;
  String get homeCookingDeclarePaymentHint =>
      isAr ? StringsAr.homeCookingDeclarePaymentHint : StringsEn.homeCookingDeclarePaymentHint;
  String get homeCookingPaymentReferenceLabel =>
      isAr ? StringsAr.homeCookingPaymentReferenceLabel : StringsEn.homeCookingPaymentReferenceLabel;
  String get homeCookingPaymentNotesOptional =>
      isAr ? StringsAr.homeCookingPaymentNotesOptional : StringsEn.homeCookingPaymentNotesOptional;
  String get homeCookingSubmitDeclaration =>
      isAr ? StringsAr.homeCookingSubmitDeclaration : StringsEn.homeCookingSubmitDeclaration;
  String get homeCookingDeclareSuccess =>
      isAr ? StringsAr.homeCookingDeclareSuccess : StringsEn.homeCookingDeclareSuccess;
  String get homeCookingCardPaymentTitle =>
      isAr ? StringsAr.homeCookingCardPaymentTitle : StringsEn.homeCookingCardPaymentTitle;
  String get homeCookingCardPaymentHint =>
      isAr ? StringsAr.homeCookingCardPaymentHint : StringsEn.homeCookingCardPaymentHint;
  String get homeCookingCardPayMada =>
      isAr ? StringsAr.homeCookingCardPayMada : StringsEn.homeCookingCardPayMada;
  String get homeCookingCardPayApple =>
      isAr ? StringsAr.homeCookingCardPayApple : StringsEn.homeCookingCardPayApple;
  String get homeCookingCardPayStc =>
      isAr ? StringsAr.homeCookingCardPayStc : StringsEn.homeCookingCardPayStc;
  String get homeCookingCardCompleteButton =>
      isAr ? StringsAr.homeCookingCardCompleteButton : StringsEn.homeCookingCardCompleteButton;
  String get homeCookingCardSuccess =>
      isAr ? StringsAr.homeCookingCardSuccess : StringsEn.homeCookingCardSuccess;
  String get homeCookingLoadError =>
      isAr ? StringsAr.homeCookingLoadError : StringsEn.homeCookingLoadError;
  String get homeCookingStatusReadyShort =>
      isAr ? StringsAr.homeCookingStatusReadyShort : StringsEn.homeCookingStatusReadyShort;
  String get homeCookingStatusHandedOver =>
      isAr ? StringsAr.homeCookingStatusHandedOver : StringsEn.homeCookingStatusHandedOver;
  String get homeCookingStatusCompleted =>
      isAr ? StringsAr.homeCookingStatusCompleted : StringsEn.homeCookingStatusCompleted;
  String get homeCookingConfirmReceiptTitle =>
      isAr ? StringsAr.homeCookingConfirmReceiptTitle : StringsEn.homeCookingConfirmReceiptTitle;
  String get homeCookingConfirmReceiptMessage =>
      isAr ? StringsAr.homeCookingConfirmReceiptMessage : StringsEn.homeCookingConfirmReceiptMessage;
  String get homeCookingConfirmReceiptButton =>
      isAr ? StringsAr.homeCookingConfirmReceiptButton : StringsEn.homeCookingConfirmReceiptButton;
  String get homeCookingCompletionCertificate =>
      isAr ? StringsAr.homeCookingCompletionCertificate : StringsEn.homeCookingCompletionCertificate;
  String get homeCookingCompletionCertificateHint =>
      isAr ? StringsAr.homeCookingCompletionCertificateHint : StringsEn.homeCookingCompletionCertificateHint;
  String get homeCookingReceiptConfirmedSnackbar =>
      isAr ? StringsAr.homeCookingReceiptConfirmedSnackbar : StringsEn.homeCookingReceiptConfirmedSnackbar;
  String get noChefBookings =>
      isAr ? StringsAr.noChefBookings : StringsEn.noChefBookings;
  String get chefBookingTypePopularCooking =>
      isAr ? StringsAr.chefBookingTypePopularCooking : StringsEn.chefBookingTypePopularCooking;
  String get chefBookingTypeGrilling =>
      isAr ? StringsAr.chefBookingTypeGrilling : StringsEn.chefBookingTypeGrilling;
  String get chefBookingStatusPending =>
      isAr ? StringsAr.chefBookingStatusPending : StringsEn.chefBookingStatusPending;
  String get chefBookingStatusAccepted =>
      isAr ? StringsAr.chefBookingStatusAccepted : StringsEn.chefBookingStatusAccepted;
  String get chefBookingStatusRejected =>
      isAr ? StringsAr.chefBookingStatusRejected : StringsEn.chefBookingStatusRejected;
  String get chefBookingStatusCancelled =>
      isAr ? StringsAr.chefBookingStatusCancelled : StringsEn.chefBookingStatusCancelled;
  String get chefBookingCancelTitle =>
      isAr ? StringsAr.chefBookingCancelTitle : StringsEn.chefBookingCancelTitle;
  String get chefBookingCancelMessage =>
      isAr ? StringsAr.chefBookingCancelMessage : StringsEn.chefBookingCancelMessage;
  String get chefBookingConfirmCancel =>
      isAr ? StringsAr.chefBookingConfirmCancel : StringsEn.chefBookingConfirmCancel;
  String get chefBookingCancelButton =>
      isAr ? StringsAr.chefBookingCancelButton : StringsEn.chefBookingCancelButton;
  String get chefBookingCancelledSnackbar =>
      isAr ? StringsAr.chefBookingCancelledSnackbar : StringsEn.chefBookingCancelledSnackbar;
  String get chefBookingCancelFailed =>
      isAr ? StringsAr.chefBookingCancelFailed : StringsEn.chefBookingCancelFailed;
  String chefBookingRespondByLine(String formatted) =>
      isAr ? StringsAr.chefBookingRespondByLine(formatted) : StringsEn.chefBookingRespondByLine(formatted);
  String get settings => isAr ? StringsAr.settings : StringsEn.settings;
  String get appSettings =>
      isAr ? StringsAr.appSettings : StringsEn.appSettings;
  String get logout => isAr ? StringsAr.logout : StringsEn.logout;
  String get logoutConfirm =>
      isAr ? StringsAr.logoutConfirm : StringsEn.logoutConfirm;
  String get cancel => isAr ? StringsAr.cancel : StringsEn.cancel;
  String get notSet => isAr ? StringsAr.notSet : StringsEn.notSet;

  // السلة
  String get subtotal => isAr ? StringsAr.subtotal : StringsEn.subtotal;
  String get deliveryFee =>
      isAr ? StringsAr.deliveryFee : StringsEn.deliveryFee;
  String get total => isAr ? StringsAr.total : StringsEn.total;
  String get checkout => isAr ? StringsAr.checkout : StringsEn.checkout;
  String get cartEmpty => isAr ? StringsAr.cartEmpty : StringsEn.cartEmpty;
  String get cartEmptyTitle =>
      isAr ? StringsAr.cartEmptyTitle : StringsEn.cartEmptyTitle;
  String get cartEmptyMessage =>
      isAr ? StringsAr.cartEmptyMessage : StringsEn.cartEmptyMessage;
  String get clearCartTitle =>
      isAr ? StringsAr.clearCartTitle : StringsEn.clearCartTitle;
  String get clearCart => isAr ? StringsAr.clearCart : StringsEn.clearCart;
  String get clearCartConfirm =>
      isAr ? StringsAr.clearCartConfirm : StringsEn.clearCartConfirm;
  String get selectAddress =>
      isAr ? StringsAr.selectAddress : StringsEn.selectAddress;
  String get selectAddressFirst =>
      isAr ? StringsAr.selectAddressFirst : StringsEn.selectAddressFirst;
  String get addToCart => isAr ? StringsAr.addToCart : StringsEn.addToCart;
  String get addedToCart =>
      isAr ? StringsAr.addedToCart : StringsEn.addedToCart;
  String get viewCart => isAr ? StringsAr.viewCart : StringsEn.viewCart;
  String get whenDoYouWantOrder =>
      isAr ? StringsAr.whenDoYouWantOrder : StringsEn.whenDoYouWantOrder;
  String get readyNow => isAr ? StringsAr.readyNow : StringsEn.readyNow;
  String get scheduledFor =>
      isAr ? StringsAr.scheduledFor : StringsEn.scheduledFor;
  String get continueToPayment =>
      isAr ? StringsAr.continueToPayment : StringsEn.continueToPayment;

  // الطلبات
  String get noOrdersYet =>
      isAr ? StringsAr.noOrdersYet : StringsEn.noOrdersYet;
  String get ordersWillAppear =>
      isAr ? StringsAr.ordersWillAppear : StringsEn.ordersWillAppear;
  String get browseFeed => isAr ? StringsAr.browseFeed : StringsEn.browseFeed;

  // الدفع
  String get addPaymentCard =>
      isAr ? StringsAr.addPaymentCard : StringsEn.addPaymentCard;
  String get savedPaymentMethods =>
      isAr ? StringsAr.savedPaymentMethods : StringsEn.savedPaymentMethods;
  String get connected => isAr ? StringsAr.connected : StringsEn.connected;
  String get noCardsSaved =>
      isAr ? StringsAr.noCardsSaved : StringsEn.noCardsSaved;
  String get notConnected =>
      isAr ? StringsAr.notConnected : StringsEn.notConnected;

  // الإعدادات
  String get language => isAr ? StringsAr.language : StringsEn.language;
  String get changeLanguage =>
      isAr ? StringsAr.changeLanguage : StringsEn.changeLanguage;
  String get languageAr => StringsAr.languageAr;
  String get languageEn => StringsEn.languageEn;
  String get notifications =>
      isAr ? StringsAr.notifications : StringsEn.notifications;
  String get manageNotifications =>
      isAr ? StringsAr.manageNotifications : StringsEn.manageNotifications;
  String get theme => isAr ? StringsAr.theme : StringsEn.theme;
  String get lightDarkMode =>
      isAr ? StringsAr.lightDarkMode : StringsEn.lightDarkMode;
  String get about => isAr ? StringsAr.about : StringsEn.about;
  String get helpSupport =>
      isAr ? StringsAr.helpSupport : StringsEn.helpSupport;
  String get getHelp => isAr ? StringsAr.getHelp : StringsEn.getHelp;
  String get termsConditions =>
      isAr ? StringsAr.termsConditions : StringsEn.termsConditions;
  String get readTerms => isAr ? StringsAr.readTerms : StringsEn.readTerms;
  String get privacyPolicy =>
      isAr ? StringsAr.privacyPolicy : StringsEn.privacyPolicy;
  String get readPrivacy => isAr ? StringsAr.readPrivacy : StringsEn.readPrivacy;
  String get appVersion =>
      isAr ? StringsAr.appVersion : StringsEn.appVersion;
  String get deleteAccount =>
      isAr ? StringsAr.deleteAccount : StringsEn.deleteAccount;
  String get deleteAccountSubtitle =>
      isAr ? StringsAr.deleteAccountSubtitle : StringsEn.deleteAccountSubtitle;
  String get deleteAccountTitle =>
      isAr ? StringsAr.deleteAccountTitle : StringsEn.deleteAccountTitle;
  String get deleteAccountWarning =>
      isAr ? StringsAr.deleteAccountWarning : StringsEn.deleteAccountWarning;
  String get deleteAccountConfirmHint =>
      isAr ? StringsAr.deleteAccountConfirmHint : StringsEn.deleteAccountConfirmHint;
  String get deleteAccountSubmit =>
      isAr ? StringsAr.deleteAccountSubmit : StringsEn.deleteAccountSubmit;
  String get deleteAccountSuccess =>
      isAr ? StringsAr.deleteAccountSuccess : StringsEn.deleteAccountSuccess;

  // عام
  String get comingSoon => isAr ? StringsAr.comingSoon : StringsEn.comingSoon;
  String get retry => isAr ? StringsAr.retry : StringsEn.retry;
  String get error => isAr ? StringsAr.error : StringsEn.error;
  String get loading => isAr ? StringsAr.loading : StringsEn.loading;

  // Auth
  String get login => isAr ? StringsAr.login : StringsEn.login;
  String get loginSubtitle => isAr ? StringsAr.loginSubtitle : StringsEn.loginSubtitle;
  String get email => isAr ? StringsAr.email : StringsEn.email;
  String get emailHint => isAr ? StringsAr.emailHint : StringsEn.emailHint;
  String get password => isAr ? StringsAr.password : StringsEn.password;
  String get passwordHint => isAr ? StringsAr.passwordHint : StringsEn.passwordHint;
  String get loginButton => isAr ? StringsAr.loginButton : StringsEn.loginButton;
  String get noAccountCreateOne =>
      isAr ? StringsAr.noAccountCreateOne : StringsEn.noAccountCreateOne;
  String get register => isAr ? StringsAr.register : StringsEn.register;
  String get registerSubtitle =>
      isAr ? StringsAr.registerSubtitle : StringsEn.registerSubtitle;
  String get name => isAr ? StringsAr.name : StringsEn.name;
  String get nameHint => isAr ? StringsAr.nameHint : StringsEn.nameHint;
  String get passwordMinHint =>
      isAr ? StringsAr.passwordMinHint : StringsEn.passwordMinHint;
  String get registerButton => isAr ? StringsAr.registerButton : StringsEn.registerButton;
  String get haveAccountLogin =>
      isAr ? StringsAr.haveAccountLogin : StringsEn.haveAccountLogin;
  String get welcomeTo => isAr ? StringsAr.welcomeTo : StringsEn.welcomeTo;
  String get appName => isAr ? StringsAr.appName : StringsEn.appName;
  String get premiumFoodDelivery =>
      isAr ? StringsAr.premiumFoodDelivery : StringsEn.premiumFoodDelivery;
  String get splashTagline =>
      isAr ? StringsAr.splashTagline : StringsEn.splashTagline;

  // Validators
  String validatorFieldRequiredNamed(String f) =>
      isAr ? StringsAr.validatorFieldRequiredNamed(f) : StringsEn.validatorFieldRequiredNamed(f);
  String validatorMinLength(String f, int n) =>
      isAr ? StringsAr.validatorMinLength(f, n) : StringsEn.validatorMinLength(f, n);
  String get validatorEmailRequired =>
      isAr ? StringsAr.validatorEmailRequired : StringsEn.validatorEmailRequired;
  String get validatorEmailInvalid =>
      isAr ? StringsAr.validatorEmailInvalid : StringsEn.validatorEmailInvalid;

  // Feed
  String get viewChef => isAr ? StringsAr.viewChef : StringsEn.viewChef;
  String get readyMeals => isAr ? StringsAr.readyMeals : StringsEn.readyMeals;
  String get readyMealsTooltip =>
      isAr ? StringsAr.readyMealsTooltip : StringsEn.readyMealsTooltip;
  String get bookChef => isAr ? StringsAr.bookChef : StringsEn.bookChef;
  String get requestCooking => isAr ? StringsAr.requestCooking : StringsEn.requestCooking;
  String get requestCookingTooltip =>
      isAr ? StringsAr.requestCookingTooltip : StringsEn.requestCookingTooltip;
  String get homeCookingFeedPrimaryCta =>
      isAr ? StringsAr.homeCookingFeedPrimaryCta : StringsEn.homeCookingFeedPrimaryCta;
  String get homeCookingFeedPrimaryCtaHint =>
      isAr ? StringsAr.homeCookingFeedPrimaryCtaHint : StringsEn.homeCookingFeedPrimaryCtaHint;
  String get popularCookingFeedPrimaryCta =>
      isAr ? StringsAr.popularCookingFeedPrimaryCta : StringsEn.popularCookingFeedPrimaryCta;
  String get popularCookingFeedPrimaryCtaHint =>
      isAr ? StringsAr.popularCookingFeedPrimaryCtaHint : StringsEn.popularCookingFeedPrimaryCtaHint;
  String get grillingFeedPrimaryCta =>
      isAr ? StringsAr.grillingFeedPrimaryCta : StringsEn.grillingFeedPrimaryCta;
  String get grillingFeedPrimaryCtaHint =>
      isAr ? StringsAr.grillingFeedPrimaryCtaHint : StringsEn.grillingFeedPrimaryCtaHint;
  String get privateEventsFeedPrimaryCta =>
      isAr ? StringsAr.privateEventsFeedPrimaryCta : StringsEn.privateEventsFeedPrimaryCta;
  String get privateEventsFeedPrimaryCtaHint =>
      isAr ? StringsAr.privateEventsFeedPrimaryCtaHint : StringsEn.privateEventsFeedPrimaryCtaHint;
  String get requestEvent => isAr ? StringsAr.requestEvent : StringsEn.requestEvent;
  String get bookYourEvent => isAr ? StringsAr.bookYourEvent : StringsEn.bookYourEvent;
  String get unavailableNow => isAr ? StringsAr.unavailableNow : StringsEn.unavailableNow;
  String get signature => isAr ? StringsAr.signature : StringsEn.signature;
  String get sortByDistance => isAr ? StringsAr.sortByDistance : StringsEn.sortByDistance;
  String get sortByRating => isAr ? StringsAr.sortByRating : StringsEn.sortByRating;
  String get distanceWithin => isAr ? StringsAr.distanceWithin : StringsEn.distanceWithin;
  String get allDistances => isAr ? StringsAr.allDistances : StringsEn.allDistances;
  String distanceKm(int km) => isAr ? StringsAr.distanceKm(km) : StringsEn.distanceKm(km);
  String get filters => isAr ? StringsAr.filters : StringsEn.filters;
  String get sortByLabel => isAr ? StringsAr.sortBy : StringsEn.sortBy;
  String get maxDistanceKm => isAr ? StringsAr.maxDistanceKm : StringsEn.maxDistanceKm;
  String get sortByNewest => isAr ? StringsAr.sortByNewest : StringsEn.sortByNewest;
  String get noOffersInCategory =>
      isAr ? StringsAr.noOffersInCategory : StringsEn.noOffersInCategory;
  String get noOffersAvailable =>
      isAr ? StringsAr.noOffersAvailable : StringsEn.noOffersAvailable;
  String noVendorsWithinKm(int km) =>
      isAr ? StringsAr.noVendorsWithinKm(km) : StringsEn.noVendorsWithinKm(km);
  String get tryAnotherCategory =>
      isAr ? StringsAr.tryAnotherCategory : StringsEn.tryAnotherCategory;
  String get backToCategories =>
      isAr ? StringsAr.backToCategories : StringsEn.backToCategories;
  String addedToCartNamed(String name) =>
      isAr ? StringsAr.addedToCartNamed(name) : StringsEn.addedToCartNamed(name);
  String get addToCartFailed => isAr ? StringsAr.addToCartFailed : StringsEn.addToCartFailed;
  String categoryLabel(String key) {
    switch (key) {
      case 'home_cooking':
        return isAr ? StringsAr.categoryHomeCooking : StringsEn.categoryHomeCooking;
      case 'popular_cooking':
        return isAr ? StringsAr.categoryPopularCooking : StringsEn.categoryPopularCooking;
      case 'private_events':
        return isAr ? StringsAr.categoryPrivateEvents : StringsEn.categoryPrivateEvents;
      case 'grilling':
        return isAr ? StringsAr.categoryGrilling : StringsEn.categoryGrilling;
      default:
        return key;
    }
  }
  String get selectService => isAr ? StringsAr.selectService : StringsEn.selectService;
  String get categoriesVideoHint =>
      isAr ? StringsAr.categoriesVideoHint : StringsEn.categoriesVideoHint;

  // Request Chef
  String get selectDateAndTime =>
      isAr ? StringsAr.selectDateAndTime : StringsEn.selectDateAndTime;
  String get selectSlaughterAddress =>
      isAr ? StringsAr.selectSlaughterAddress : StringsEn.selectSlaughterAddress;
  String get selectAtLeastOneDish =>
      isAr ? StringsAr.selectAtLeastOneDish : StringsEn.selectAtLeastOneDish;
  String get chefBookedSuccess =>
      isAr ? StringsAr.chefBookedSuccess : StringsEn.chefBookedSuccess;
  String get orderSentSuccess =>
      isAr ? StringsAr.orderSentSuccess : StringsEn.orderSentSuccess;
  String get requestFailed => isAr ? StringsAr.requestFailed : StringsEn.requestFailed;
  String get servicesOnRequest =>
      isAr ? StringsAr.servicesOnRequest : StringsEn.servicesOnRequest;
  String popularCookingDescWithName(String name) =>
      isAr ? StringsAr.popularCookingDescWithName(name) : StringsEn.popularCookingDescWithName(name);
  String grillingServiceDescWithName(String name) =>
      isAr ? StringsAr.grillingServiceDescWithName(name) : StringsEn.grillingServiceDescWithName(name);
  String homeCookingDescWithName(String name) =>
      isAr ? StringsAr.homeCookingDescWithName(name) : StringsEn.homeCookingDescWithName(name);
  String get selectOnsiteServiceAddress =>
      isAr ? StringsAr.selectOnsiteServiceAddress : StringsEn.selectOnsiteServiceAddress;
  String get noAddressAddOne =>
      isAr ? StringsAr.noAddressAddOne : StringsEn.noAddressAddOne;
  String get noAddressAddOneOnsite =>
      isAr ? StringsAr.noAddressAddOneOnsite : StringsEn.noAddressAddOneOnsite;
  String get addAddress => isAr ? StringsAr.addAddress : StringsEn.addAddress;
  String get sideOrdersOptional =>
      isAr ? StringsAr.sideOrdersOptional : StringsEn.sideOrdersOptional;
  String get tapToSelectSideOrders =>
      isAr ? StringsAr.tapToSelectSideOrders : StringsEn.tapToSelectSideOrders;
  String addOnDisplayName(String key) {
    switch (key) {
      case 'جريش':
        return isAr ? StringsAr.addOnJareesh : StringsEn.addOnJareesh;
      case 'قرصان':
        return isAr ? StringsAr.addOnQursan : StringsEn.addOnQursan;
      case 'إدامات':
        return isAr ? StringsAr.addOnIdamat : StringsEn.addOnIdamat;
      default:
        return key;
    }
  }

  List<String> get addOnFallbackKeys => ['جريش', 'قرصان', 'إدامات'];

  String get whatFromChef =>
      isAr ? StringsAr.whatFromChef : StringsEn.whatFromChef;
  String get selectDishesHint =>
      isAr ? StringsAr.selectDishesHint : StringsEn.selectDishesHint;
  String get whatDoYouWant =>
      isAr ? StringsAr.whatDoYouWant : StringsEn.whatDoYouWant;
  String get whatDoYouWantHint =>
      isAr ? StringsAr.whatDoYouWantHint : StringsEn.whatDoYouWantHint;
  String get enterWhatYouWant =>
      isAr ? StringsAr.enterWhatYouWant : StringsEn.enterWhatYouWant;
  String get enterOrSelectDish =>
      isAr ? StringsAr.enterOrSelectDish : StringsEn.enterOrSelectDish;
  String get noDishesAvailable =>
      isAr ? StringsAr.noDishesAvailable : StringsEn.noDishesAvailable;
  String dishesSelectedCount(int n) =>
      isAr ? StringsAr.dishesSelectedCount(n) : StringsEn.dishesSelectedCount(n);
  String get guestsCount => isAr ? StringsAr.guestsCount : StringsEn.guestsCount;
  String get date => isAr ? StringsAr.date : StringsEn.date;
  String get selectDate => isAr ? StringsAr.selectDate : StringsEn.selectDate;
  String get startTime => isAr ? StringsAr.startTime : StringsEn.startTime;
  String get chefMealSlotTitle =>
      isAr ? StringsAr.chefMealSlotTitle : StringsEn.chefMealSlotTitle;
  String get chefMealSlotLunch =>
      isAr ? StringsAr.chefMealSlotLunch : StringsEn.chefMealSlotLunch;
  String get chefMealSlotDinner =>
      isAr ? StringsAr.chefMealSlotDinner : StringsEn.chefMealSlotDinner;
  String get chefMealSlotLunchHint =>
      isAr ? StringsAr.chefMealSlotLunchHint : StringsEn.chefMealSlotLunchHint;
  String get chefMealSlotDinnerHint =>
      isAr ? StringsAr.chefMealSlotDinnerHint : StringsEn.chefMealSlotDinnerHint;
  String get selectMealSlot =>
      isAr ? StringsAr.selectMealSlot : StringsEn.selectMealSlot;
  String get selectTime => isAr ? StringsAr.selectTime : StringsEn.selectTime;
  String get homeCookingScheduleTitle =>
      isAr ? StringsAr.homeCookingScheduleTitle : StringsEn.homeCookingScheduleTitle;
  String get homeCookingScheduleSubtitle =>
      isAr ? StringsAr.homeCookingScheduleSubtitle : StringsEn.homeCookingScheduleSubtitle;
  String get homeCookingMealBreakfast =>
      isAr ? StringsAr.homeCookingMealBreakfast : StringsEn.homeCookingMealBreakfast;
  String get homeCookingCustomTime =>
      isAr ? StringsAr.homeCookingCustomTime : StringsEn.homeCookingCustomTime;
  String get homeCookingPresetTimeHint =>
      isAr ? StringsAr.homeCookingPresetTimeHint : StringsEn.homeCookingPresetTimeHint;
  String get homeCookingCustomTimeHint =>
      isAr ? StringsAr.homeCookingCustomTimeHint : StringsEn.homeCookingCustomTimeHint;
  String get homeCookingSelectMealSlot =>
      isAr ? StringsAr.homeCookingSelectMealSlot : StringsEn.homeCookingSelectMealSlot;
  String get homeCookingSelectCustomTime =>
      isAr ? StringsAr.homeCookingSelectCustomTime : StringsEn.homeCookingSelectCustomTime;
  String get homeCookingVendorBanner =>
      isAr ? StringsAr.homeCookingVendorBanner : StringsEn.homeCookingVendorBanner;
  String get priceOnRequest => isAr ? StringsAr.priceOnRequest : StringsEn.priceOnRequest;
  String get howToReceive =>
      isAr ? StringsAr.howToReceive : StringsEn.howToReceive;
  String get pickupOrder => isAr ? StringsAr.pickupOrder : StringsEn.pickupOrder;
  String get deliveryOrder =>
      isAr ? StringsAr.deliveryOrder : StringsEn.deliveryOrder;
  String get deliveryToAddress =>
      isAr ? StringsAr.deliveryToAddress : StringsEn.deliveryToAddress;
  String get homeCookingMrsoolDeliveryCaption =>
      isAr ? StringsAr.homeCookingMrsoolDeliveryCaption : StringsEn.homeCookingMrsoolDeliveryCaption;
  String get pickupFromChef =>
      isAr ? StringsAr.pickupFromChef : StringsEn.pickupFromChef;
  String get additionalNotes =>
      isAr ? StringsAr.additionalNotes : StringsEn.additionalNotes;
  String notesHint(bool isPopularCooking) =>
      isPopularCooking
          ? (isAr ? StringsAr.notesHintPopular : StringsEn.notesHintPopular)
          : (isAr ? StringsAr.notesHintHome : StringsEn.notesHintHome);
  String get notesHintGrilling =>
      isAr ? StringsAr.notesHintGrilling : StringsEn.notesHintGrilling;
  String get grillingSelectionsTitle =>
      isAr ? StringsAr.grillingSelectionsTitle : StringsEn.grillingSelectionsTitle;
  String get grillingSelectionsSubtitle =>
      isAr ? StringsAr.grillingSelectionsSubtitle : StringsEn.grillingSelectionsSubtitle;
  String get grillingNotesPrefix =>
      isAr ? StringsAr.grillingNotesPrefix : StringsEn.grillingNotesPrefix;

  /// مفاتيح ثابتة لدمجها في الملاحظات المرسلة للخادم.
  static const List<String> grillingOptionKeys = [
    'kebab',
    'awsal',
    'shish_tawook',
    'kofta',
    'ribs',
    'mixed_grill',
    'hummus',
    'mutabal',
    'cold_appetizers',
  ];

  String grillingOptionLabel(String key) {
    switch (key) {
      case 'kebab':
        return isAr ? StringsAr.grillingOptKebab : StringsEn.grillingOptKebab;
      case 'awsal':
        return isAr ? StringsAr.grillingOptAwsal : StringsEn.grillingOptAwsal;
      case 'shish_tawook':
        return isAr ? StringsAr.grillingOptShishTawook : StringsEn.grillingOptShishTawook;
      case 'kofta':
        return isAr ? StringsAr.grillingOptKofta : StringsEn.grillingOptKofta;
      case 'ribs':
        return isAr ? StringsAr.grillingOptRibs : StringsEn.grillingOptRibs;
      case 'mixed_grill':
        return isAr ? StringsAr.grillingOptMixedGrill : StringsEn.grillingOptMixedGrill;
      case 'hummus':
        return isAr ? StringsAr.grillingOptHummus : StringsEn.grillingOptHummus;
      case 'mutabal':
        return isAr ? StringsAr.grillingOptMutabal : StringsEn.grillingOptMutabal;
      case 'cold_appetizers':
        return isAr ? StringsAr.grillingOptColdAppetizers : StringsEn.grillingOptColdAppetizers;
      default:
        return key;
    }
  }
  String get notesHintHome =>
      isAr ? StringsAr.notesHintHome : StringsEn.notesHintHome;
  String get selectSlaughterAddressBtn =>
      isAr ? StringsAr.selectSlaughterAddressBtn : StringsEn.selectSlaughterAddressBtn;
  String get selectOnsiteServiceAddressBtn =>
      isAr ? StringsAr.selectOnsiteServiceAddressBtn : StringsEn.selectOnsiteServiceAddressBtn;
  String get sendRequest => isAr ? StringsAr.sendRequest : StringsEn.sendRequest;
  String get selectOneDishMin =>
      isAr ? StringsAr.selectOneDishMin : StringsEn.selectOneDishMin;
  String get requestPrivateEvent =>
      isAr ? StringsAr.requestPrivateEvent : StringsEn.requestPrivateEvent;
  String get eventTypeLabel =>
      isAr ? StringsAr.eventTypeLabel : StringsEn.eventTypeLabel;
  String get eventTypeWedding =>
      isAr ? StringsAr.eventTypeWedding : StringsEn.eventTypeWedding;
  String get eventTypeGraduation =>
      isAr ? StringsAr.eventTypeGraduation : StringsEn.eventTypeGraduation;
  String get eventTypeHenna =>
      isAr ? StringsAr.eventTypeHenna : StringsEn.eventTypeHenna;
  String get eventTypeEngagement =>
      isAr ? StringsAr.eventTypeEngagement : StringsEn.eventTypeEngagement;
  String get eventTypeOther =>
      isAr ? StringsAr.eventTypeOther : StringsEn.eventTypeOther;
  String get servicesNeeded =>
      isAr ? StringsAr.servicesNeeded : StringsEn.servicesNeeded;
  String get serviceBuffet =>
      isAr ? StringsAr.serviceBuffet : StringsEn.serviceBuffet;
  String get serviceDesserts =>
      isAr ? StringsAr.serviceDesserts : StringsEn.serviceDesserts;
  String get serviceDrinks =>
      isAr ? StringsAr.serviceDrinks : StringsEn.serviceDrinks;
  String get serviceStaff =>
      isAr ? StringsAr.serviceStaff : StringsEn.serviceStaff;
  String get selectEventAddress =>
      isAr ? StringsAr.selectEventAddress : StringsEn.selectEventAddress;
  String get privateEventRequestSuccess =>
      isAr ? StringsAr.privateEventRequestSuccess : StringsEn.privateEventRequestSuccess;
  String get selectAtLeastOneService =>
      isAr ? StringsAr.selectAtLeastOneService : StringsEn.selectAtLeastOneService;

  // Orders
  String get orderStatusPending =>
      isAr ? StringsAr.orderStatusPending : StringsEn.orderStatusPending;
  String get orderStatusConfirmed =>
      isAr ? StringsAr.orderStatusConfirmed : StringsEn.orderStatusConfirmed;
  String get orderStatusPreparing =>
      isAr ? StringsAr.orderStatusPreparing : StringsEn.orderStatusPreparing;
  String get orderStatusReady =>
      isAr ? StringsAr.orderStatusReady : StringsEn.orderStatusReady;
  String get orderStatusOutForDelivery =>
      isAr ? StringsAr.orderStatusOutForDelivery : StringsEn.orderStatusOutForDelivery;
  String get orderStatusDelivered =>
      isAr ? StringsAr.orderStatusDelivered : StringsEn.orderStatusDelivered;
  String get orderStatusCancelled =>
      isAr ? StringsAr.orderStatusCancelled : StringsEn.orderStatusCancelled;

  String itemsCount(int n) =>
      n == 1
          ? (isAr ? StringsAr.orderItem : StringsEn.orderItem)
          : (isAr ? StringsAr.orderItems : StringsEn.orderItems);

  String get createOrderFailed =>
      isAr ? StringsAr.createOrderFailed : StringsEn.createOrderFailed;
  String get orderConfirmed =>
      isAr ? StringsAr.orderConfirmed : StringsEn.orderConfirmed;
  String get orderPlacedSuccess =>
      isAr ? StringsAr.orderPlacedSuccess : StringsEn.orderPlacedSuccess;
  String get orderNumberLabel =>
      isAr ? StringsAr.orderNumber : StringsEn.orderNumber;
  String get trackOrder => isAr ? StringsAr.trackOrder : StringsEn.trackOrder;
  String get backToFeed => isAr ? StringsAr.backToFeed : StringsEn.backToFeed;
  String get orderSummary =>
      isAr ? StringsAr.orderSummary : StringsEn.orderSummary;
  String get deliveryAddress =>
      isAr ? StringsAr.deliveryAddress : StringsEn.deliveryAddress;
  String get buildingLabel => isAr ? StringsAr.building : StringsEn.building;
  String get apartmentLabel => isAr ? StringsAr.apartment : StringsEn.apartment;
  String get estimatedDelivery =>
      isAr ? StringsAr.estimatedDelivery : StringsEn.estimatedDelivery;
  String get orderDelivered =>
      isAr ? StringsAr.orderDelivered : StringsEn.orderDelivered;
  String get thankYouForOrder =>
      isAr ? StringsAr.thankYouForOrder : StringsEn.thankYouForOrder;
  String get rateYourExperience =>
      isAr ? StringsAr.rateYourExperience : StringsEn.rateYourExperience;
  String get writeReviewHint =>
      isAr ? StringsAr.writeReviewHint : StringsEn.writeReviewHint;
  String get submitRating =>
      isAr ? StringsAr.submitRating : StringsEn.submitRating;
  String get skipForNow => isAr ? StringsAr.skipForNow : StringsEn.skipForNow;
  String get thankYouForFeedback =>
      isAr ? StringsAr.thankYouForFeedback : StringsEn.thankYouForFeedback;
  String get ratingSubmitFailed =>
      isAr ? StringsAr.ratingSubmitFailed : StringsEn.ratingSubmitFailed;

  // Vendor / Search / Profile
  String get all => isAr ? StringsAr.all : StringsEn.all;
  String get regular => isAr ? StringsAr.regular : StringsEn.regular;
  String get reviewsCountLabel =>
      isAr ? StringsAr.reviewsCount : StringsEn.reviewsCount;
  String reviewsCountWithNumber(int n) =>
      isAr ? StringsAr.reviewsCountWithNumber(n) : StringsEn.reviewsCountWithNumber(n);
  String get notAvailable => isAr ? StringsAr.notAvailable : StringsEn.notAvailable;
  String get addedToCartShort =>
      isAr ? StringsAr.addedToCartShort : StringsEn.addedToCartShort;
  String get acceptingOrders =>
      isAr ? StringsAr.acceptingOrders : StringsEn.acceptingOrders;
  String get homeChef => isAr ? StringsAr.homeChef : StringsEn.homeChef;
  String get availableMeals =>
      isAr ? StringsAr.availableMeals : StringsEn.availableMeals;
  String get noMealsAvailable =>
      isAr ? StringsAr.noMealsAvailable : StringsEn.noMealsAvailable;
  String itemNotAvailable(String name) =>
      isAr ? StringsAr.itemNotAvailable(name) : StringsEn.itemNotAvailable(name);
  String itemAddedToCart(String name) =>
      isAr ? StringsAr.itemAddedToCart(name) : StringsEn.itemAddedToCart(name);
  String get search => isAr ? StringsAr.search : StringsEn.search;
  String get searchHint => isAr ? StringsAr.searchHint : StringsEn.searchHint;
  String get noResultsFound =>
      isAr ? StringsAr.noResultsFound : StringsEn.noResultsFound;
  String get tryDifferentSearch =>
      isAr ? StringsAr.tryDifferentSearch : StringsEn.tryDifferentSearch;
  String get user => isAr ? StringsAr.user : StringsEn.user;
  String get emailLabel => isAr ? StringsAr.emailLabel : StringsEn.emailLabel;
  String get phoneLabel => isAr ? StringsAr.phoneLabel : StringsEn.phoneLabel;

  // Addresses
  String get selectAddressTitle =>
      isAr ? StringsAr.selectAddressTitle : StringsEn.selectAddressTitle;
  String get pleaseSelectLocation =>
      isAr ? StringsAr.pleaseSelectLocation : StringsEn.pleaseSelectLocation;
  String get getCurrentLocation =>
      isAr ? StringsAr.getCurrentLocation : StringsEn.getCurrentLocation;
  String get gettingAddress =>
      isAr ? StringsAr.gettingAddress : StringsEn.gettingAddress;
  String get tapToSelectLocation =>
      isAr ? StringsAr.tapToSelectLocation : StringsEn.tapToSelectLocation;
  String get confirmAddress =>
      isAr ? StringsAr.confirmAddress : StringsEn.confirmAddress;
  String get saveAddressFailed =>
      isAr ? StringsAr.saveAddressFailed : StringsEn.saveAddressFailed;
  String get addressNotFound =>
      isAr ? StringsAr.addressNotFound : StringsEn.addressNotFound;
  String get getAddressFailed =>
      isAr ? StringsAr.getAddressFailed : StringsEn.getAddressFailed;
  String get unknownAddress =>
      isAr ? StringsAr.unknownAddress : StringsEn.unknownAddress;
  String get homeAddressLabel =>
      isAr ? StringsAr.homeAddressLabel : StringsEn.homeAddressLabel;
  String get noAddressesSaved =>
      isAr ? StringsAr.noAddressesSaved : StringsEn.noAddressesSaved;
  String get addFirstAddress =>
      isAr ? StringsAr.addFirstAddress : StringsEn.addFirstAddress;
  String get addNewAddress =>
      isAr ? StringsAr.addNewAddress : StringsEn.addNewAddress;
  String get deleteAddress =>
      isAr ? StringsAr.deleteAddress : StringsEn.deleteAddress;
  String get deleteAddressConfirm =>
      isAr ? StringsAr.deleteAddressConfirm : StringsEn.deleteAddressConfirm;
  String get delete => isAr ? StringsAr.delete : StringsEn.delete;
  String get addressDeletedSuccess =>
      isAr ? StringsAr.addressDeletedSuccess : StringsEn.addressDeletedSuccess;
  String get deleteAddressFailed =>
      isAr ? StringsAr.deleteAddressFailed : StringsEn.deleteAddressFailed;
  String get defaultAddressUpdated =>
      isAr ? StringsAr.defaultAddressUpdated : StringsEn.defaultAddressUpdated;
  String get setDefaultAddressFailed =>
      isAr ? StringsAr.setDefaultAddressFailed : StringsEn.setDefaultAddressFailed;
  String get defaultAddress =>
      isAr ? StringsAr.defaultAddress : StringsEn.defaultAddress;
  String get setDefault => isAr ? StringsAr.setDefault : StringsEn.setDefault;

  // Add Card
  String get addPaymentCardTitle =>
      isAr ? StringsAr.addPaymentCardTitle : StringsEn.addPaymentCardTitle;
  String get cardType => isAr ? StringsAr.cardType : StringsEn.cardType;
  String get cardNumber => isAr ? StringsAr.cardNumber : StringsEn.cardNumber;
  String get cardNumberHint =>
      isAr ? StringsAr.cardNumberHint : StringsEn.cardNumberHint;
  String get cardHolderName =>
      isAr ? StringsAr.cardHolderName : StringsEn.cardHolderName;
  String get expiryDate => isAr ? StringsAr.expiryDate : StringsEn.expiryDate;
  String get expiryHint => isAr ? StringsAr.expiryHint : StringsEn.expiryHint;
  String get cvv => isAr ? StringsAr.cvv : StringsEn.cvv;
  String get cvvHint => isAr ? StringsAr.cvvHint : StringsEn.cvvHint;
  String get save => isAr ? StringsAr.save : StringsEn.save;
  String get cardAddedSuccess =>
      isAr ? StringsAr.cardAddedSuccess : StringsEn.cardAddedSuccess;
  String get addCardFailed =>
      isAr ? StringsAr.addCardFailed : StringsEn.addCardFailed;
  String get saveCard => isAr ? StringsAr.saveCard : StringsEn.saveCard;
  String get saving => isAr ? StringsAr.saving : StringsEn.saving;

  // Reviews / Edit Name
  String get reviews => isAr ? StringsAr.reviews : StringsEn.reviews;
  String get noReviewsYet =>
      isAr ? StringsAr.noReviewsYet : StringsEn.noReviewsYet;
  String beFirstToReview(String name) =>
      isAr ? StringsAr.beFirstToReview(name) : StringsEn.beFirstToReview(name);
  String get enterYourName =>
      isAr ? StringsAr.enterYourName : StringsEn.enterYourName;
  String get yourNameHint =>
      isAr ? StringsAr.yourNameHint : StringsEn.yourNameHint;
  String get pleaseEnterName =>
      isAr ? StringsAr.pleaseEnterName : StringsEn.pleaseEnterName;
  String get nameUpdatedSuccess =>
      isAr ? StringsAr.nameUpdatedSuccess : StringsEn.nameUpdatedSuccess;
  String get updateNameFailed =>
      isAr ? StringsAr.updateNameFailed : StringsEn.updateNameFailed;

  // Vendor conflict
  String get differentVendor =>
      isAr ? StringsAr.differentVendor : StringsEn.differentVendor;
  String get cartDifferentVendorMessage => isAr
      ? StringsAr.cartDifferentVendorMessage
      : StringsEn.cartDifferentVendorMessage;
  String get clearAndAdd =>
      isAr ? StringsAr.clearAndAdd : StringsEn.clearAndAdd;

  // Order Tracking
  String get orderTracking =>
      isAr ? StringsAr.orderTracking : StringsEn.orderTracking;
  String get orderStatusLabel =>
      isAr ? StringsAr.orderStatusLabel : StringsEn.orderStatusLabel;
  String get statusAutoRefresh =>
      isAr ? StringsAr.statusAutoRefresh : StringsEn.statusAutoRefresh;
  String get orderDeliveredLabel =>
      isAr ? StringsAr.orderDeliveredLabel : StringsEn.orderDeliveredLabel;
  String get confirmReceivedRate =>
      isAr ? StringsAr.confirmReceivedRate : StringsEn.confirmReceivedRate;
  String get receivedRateNow =>
      isAr ? StringsAr.receivedRateNow : StringsEn.receivedRateNow;
  String orderItemsCount(int n) =>
      isAr ? StringsAr.orderItemsCount(n) : StringsEn.orderItemsCount(n);
  String quantityLabel(int n) =>
      isAr ? StringsAr.quantityLabel(n) : StringsEn.quantityLabel(n);
  String get floorLabel => isAr ? StringsAr.floor : StringsEn.floor;
  String floorWithValue(String v) =>
      isAr ? StringsAr.floorWithValue(v) : StringsEn.floorWithValue(v);
  String get orderSummaryLabel =>
      isAr ? StringsAr.orderSummaryLabel : StringsEn.orderSummaryLabel;

  // Driver Contact
  String get driverPhoneNotAvailable => isAr
      ? StringsAr.driverPhoneNotAvailable
      : StringsEn.driverPhoneNotAvailable;
  String get cannotOpenDialer =>
      isAr ? StringsAr.cannotOpenDialer : StringsEn.cannotOpenDialer;
  String get couldNotStartCall =>
      isAr ? StringsAr.couldNotStartCall : StringsEn.couldNotStartCall;
  String get driverAssigned =>
      isAr ? StringsAr.driverAssigned : StringsEn.driverAssigned;
  String get contactYourDriver =>
      isAr ? StringsAr.contactYourDriver : StringsEn.contactYourDriver;

  // Legal (Privacy & Terms)
  String get legalLastUpdated =>
      isAr ? StringsAr.legalLastUpdated : StringsEn.legalLastUpdated;
  String get privacySection1Title =>
      isAr ? StringsAr.privacySection1Title : StringsEn.privacySection1Title;
  String get privacySection1Body =>
      isAr ? StringsAr.privacySection1Body : StringsEn.privacySection1Body;
  String get privacySection2Title =>
      isAr ? StringsAr.privacySection2Title : StringsEn.privacySection2Title;
  String get privacySection2Body =>
      isAr ? StringsAr.privacySection2Body : StringsEn.privacySection2Body;
  String get privacySection3Title =>
      isAr ? StringsAr.privacySection3Title : StringsEn.privacySection3Title;
  String get privacySection3Body =>
      isAr ? StringsAr.privacySection3Body : StringsEn.privacySection3Body;
  String get privacySection4Title =>
      isAr ? StringsAr.privacySection4Title : StringsEn.privacySection4Title;
  String get privacySection4Body =>
      isAr ? StringsAr.privacySection4Body : StringsEn.privacySection4Body;
  String get privacySection5Title =>
      isAr ? StringsAr.privacySection5Title : StringsEn.privacySection5Title;
  String get privacySection5Body =>
      isAr ? StringsAr.privacySection5Body : StringsEn.privacySection5Body;
  String get privacySection6Title =>
      isAr ? StringsAr.privacySection6Title : StringsEn.privacySection6Title;
  String get privacySection6Body =>
      isAr ? StringsAr.privacySection6Body : StringsEn.privacySection6Body;
  String get termsSection1Title =>
      isAr ? StringsAr.termsSection1Title : StringsEn.termsSection1Title;
  String get termsSection1Body =>
      isAr ? StringsAr.termsSection1Body : StringsEn.termsSection1Body;
  String get termsSection2Title =>
      isAr ? StringsAr.termsSection2Title : StringsEn.termsSection2Title;
  String get termsSection2Body =>
      isAr ? StringsAr.termsSection2Body : StringsEn.termsSection2Body;
  String get termsSection3Title =>
      isAr ? StringsAr.termsSection3Title : StringsEn.termsSection3Title;
  String get termsSection3Body =>
      isAr ? StringsAr.termsSection3Body : StringsEn.termsSection3Body;
  String get termsSection4Title =>
      isAr ? StringsAr.termsSection4Title : StringsEn.termsSection4Title;
  String get termsSection4Body =>
      isAr ? StringsAr.termsSection4Body : StringsEn.termsSection4Body;
  String get termsSection5Title =>
      isAr ? StringsAr.termsSection5Title : StringsEn.termsSection5Title;
  String get termsSection5Body =>
      isAr ? StringsAr.termsSection5Body : StringsEn.termsSection5Body;
  String get termsSection6Title =>
      isAr ? StringsAr.termsSection6Title : StringsEn.termsSection6Title;
  String get termsSection6Body =>
      isAr ? StringsAr.termsSection6Body : StringsEn.termsSection6Body;
  String get termsSection7Title =>
      isAr ? StringsAr.termsSection7Title : StringsEn.termsSection7Title;
  String get termsSection7Body =>
      isAr ? StringsAr.termsSection7Body : StringsEn.termsSection7Body;
  String get termsSection8Title =>
      isAr ? StringsAr.termsSection8Title : StringsEn.termsSection8Title;
  String get termsSection8Body =>
      isAr ? StringsAr.termsSection8Body : StringsEn.termsSection8Body;
  String get termsSection9Title =>
      isAr ? StringsAr.termsSection9Title : StringsEn.termsSection9Title;
  String get termsSection9Body =>
      isAr ? StringsAr.termsSection9Body : StringsEn.termsSection9Body;
  String get termsSection10Title =>
      isAr ? StringsAr.termsSection10Title : StringsEn.termsSection10Title;
  String get termsSection10Body =>
      isAr ? StringsAr.termsSection10Body : StringsEn.termsSection10Body;
  String get termsSection11Title =>
      isAr ? StringsAr.termsSection11Title : StringsEn.termsSection11Title;
  String get termsSection11Body =>
      isAr ? StringsAr.termsSection11Body : StringsEn.termsSection11Body;
  String get termsSection12Title =>
      isAr ? StringsAr.termsSection12Title : StringsEn.termsSection12Title;
  String get termsSection12Body =>
      isAr ? StringsAr.termsSection12Body : StringsEn.termsSection12Body;
  String get termsSection13Title =>
      isAr ? StringsAr.termsSection13Title : StringsEn.termsSection13Title;
  String get termsSection13Body =>
      isAr ? StringsAr.termsSection13Body : StringsEn.termsSection13Body;

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
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
