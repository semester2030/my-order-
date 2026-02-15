/// English strings — Customer App.
class StringsEn {
  StringsEn._();

  // Bottom navigation
  static const String discover = 'Discover';
  static const String cart = 'Cart';
  static const String orders = 'Orders';
  static const String payment = 'Payment';
  static const String profile = 'Profile';

  // Profile
  static const String editName = 'Edit Name';
  static const String myAddresses = 'My Addresses';
  static const String manageAddresses = 'Manage delivery addresses';
  static const String changeAddress = 'Change Address';
  static const String updateAddress = 'Update your delivery address';
  static const String paymentMethods = 'Payment Methods';
  static const String managePaymentCards = 'Add and manage payment cards';
  static const String myOrders = 'My Orders';
  static const String viewOrderHistory = 'View order history';
  static const String settings = 'Settings';
  static const String appSettings = 'App settings and preferences';
  static const String logout = 'Logout';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String cancel = 'Cancel';
  static const String notSet = 'Not set';

  // Cart
  static const String subtotal = 'Subtotal';
  static const String deliveryFee = 'Delivery Fee';
  static const String total = 'Total';
  static const String checkout = 'Checkout';
  static const String cartEmpty = 'Cart is empty';
  static const String cartEmptyTitle = 'Your cart is empty';
  static const String cartEmptyMessage = 'Add items from the feed to get started';
  static const String clearCart = 'Clear';
  static const String clearCartTitle = 'Clear Cart';
  static const String clearCartConfirm = 'Are you sure you want to clear your cart?';
  static const String selectAddress = 'Select Address';
  static const String selectAddressFirst = 'Please select a delivery address first';
  static const String addToCart = 'Add to Cart';
  static const String addedToCart = 'Added to cart';
  static const String viewCart = 'View Cart';

  // Orders
  static const String noOrdersYet = 'No orders yet';
  static const String ordersWillAppear = 'Your orders will appear here';
  static const String browseFeed = 'Browse Feed';

  // Payment
  static const String addPaymentCard = 'Add Payment Card';
  static const String savedPaymentMethods = 'Saved Payment Methods';
  static const String connected = 'Connected';
  static const String noCardsSaved = 'No cards saved';
  static const String notConnected = 'Not connected';

  // Settings
  static const String language = 'Language';
  static const String changeLanguage = 'Change app language';
  static const String languageAr = 'العربية';
  static const String languageEn = 'English';
  static const String notifications = 'Notifications';
  static const String manageNotifications = 'Manage notification preferences';
  static const String theme = 'Theme';
  static const String lightDarkMode = 'Light / Dark mode';
  static const String about = 'About';
  static const String helpSupport = 'Help & Support';
  static const String getHelp = 'Get help and contact support';
  static const String termsConditions = 'Terms & Conditions';
  static const String readTerms = 'Read our terms and conditions';
  static const String privacyPolicy = 'Privacy Policy';
  static const String readPrivacy = 'Read our privacy policy';
  static const String appVersion = 'App Version';

  // General
  static const String comingSoon = 'Coming soon';
  static const String retry = 'Retry';
  static const String error = 'Error';
  static const String loading = 'Loading...';

  // === Auth ===
  static const String login = 'Login';
  static const String loginSubtitle = 'Enter your email and password';
  static const String email = 'Email';
  static const String emailHint = 'example@email.com';
  static const String password = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String loginButton = 'Sign In';
  static const String noAccountCreateOne = "Don't have an account? Create one";
  static const String register = 'Create Account';
  static const String registerSubtitle = 'Name, email, and password';
  static const String name = 'Name';
  static const String nameHint = 'Enter your name';
  static const String passwordMinHint = 'At least 6 characters';
  static const String registerButton = 'Sign Up';
  static const String haveAccountLogin = 'Have an account? Login';
  static const String welcomeTo = 'Welcome to';
  static const String appName = 'My Order';
  static const String premiumFoodDelivery = 'Premium Food Delivery';
  static const String splashTagline = 'Premium Food Delivery';

  // Validators
  static const String validatorFieldRequired = 'This field is required';
  static String validatorFieldRequiredNamed(String f) => '$f is required';
  static String validatorMinLength(String f, int n) => '$f must be at least $n characters';
  static const String validatorEmailRequired = 'Email is required';
  static const String validatorEmailInvalid = 'Please enter a valid email';

