/// English strings — Phase 16.
class StringsEn {
  StringsEn._();

  static const String appTitle = 'Home Kitchen Chef';
  static const String splashTagline = 'Chef & Service Provider App';
  static const String dashboard = 'Dashboard';
  static const String orders = 'Orders';
  static const String menu = 'Video promo';
  static const String services = 'Available dishes';
  static const String staff = 'Staff';
  static const String settings = 'Settings';
  static const String sideOrders = 'Side Orders';
  static const String analytics = 'Analytics';
  static const String videos = 'Videos';
  static const String videosCountOfMax = 'of 20';
  static const String videosMaxReached = 'Maximum 20 videos. Delete one to add a new video.';
  static const String videosDeleteConfirm = 'Delete this video?';
  static const String videosDeleted = 'Video deleted';
  static const String videoMealLabel = 'Linked menu item';
  static const String delete = 'Delete';
  static const String copy = 'Copy';

  static const String login = 'Login';
  static const String register = 'Register';
  static const String loginChecking = 'Checking...';
  static const String haveAccountLogin = 'Have an account? Login';
  static const String backToLogin = 'Back to Login';
  static const String welcomeBack = 'Welcome back';
  static const String enterEmailPassword = 'Enter email and password';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String createAccount = 'Create account';
  static const String registerSubtitleWithLocation =
      'Required: name, email, password, and your service location (street, city, and a map fix for distance).';
  static const String registerServiceLocationTitle = 'Service location';
  static const String registerStreetAddressLabel = 'Street address';
  static const String registerStreetAddressHint = 'e.g. street, district, building';
  static const String registerCityLabel = 'City';
  static const String registerCityHint = 'e.g. Riyadh';
  static const String registerLatitudeLabel = 'Latitude';
  static const String registerLongitudeLabel = 'Longitude';
  static const String registerCoordinatesHint =
      'Prefer the button below to set your location automatically — faster and more accurate.';
  static const String registerManualCoordinates = 'Enter latitude & longitude manually';
  static const String registerHideManualCoordinates = 'Hide manual coordinates';
  static const String registerNeedLocationOrManual =
      'Set your location: use "Current location" or open manual entry and fill coordinates.';
  static const String registerMapsPasteHint =
      'For manual entry: in Google Maps tap your place, then copy latitude and longitude.';
  static const String registerCoordinatesZero =
      'Coordinates cannot be zero — pick your real location on the map.';
  static const String registerUseMyLocation = 'Use my current location';
  static const String registerFetchingLocation = 'Getting location...';
  static const String registerLocationServiceDisabled =
      'Turn on location (GPS) in your device settings.';
  static const String registerLocationPermissionDenied =
      'Allow location access to fill address and coordinates automatically.';
  static const String registerLocationPermissionForever =
      'Location is blocked in Settings — enable it for this app, then try again.';
  static const String registerLocationPositionUnavailable =
      'Could not get location. Try again or enter coordinates manually from Maps.';
  static const String registerSuccessTitle = 'Registration successful';
  static const String registerSuccessBody =
      'Thank you for registering with Home Kitchen.\n\n'
      '• Check your email: you may receive a confirmation message when sending is enabled on the server (also check spam/junk).\n\n'
      '• Your application status: pending admin approval; this may take some time.\n\n'
      'If approved:\n'
      'Sign in with the same email and password to complete your profile and start working.\n\n'
      'If rejected:\n'
      'After you sign in, a screen will show the reason provided by our team.\n\n'
      'You can go to login now; while waiting you may see an “under review” screen.';
  static const String registerSuccessGoLogin = 'Go to login';
  static const String errorInvalidCredentials = 'Invalid email or password';
  static const String errorNetwork = 'Check your connection and try again';
  static const String errorServer = 'Server error, please try again later';
  static const String errorValidation = 'Invalid input';
  static const String errorGeneric = 'Something went wrong, please try again';