  // === Feed ===
  static const String viewChef = 'View Chef';
  static const String readyMeals = 'Ready Meals';
  static const String bookChef = 'Book Chef';
  static const String requestCooking = 'Request Cooking';
  static const String requestEvent = 'Request Event';
  static const String unavailableNow = 'Unavailable now';
  static const String signature = 'Signature';
  static const String sortByDistance = 'Nearest';
  static const String sortByRating = 'Rating';
  static const String sortByNewest = 'Newest';
  static const String noOffersInCategory = 'No offers in';
  static const String noOffersAvailable = 'No offers available';
  static const String tryAnotherCategory = 'Try another category or come back later';
  static const String backToCategories = 'Back to Categories';
  static String addedToCartNamed(String name) => 'Added $name to cart';
  static const String addToCartFailed = 'Failed to add to cart';
  // Provider categories
  static const String categoryHomeCooking = 'Home Cooking';
  static const String categoryPopularCooking = 'Popular Cooking';
  static const String categoryPrivateEvents = 'Private Events';
  static const String categoryGrilling = 'Grilling';
  static const String selectService = 'Select Service';

  // === Request Chef ===
  static const String selectDateAndTime = 'Select date and time';
  static const String selectSlaughterAddress = 'Select slaughter reception address (where cooking will take place)';
  static const String selectAtLeastOneDish = 'Select at least one dish this chef prepares';
  static const String chefBookedSuccess = 'Chef booked. You will hear back soon.';
  static const String orderSentSuccess = 'Request sent. The chef will respond soon.';
  static const String requestFailed = 'Failed to send request';
  static const String servicesOnRequest = 'Services on Request';
  static const String popularCookingDesc = 'Will come to your location to cook (home, farm, retreat). Set address, date, time and number of guests.';
  static const String homeCookingDesc = 'Select dishes you want, then set date, time and number of guests. No payment now — you will receive a quote or acceptance.';
  static String popularCookingDescWithName(String name) => '$name will come to your location to cook (home, farm, retreat). Set address, date, time and number of guests.';
  static String homeCookingDescWithName(String name) => 'Select dishes from $name, then set date, time and number of guests. No payment now — you will receive a quote or acceptance.';
  static const String noAddressAddOne = 'No address. Add an address for slaughter reception.';
  static const String addAddress = 'Add Address';
  static const String sideOrdersOptional = 'Side orders (optional)';
  static const String tapToSelectSideOrders = 'Tap to select side orders you want:';
  static const String addOnJareesh = 'Jareesh';
  static const String addOnQursan = 'Qursan';
  static const String addOnIdamat = 'Idamat';
  static const String whatFromChef = 'What do you want from this chef?';
  static const String selectDishesHint = 'Select the dishes you want (e.g. maqluba, hala tamr, macarona bechamel)';
  static const String noDishesAvailable = 'No dishes available for order from this chef.';
  static String dishesSelectedCount(int n) => '$n dish(es) selected';
  static const String guestsCount = 'Number of guests';
  static const String date = 'Date';
  static const String selectDate = 'Select date';
  static const String startTime = 'Start time';
  static const String selectTime = 'Select time';
  static const String howToReceive = 'How do you want to receive your order?';
  static const String pickupOrder = 'Pickup order';
  static const String deliveryOrder = 'Delivery order';
  static const String deliveryToAddress = 'Order will be delivered to your address';
  static const String pickupFromChef = 'Pickup from chef (chef cooks at their home)';
  static const String additionalNotes = 'Additional notes (optional)';
  static const String notesHintPopular = 'E.g.: number of slaughters, cooking preferences';
  static const String notesHintHome = 'E.g.: no onion, spicy, extra utensils';
  static const String selectSlaughterAddressBtn = 'Select slaughter address';
  static const String sendRequest = 'Send Request';
  static const String selectOneDishMin = 'Select at least one dish';

  // === Orders ===
  static const String orderStatusPending = 'Pending';
  static const String orderStatusConfirmed = 'Confirmed';
  static const String orderStatusPreparing = 'Preparing';
  static const String orderStatusReady = 'Ready';
  static const String orderStatusOutForDelivery = 'Out for Delivery';
  static const String orderStatusDelivered = 'Delivered';
  static const String orderStatusCancelled = 'Cancelled';
  static const String orderItem = 'item';
  static const String orderItems = 'items';
  static const String createOrderFailed = 'Failed to create order';
  static const String orderConfirmed = 'Order Confirmed!';
  static const String orderPlacedSuccess = 'Your order has been placed successfully';
  static const String orderNumber = 'Order Number';
  static const String trackOrder = 'Track Order';
  static const String backToFeed = 'Back to Feed';
  static const String orderSummary = 'Order Summary';
  static const String deliveryAddress = 'Delivery Address';
  static const String building = 'Building';
  static const String apartment = 'Apartment';
  static const String estimatedDelivery = 'Estimated Delivery';
  static const String orderDelivered = 'Order Delivered!';
  static const String thankYouForOrder = 'Thank you for your order';
  static const String rateYourExperience = 'Rate Your Experience';
  static const String writeReviewHint = 'Write a review (optional)';
  static const String submitRating = 'Submit Rating';
  static const String skipForNow = 'Skip for Now';
  static const String thankYouForFeedback = 'Thank you for your feedback!';
  static const String ratingSubmitFailed = 'Failed to submit rating';