  static const String editProfile = 'Edit Profile';
  static const String changePassword = 'Change Password';
  static const String verifyEmail = 'Verify email';
  static const String verifyEmailDescription =
      'After admin approval, confirm your email with a code sent to your registered address to add meals or upload video.';
  static const String verifyEmailSendOtp = 'Send verification code';
  static const String verifyEmailOtpLabel = 'Verification code';
  static const String verifyEmailConfirm = 'Confirm email';
  static const String verifyEmailSuccess = 'Email verified successfully';
  static const String verifyEmailAlreadyDone = 'Email is already verified.';
  static const String verifyEmailDevCodeTitle = 'Code from server (test mode)';
  static const String verifyEmailDevCodeHint =
      'Shown when the API returns the code (OTP_FORCE_WHITELIST or development). Copy it into the field above.';
  static const String logout = 'Logout';
  static const String language = 'Language';
  static const String languageAr = 'العربية';
  static const String languageEn = 'English';

  static const String privacyPolicy = 'Privacy Policy';
  static const String readPrivacy = 'Open privacy policy on the website';
  static const String termsConditions = 'Terms & Conditions';
  static const String readTerms = 'Open terms on the website';
  static const String deleteAccount = 'Delete account';
  static const String deleteAccountSubtitle =
      'Permanently delete or anonymize your data per our privacy policy';
  static const String deleteAccountTitle = 'Delete account';
  static const String deleteAccountWarning =
      'This cannot be undone. Operational records may be kept without personal identifiers. Enter your password to confirm.';
  static const String deleteAccountPasswordLabel = 'Password';
  static const String deleteAccountSubmit = 'Confirm delete account';
  static const String deleteAccountSuccess =
      'Your request was processed. You can sign in again with a new account if you wish.';
  static const String passwordMinHint = 'At least 6 characters';
  static const String couldNotOpenLink = 'Could not open link';
  static const String loading = 'Loading...';

  static const String ordersSummary = 'Orders Summary';
  static const String menuItemsCount = 'Menu Items Count';
  static const String analyticsSummary = 'Orders & Revenue Summary';
  static const String pendingOrders = 'Pending Orders';
  static const String completedOrders = 'Completed Orders';
  static const String totalRevenue = 'Total Revenue';

  static const String addMeal = 'Add Meal';
  static const String addKitchenPromo = 'Add kitchen profile promo';
  static const String kitchenPromoHeadlineLabel = 'Promo headline';
  static const String kitchenPromoDescriptionChipsTitle =
      'Suggested phrases — tap to insert or edit below';
  static const String kitchenPromoImageOptionalHint =
      'Cover image is optional; video and text are enough.';
  static const String editMeal = 'Edit Meal';
  static const String mealName = 'Meal Name';
  static const String description = 'Description';
  static const String priceSar = 'Price (SAR)';
  static const String priceSarOptional = 'Price (SAR) — optional';
  static const String priceRequired = 'Price is required';
  static const String enterValidPrice = 'Enter a valid price';
  static const String addImage = 'Add Image';
  static const String imageSelected = 'Image selected';
  static const String save = 'Save';
  static const String saving = 'Saving...';
  static const String cancel = 'Cancel';
  static const String noMeals = 'No meals';
  static const String emptyPromoMenuTab = 'No promo items yet';
  static const String noVideosYet = 'No videos yet';
  static const String mealNotFound = 'Meal not found';
  static const String available = 'Available';
  static const String unavailable = 'Unavailable';

  static const String addService = 'Add available dish';
  static const String addMealForMenu = 'Add dish';
  static const String editService = 'Edit available dish';
  static const String serviceName = 'Dish name';
  static const String myServices = 'Available dishes';
  static const String noServices = 'No available dishes yet';
  static const String serviceNotFound = 'Dish not found';
  static const String active = 'Active';
  static const String inactive = 'Inactive';

  static const String addStaff = 'Add Staff';
  static const String editStaff = 'Edit Staff';
  static const String staffName = 'Staff Name';
  static const String roleOptional = 'Role — optional';
  static const String emailOptional = 'Email — optional';
  static const String phoneOptional = 'Phone — optional';
  static const String noStaff = 'No staff';
  static const String staffNotFound = 'Staff not found';

  static const String sideOrdersTitle = 'Side Orders';
  static const String noSideOrderAddOns = 'No side order add-ons';
  static const String addSideOrderItem = 'Add Item';
  static const String editSideOrderItem = 'Edit Item';
  static const String itemName = 'Item Name';
  static const String enterPrice = 'Enter price';

  static const String chooseImageOrVideo = 'Choose image or video';
  static const String imageFromGallery = 'Image from gallery';
  static const String imageFromCamera = 'Image from camera';
  static const String videoFromGallery = 'Video from gallery';
  static const String recordVideo = 'Record video';

  static const String orderDetails = 'Order Details';
  static const String orderAccepted = 'Order accepted';
  static const String orderRejected = 'Order rejected';
  static const String noData = 'No data';
  static const String noOrders = 'No orders';
  static const String uploadingImage = 'Uploading image...';
  static const String uploadingVideo = 'Uploading video...';
  static const String retry = 'Retry';

  // المناسبات الخاصة
  static const String eventOffers = 'Event Offers';
  static const String eventRequests = 'Event Requests';
  static const String eventOfferBuffet = 'Buffet';
  static const String eventOfferDesserts = 'Desserts';
  static const String eventOfferDrinks = 'Drinks';
  static const String eventOfferStaff = 'Staff';
  static const String eventTypeWedding = 'Wedding';
  static const String eventTypeGraduation = 'Graduation';
  static const String eventTypeHenna = 'Henna';
  static const String eventTypeEngagement = 'Engagement';
  static const String eventTypeOther = 'Other';
  static const String addEventOffer = 'Add Offer';
  static const String editEventOffer = 'Edit Offer';
  static const String noEventOffers = 'No offers';
  static const String noEventRequests = 'No requests';
  // Slaughter & BBQ bookings (separate from private events)
  static const String chefBookingRequests = 'Slaughter & BBQ bookings';
  static const String noChefBookingRequests = 'No bookings yet';
  static const String homeCookingRequests = 'Home cooking requests';
  static const String noHomeCookingRequests = 'No home cooking requests yet';
  static const String homeCookingStatusQuoted = 'Quoted — awaiting customer';
  static const String homeCookingStatusPaymentPending =
      'Customer declared transfer — pending verification';
  static const String homeCookingStatusAccepted = 'Payment verified — preparing';
  static const String homeCookingStatusReady = 'Ready for pickup';
  static const String homeCookingQuoteDialogTitle = 'Quote (SAR)';
  static const String homeCookingQuoteAmountHint = 'Total amount';
  static const String homeCookingQuoteNotesHint = 'Notes for customer (optional)';
  static const String homeCookingSendQuote = 'Send quote';
  static const String homeCookingRejectRequest = 'Reject request';
  static const String homeCookingMarkReady = 'Mark ready for pickup';
  static const String homeCookingInvalidAmount = 'Enter a valid amount';
  static const String homeCookingDeliveryYes = 'Delivery';
  static const String homeCookingDeliveryNo = 'Pickup';
  static const String homeCookingQuotedAmount = 'Quoted amount';
  static const String homeCookingStatusReadyShort = 'Ready — confirm handover to customer or courier';
  static const String homeCookingStatusHandedOver = 'Handed over — awaiting customer receipt confirmation';
  static const String homeCookingStatusCompleted = 'Completed — completion code on customer & admin';
  static const String homeCookingMarkHandedOverButton = 'Confirm handover';
  static const String homeCookingHandoverDialogTitle = 'Confirm handover';
  static const String homeCookingHandoverDialogSubtitle =
      'Whether the customer picked up in person or a courier/intermediary received the order.';
  static const String homeCookingHandoverNotesHint =
      'Optional note (e.g. courier name, delivery company)';
  static const String homeCookingHandoverConfirm = 'Confirm handover';
  static const String homeCookingHandedOverSuccess = 'Handover recorded';
  static const String homeCookingCompletionRefLabel = 'Completion code (after customer confirms)';
  static const String chefBookingTypePopularCooking = 'Popular cooking';
  static const String chefBookingTypeGrilling = 'Outdoor grilling';
  static const String chefBookingStatusAccepted = 'Accepted';
  static const String chefBookingStatusRejected = 'Rejected';
  static const String chefBookingStatusCancelled = 'Cancelled';
  static String chefBookingRespondByLine(String formatted) =>
      'Response deadline: $formatted';
  static const String chefMealSlotLunch = 'Lunch';
  static const String chefMealSlotDinner = 'Dinner';
  static const String accept = 'Accept';
  static const String reject = 'Reject';
  static const String eventStatusPending = 'Pending';
  static const String eventType = 'Event Type';
  static const String serviceType = 'Service Type';
  static const String titleOptional = 'Title — optional';
  static const String minGuests = 'Min Guests';
  static const String maxGuests = 'Max Guests';
  static const String pricePerPersonOptional = 'Price per person (SAR) — optional';
  static const String priceTotalOptional = 'Total price (SAR) — optional';
  static String guestsCount(int n) => '$n guests';