  // === Vendor / Search / Profile ===
  static const String all = 'All';
  static const String regular = 'Regular';
  static const String reviewsCount = 'Reviews';
  static String reviewsCountWithNumber(int n) => '($n reviews)';
  static const String notAvailable = 'Unavailable';
  static const String addedToCartShort = 'Added to cart';
  static const String acceptingOrders = 'Accepting orders';
  static const String homeChef = 'Home chef';
  static const String availableMeals = 'Available Meals';
  static const String noMealsAvailable = 'No meals available';
  static String itemNotAvailable(String name) => '$name is not available';
  static String itemAddedToCart(String name) => '$name added to cart';
  static const String search = 'Search';
  static const String searchHint = 'Search for chefs or meals';
  static const String noResultsFound = 'No results found';
  static const String tryDifferentSearch = 'Try a different search term';
  static const String user = 'User';
  static const String emailLabel = 'Email';
  static const String phoneLabel = 'Phone';

  // === Addresses ===
  static const String selectAddressTitle = 'Select Address';
  static const String pleaseSelectLocation = 'Please select a location on the map';
  static const String getCurrentLocation = 'Get current location';
  static const String gettingAddress = 'Getting address...';
  static const String tapToSelectLocation = 'Tap on map to select location';
  static const String confirmAddress = 'Confirm Address';
  static const String saveAddressFailed = 'Failed to save address';
  static const String addressNotFound = 'Address not found';
  static const String getAddressFailed = 'Failed to get address';
  static const String unknownAddress = 'Unknown address';
  static const String homeAddressLabel = 'Home';
  static const String noAddressesSaved = 'No addresses saved';
  static const String addFirstAddress = 'Add your first delivery address';
  static const String addNewAddress = 'Add new address';
  static const String deleteAddress = 'Delete Address';
  static const String deleteAddressConfirm = 'Are you sure you want to delete this address?';
  static const String delete = 'Delete';
  static const String addressDeletedSuccess = 'Address deleted successfully';
  static const String deleteAddressFailed = 'Failed to delete address';
  static const String defaultAddressUpdated = 'Default address updated';
  static const String setDefaultAddressFailed = 'Failed to set default address';
  static const String defaultAddress = 'Default';
  static const String setDefault = 'Set Default';

  // === Add Card / Payment ===
  static const String addPaymentCardTitle = 'Add Payment Card';
  static const String cardType = 'Card Type';
  static const String cardNumber = 'Card Number';
  static const String cardNumberHint = 'XXXX XXXX XXXX XXXX';
  static const String cardHolderName = 'Card Holder Name';
  static const String expiryDate = 'Expiry Date';
  static const String expiryHint = 'MM/YY';
  static const String cvv = 'CVV';
  static const String cvvHint = 'XXX';
  static const String save = 'Save';
  static const String cardAddedSuccess = 'Card added successfully';
  static const String addCardFailed = 'Failed to add card';
  static const String saveCard = 'Save Card';
  static const String saving = 'Saving...';

  // === Reviews / Edit Name ===
  static const String reviews = 'Reviews';
  static const String noReviewsYet = 'No reviews yet';
  static String beFirstToReview(String name) => 'Be the first to review $name';
  static const String enterYourName = 'Enter your name';
  static const String yourNameHint = 'Your name';
  static const String pleaseEnterName = 'Please enter a name';
  static const String nameUpdatedSuccess = 'Name updated successfully';
  static const String updateNameFailed = 'Failed to update name';

  // === Vendor Conflict Dialog ===
  static const String differentVendor = 'Different Vendor';
  static const String cartDifferentVendorMessage =
      'Your cart contains items from a different vendor. Would you like to clear your cart and add this item?';
  static const String clearAndAdd = 'Clear & Add';

  // === Order Tracking ===
  static const String orderTracking = 'Order Tracking';
  static const String orderStatusLabel = 'Order Status';
  static const String statusAutoRefresh =
      'Status updates automatically. Pull down to refresh now.';
  static const String orderDeliveredLabel = 'Order delivered';
  static const String confirmReceivedRate =
      'Confirm you received your order and rate the experience.';
  static const String receivedRateNow = 'I received my order – Rate now';
  static String orderItemsCount(int n) => 'Order Items ($n)';
  static String quantityLabel(int n) => 'Quantity: $n';
  static const String floor = 'Floor';
  static String floorWithValue(String v) => 'Floor: $v';
  static const String orderSummaryLabel = 'Order Summary';

  // === Driver Contact ===
  static const String driverPhoneNotAvailable = 'Driver phone number is not available';
  static const String cannotOpenDialer = 'Cannot open phone dialer';
  static const String couldNotStartCall = 'Could not start call';
  static const String driverAssigned = 'Driver Assigned';
  static const String contactYourDriver = 'Contact your driver';
}