  static const String menuOfferingTermsTitle = 'General terms for listing meals';
  static const String menuOfferingTermsSubtitle =
      'Applies to all provider categories. Full legal text can be added later without changing the acceptance flow.';
  static const String menuOfferingTermsNotice =
      'Below is a temporary framework of common obligations; replace or expand with full legal wording as needed.';
  static const String menuOfferingTermsBullet1 =
      'Accurate meal descriptions and pricing — no misleading information.';
  static const String menuOfferingTermsBullet2 =
      'No content or media that violates law or public decency.';
  static const String menuOfferingTermsBullet3 =
      'Follow platform policies when dealing with customers and orders.';
  static const String menuOfferingTermsBullet4 =
      'Update listings when the product, price, or availability changes.';
  static const String menuOfferingTermsBullet5 =
      'The provider is responsible for the accuracy of displayed information.';
  static const String menuOfferingTermsReadCheckbox =
      'I have read the terms above and agree to comply.';
  static const String menuOfferingTermsAgreeButton = 'Agree and continue';
  static const String menuOfferingTermsVersionLabel = 'Terms version';
  static const String menuOfferingTermsLoading = 'Loading...';
  static const String menuOfferingTermsSubmitting = 'Saving...';

  static const String vendorCombinedTermsTitle = 'Terms & obligations';
  static const String vendorPlatformTermsSectionTitle = 'General platform rules';
  static const String vendorPlatformTermsIntro =
      'By agreeing, you acknowledge the following as a service provider on the Home Kitchen platform. This copy can be updated when needed.';
  static const String vendorPlatformTermsFeesTitle = 'Fees and commission';
  static const String vendorPlatformTermsFeesBody =
      'The platform may charge fees or commission on orders or listed services. Rates, deduction method, and payment rules are set by admin policy and notices. You are responsible for reviewing updates.';
  static const String vendorPlatformTermsPayoutTitle = 'Payouts and settlement';
  static const String vendorPlatformTermsPayoutBody =
      'Your payouts follow the platform’s payment policy (e.g. periodic or after delivery confirmation), after deducting any platform fees or commission.';
  static const String vendorPlatformTermsComplianceTitle = 'Accuracy and compliance';
  static const String vendorPlatformTermsComplianceBody =
      'You provide accurate information about meals, prices, and availability, and comply with applicable laws and regulations in Saudi Arabia.';
  static const String vendorCombinedTermsMenuSectionTitle = 'General terms for listing meals';
  static const String vendorCategoryTermsSectionTitle = 'Category-specific terms (coming later)';
  static const String vendorCategoryTermsPlaceholder =
      'Additional terms may apply per provider category (home kitchen, outdoor BBQ, events & parties, etc.). Content is not finalized yet and will be added later without changing this acceptance screen.';
  static const String vendorLegalAlreadyAccepted = 'Platform terms for this version were already accepted.';
  static const String vendorMenuTermsAlreadyAccepted = 'Meal listing terms for this version were already accepted.';
  static const String vendorCombinedTermsReadCheckbox =
      'I have read the general platform rules, the general meal listing terms, and the category section (when available), and I agree to comply.';
  static const String vendorCombinedTermsLegalVersionLabel = 'Platform terms version';
}
