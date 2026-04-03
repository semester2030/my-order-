/// النصوص العربية — تطبيق العميل.
class StringsAr {
  StringsAr._();

  // التنقل السفلي
  static const String discover = 'اكتشف';
  static const String cart = 'السلة';
  static const String orders = 'طلباتي';
  static const String payment = 'الدفع';
  static const String profile = 'البروفايل';

  // البروفايل
  static const String editName = 'تعديل الاسم';
  static const String myAddresses = 'عناويني';
  static const String manageAddresses = 'إدارة عناوين التوصيل';
  static const String changeAddress = 'تغيير العنوان';
  static const String updateAddress = 'تحديث عنوان التوصيل';
  static const String paymentMethods = 'طرق الدفع';
  static const String managePaymentCards = 'إضافة وإدارة البطاقات';
  static const String myOrders = 'طلباتي';
  static const String viewOrderHistory = 'عرض سجل الطلبات';
  static const String settings = 'الإعدادات';
  static const String appSettings = 'إعدادات التطبيق';
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirm = 'هل أنت متأكد من تسجيل الخروج؟';
  static const String cancel = 'إلغاء';
  static const String notSet = 'غير محدد';

  // السلة
  static const String subtotal = 'المجموع الفرعي';
  static const String deliveryFee = 'رسوم التوصيل';
  static const String total = 'المجموع';
  static const String checkout = 'إتمام الطلب';
  static const String cartEmpty = 'السلة فارغة';
  static const String cartEmptyTitle = 'السلة فارغة';
  static const String cartEmptyMessage = 'أضف منتجات من الفيديو للبدء';
  static const String clearCart = 'مسح';
  static const String clearCartTitle = 'مسح السلة';
  static const String clearCartConfirm = 'هل تريد مسح جميع المنتجات من السلة؟';
  static const String selectAddress = 'اختر العنوان';
  static const String selectAddressFirst = 'يرجى اختيار عنوان التوصيل أولاً';
  static const String addToCart = 'أضف للسلة';
  static const String addedToCart = 'تمت الإضافة إلى السلة';
  static const String viewCart = 'عرض السلة';
  static const String whenDoYouWantOrder = 'متى تريد الطلب؟';
  static const String readyNow = 'جاهز الآن';
  static const String scheduledFor = 'في وقت محدد';
  static const String continueToPayment = 'متابعة للدفع';

  // الطلبات
  static const String noOrdersYet = 'لا توجد طلبات بعد';
  static const String ordersWillAppear = 'ستظهر طلباتك هنا';
  static const String browseFeed = 'تصفح الفيديو';

  // الدفع
  static const String addPaymentCard = 'إضافة بطاقة دفع';
  static const String savedPaymentMethods = 'طرق الدفع المحفوظة';
  static const String connected = 'متصل';
  static const String noCardsSaved = 'لا توجد بطاقات محفوظة';
  static const String notConnected = 'غير متصل';

  // الإعدادات
  static const String language = 'اللغة';
  static const String changeLanguage = 'تغيير لغة التطبيق';
  static const String languageAr = 'العربية';
  static const String languageEn = 'English';
  static const String notifications = 'الإشعارات';
  static const String manageNotifications = 'إدارة تفضيلات الإشعارات';
  static const String theme = 'المظهر';
  static const String lightDarkMode = 'الوضع الفاتح / الداكن';
  static const String about = 'حول التطبيق';
  static const String helpSupport = 'المساعدة والدعم';
  static const String getHelp = 'الحصول على المساعدة والتواصل';
  static const String termsConditions = 'الشروط والأحكام';
  static const String readTerms = 'قراءة الشروط والأحكام';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String readPrivacy = 'قراءة سياسة الخصوصية';
  static const String appVersion = 'إصدار التطبيق';
  static const String deleteAccount = 'حذف الحساب';
  static const String deleteAccountSubtitle =
      'حذف نهائي أو إخفاء بياناتك وفق سياسة الخصوصية';
  static const String deleteAccountTitle = 'حذف الحساب';
  static const String deleteAccountWarning =
      'لا يمكن التراجع. إن وُجدت طلبات سابقة قد نُبقي سجلات الطلبات دون بيانات تعريفية. أدخل الرمز السري للتأكيد.';
  static const String deleteAccountConfirmHint = 'الرمز السري';
  static const String deleteAccountSubmit = 'تأكيد حذف الحساب';
  static const String deleteAccountSuccess = 'تمت معالجة طلبك. سجّل الدخول إن أنشأت حساباً جديداً.';

  // رسائل عامة
  static const String comingSoon = 'قريباً';
  static const String retry = 'إعادة المحاولة';
  static const String error = 'خطأ';
  static const String loading = 'جاري التحميل...';

  // === Auth ===
  static const String login = 'تسجيل الدخول';
  static const String loginSubtitle = 'أدخل بريدك والرمز السري';
  static const String email = 'البريد الإلكتروني';
  static const String emailHint = 'example@email.com';
  static const String password = 'الرمز السري';
  static const String passwordHint = 'أدخل الرمز السري';
  static const String loginButton = 'دخول';
  static const String noAccountCreateOne = 'ليس لديك حساب؟ إنشاء حساب';
  static const String register = 'إنشاء حساب';
  static const String registerSubtitle = 'الاسم، البريد الإلكتروني، والرمز السري';
  static const String name = 'الاسم';
  static const String nameHint = 'أدخل اسمك';
  static const String passwordMinHint = '6 أحرف على الأقل';
  static const String registerButton = 'تسجيل';
  static const String haveAccountLogin = 'لديك حساب؟ تسجيل الدخول';
  static const String welcomeTo = 'مرحباً بك في';
  static const String appName = 'مطبخ البيت';
  static const String premiumFoodDelivery = 'توصيل طعام منزلي أصيل';
  static const String splashTagline = 'طعام منزلي إلى بابك';

  // Validators
  static const String validatorFieldRequired = 'هذا الحقل مطلوب';
  static String validatorFieldRequiredNamed(String f) => '$f مطلوب';
  static String validatorMinLength(String f, int n) => '$f يجب أن يكون $n أحرف على الأقل';
  static const String validatorEmailRequired = 'البريد الإلكتروني مطلوب';
  static const String validatorEmailInvalid = 'أدخل بريداً إلكترونياً صالحاً';

  // === Feed ===
  static const String viewChef = 'عرض الطباخ';
  static const String readyMeals = 'وجبات جاهزة';
  static const String readyMealsTooltip = 'عرض قائمة الوجبات الجاهزة بأسعار ثابتة';
  static const String bookChef = 'احجز الطباخ';
  static const String requestCooking = 'اطلب وجبتك المخصصة';
  static const String requestCookingTooltip = 'اطلب طبخة غير موجودة في القائمة';
  static const String requestEvent = 'طلب مناسبة';
  static const String unavailableNow = 'غير متوفر حالياً';
  static const String signature = 'Signature';
  static const String sortByDistance = 'الأقرب';
  static const String sortByRating = 'التقييم';
  static const String sortByNewest = 'الأحدث';
  static const String distanceWithin = 'ضمن';
  static const String allDistances = 'كل المسافات';
  static String distanceKm(int km) => '$km كم';
  static const String filters = 'الفلاتر';
  static const String sortBy = 'الترتيب';
  static const String maxDistanceKm = 'المسافة (كم)';
  static const String noOffersInCategory = 'لا عروض حالياً في';
  static const String noOffersAvailable = 'لا عروض متاحة حالياً';
  static String noVendorsWithinKm(int km) => 'لا توجد طباخات ضمن $km كم من موقعك. جرّب زيادة نطاق المسافة.';
  static const String tryAnotherCategory = 'جرّب فئة أخرى أو عد لاحقاً';
  static const String backToCategories = 'العودة للفئات';
  static String addedToCartNamed(String name) => 'تمت إضافة $name إلى السلة';
  static const String addToCartFailed = 'فشل الإضافة للسلة';
  // فئات المزودين
  static const String categoryHomeCooking = 'الطبخ المنزلي';
  static const String categoryPopularCooking = 'الطبخ الشعبي';
  static const String categoryPrivateEvents = 'المناسبات الخاصة';
  static const String categoryGrilling = 'الشوي';
  static const String selectService = 'اختر الخدمة';

  // === Request Chef ===
  static const String selectDateAndTime = 'اختر التاريخ والوقت';
  static const String selectSlaughterAddress = 'اختر عنوان استقبال الذبايح (مكان الطبخ عندك)';
  static const String selectAtLeastOneDish = 'اختر طبقاً واحداً على الأقل مما تتقنه الطباخة';
  static const String enterOrSelectDish = 'اكتب ما تريد أو اختر من القائمة';
  static const String chefBookedSuccess = 'تم حجز الطباخ. سيتم الرد قريباً.';
  static const String orderSentSuccess = 'تم إرسال الطلب. سيتم الرد من الطباخة قريباً.';
  static const String requestFailed = 'فشل إرسال الطلب';
  static const String servicesOnRequest = 'خدمات عند الطلب';
  static const String popularCookingDesc = 'سيأتي عندك ليطبخ الذبايح في مكانك (المنزل، المزرعة، الاستراحة). حدد العنوان والتاريخ والوقت وعدد الأشخاص.';
  static const String homeCookingDesc = 'اطلب ما تريد من مقدم الخدمة — حدد التاريخ والوقت وعدد الأشخاص. لا دفع الآن — سيُرد عليك بعرض سعر أو قبول.';
  static String popularCookingDescWithName(String name) => '$name سيأتي عندك ليطبخ الذبايح في مكانك (المنزل، المزرعة، الاستراحة). حدد العنوان والتاريخ والوقت وعدد الأشخاص.';
  static String homeCookingDescWithName(String name) => 'اطلب ما تريد من $name — حدد التاريخ والوقت وعدد الأشخاص. لا دفع الآن — سيُرد عليك بعرض سعر أو قبول.';
  static const String noAddressAddOne = 'لا يوجد عنوان. أضف عنواناً لاستقبال الذبايح.';
  static const String addAddress = 'إضافة عنوان';
  static const String sideOrdersOptional = 'طلبات جانبية (اختياري)';
  static const String tapToSelectSideOrders = 'اضغط لاختيار الطلبات الجانبية المطلوبة:';
  static const String addOnJareesh = 'جريش';
  static const String addOnQursan = 'قرصان';
  static const String addOnIdamat = 'إدامات';
  static const String whatFromChef = 'ماذا تريد من هذه الطباخة؟';
  static const String selectDishesHint = 'اختر الأطباق المطلوبة (مثلاً: مقلوبة، حلا تمر، مكرونة بشاميل)';
  static const String whatDoYouWant = 'ماذا تريد؟';
  static const String whatDoYouWantHint = 'اكتب ما تريد من مقدم الخدمة — مثال: كبسة لحم، إدام، سلطة لـ ٥ أشخاص';
  static const String enterWhatYouWant = 'اختر من القائمة أو اكتب ما تريد';
  static const String noDishesAvailable = 'لا توجد أطباق متاحة للطلب حالياً من هذه الطباخة.';
  static String dishesSelectedCount(int n) => 'تم اختيار $n طبق/أطباق';
  static const String guestsCount = 'عدد الأشخاص';
  static const String date = 'التاريخ';
  static const String selectDate = 'اختر التاريخ';
  static const String startTime = 'وقت البدء';
  static const String selectTime = 'اختر الوقت';
  static const String howToReceive = 'كيف تريد استلام الطلب؟';
  static const String pickupOrder = 'استلام الطلب';
  static const String deliveryOrder = 'توصيل الطلب';
  static const String deliveryToAddress = 'سيتم توصيل الطلب إلى عنوانك';
  static const String pickupFromChef = 'استلام الطلب من عند الطباخ (الطباخ يطبخ في بيته)';
  static const String additionalNotes = 'ملاحظات إضافية (اختياري)';
  static const String notesHintPopular = 'مثال: عدد الذبايح، تفضيلات الطبخ';
  static const String notesHintHome = 'مثال: بدون بصل، حار، أدوات إضافية';
  static const String selectSlaughterAddressBtn = 'اختر عنوان استقبال الذبايح';
  static const String sendRequest = 'إرسال الطلب';
  static const String selectOneDishMin = 'اختر طبقاً واحداً على الأقل';

  // === المناسبات الخاصة ===
  static const String requestPrivateEvent = 'طلب مناسبة';
  static const String eventTypeLabel = 'نوع المناسبة';
  static const String eventTypeWedding = 'حفل زواج';
  static const String eventTypeGraduation = 'حفل تخرج';
  static const String eventTypeHenna = 'حفل ملكة';
  static const String eventTypeEngagement = 'خطوبة';
  static const String eventTypeOther = 'أخرى';
  static const String servicesNeeded = 'الخدمات المطلوبة';
  static const String serviceBuffet = 'بوفيه مفتوح';
  static const String serviceDesserts = 'حلويات';
  static const String serviceDrinks = 'عصائر ومشروبات';
  static const String serviceStaff = 'مقدمي خدمة (ندل)';
  static const String selectEventAddress = 'عنوان المناسبة';
  static const String privateEventRequestSuccess = 'تم إرسال الطلب. سيتم الرد من مقدم الخدمة قريباً.';
  static const String selectAtLeastOneService = 'اختر خدمة واحدة على الأقل';

  // === Orders ===
  static const String orderStatusPending = 'قيد الانتظار';
  static const String orderStatusConfirmed = 'مؤكد';
  static const String orderStatusPreparing = 'قيد التحضير';
  static const String orderStatusReady = 'جاهز';
  static const String orderStatusOutForDelivery = 'خارج للتوصيل';
  static const String orderStatusDelivered = 'تم التوصيل';
  static const String orderStatusCancelled = 'ملغي';
  static const String orderItem = 'عنصر';
  static const String orderItems = 'عناصر';
  static const String createOrderFailed = 'فشل إنشاء الطلب';
  static const String orderConfirmed = 'تم تأكيد الطلب!';
  static const String orderPlacedSuccess = 'تم تقديم طلبك بنجاح';
  static const String orderNumber = 'رقم الطلب';
  static const String trackOrder = 'تتبع الطلب';
  static const String backToFeed = 'العودة للفيديو';
  static const String orderSummary = 'ملخص الطلب';
  static const String deliveryAddress = 'عنوان التوصيل';
  static const String building = 'مبنى';
  static const String apartment = 'شقة';
  static const String estimatedDelivery = 'وقت التوصيل المتوقع';
  static const String orderDelivered = 'تم التوصيل!';
  static const String thankYouForOrder = 'شكراً لطلبك';
  static const String rateYourExperience = 'قيّم تجربتك';
  static const String writeReviewHint = 'اكتب تقييماً (اختياري)';
  static const String submitRating = 'إرسال التقييم';
  static const String skipForNow = 'تخطي الآن';
  static const String thankYouForFeedback = 'شكراً لتعليقك!';
  static const String ratingSubmitFailed = 'فشل إرسال التقييم';

  // === Vendor / Search / Profile ===
  static const String all = 'الكل';
  static const String regular = 'عادي';
  static const String reviewsCount = 'المراجعات';
  static String reviewsCountWithNumber(int n) => '($n مراجعة)';
  static const String notAvailable = 'غير متوفر';
  static const String addedToCartShort = 'تمت الإضافة للسلة';
  static const String acceptingOrders = 'يقبل الطلبات';
  static const String homeChef = 'طباخ منزلي';
  static const String availableMeals = 'الوجبات المتاحة';
  static const String noMealsAvailable = 'لا توجد وجبات متاحة حالياً';
  static String itemNotAvailable(String name) => '$name غير متوفر';
  static String itemAddedToCart(String name) => 'تمت إضافة $name إلى السلة';
  static const String search = 'البحث';
  static const String searchHint = 'البحث عن طباخين أو وجبات';
  static const String noResultsFound = 'لا توجد نتائج';
  static const String tryDifferentSearch = 'جرّب مصطلح بحث مختلف';
  static const String user = 'مستخدم';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String phoneLabel = 'رقم الجوال';

  // === Addresses ===
  static const String selectAddressTitle = 'اختر العنوان';
  static const String pleaseSelectLocation = 'يرجى اختيار موقع على الخريطة';
  static const String getCurrentLocation = 'الموقع الحالي';
  static const String gettingAddress = 'جاري الحصول على العنوان...';
  static const String tapToSelectLocation = 'اضغط على الخريطة لاختيار الموقع';
  static const String confirmAddress = 'تأكيد العنوان';
  static const String saveAddressFailed = 'فشل حفظ العنوان';
  static const String addressNotFound = 'لم يتم العثور على العنوان';
  static const String getAddressFailed = 'فشل الحصول على العنوان';
  static const String unknownAddress = 'عنوان غير معروف';
  static const String homeAddressLabel = 'المنزل';
  static const String noAddressesSaved = 'لا توجد عناوين محفوظة';
  static const String addFirstAddress = 'أضف عنوان التوصيل الأول';
  static const String addNewAddress = 'إضافة عنوان جديد';
  static const String deleteAddress = 'حذف العنوان';
  static const String deleteAddressConfirm = 'هل أنت متأكد من حذف هذا العنوان؟';
  static const String delete = 'حذف';
  static const String addressDeletedSuccess = 'تم حذف العنوان بنجاح';
  static const String deleteAddressFailed = 'فشل حذف العنوان';
  static const String defaultAddressUpdated = 'تم تحديث العنوان الافتراضي';
  static const String setDefaultAddressFailed = 'فشل تعيين العنوان الافتراضي';
  static const String defaultAddress = 'افتراضي';
  static const String setDefault = 'تعيين كافتراضي';

  // === Add Card / Payment ===
  static const String addPaymentCardTitle = 'إضافة بطاقة دفع';
  static const String cardType = 'نوع البطاقة';
  static const String cardNumber = 'رقم البطاقة';
  static const String cardNumberHint = 'XXXX XXXX XXXX XXXX';
  static const String cardHolderName = 'اسم حامل البطاقة';
  static const String expiryDate = 'تاريخ الانتهاء';
  static const String expiryHint = 'MM/YY';
  static const String cvv = 'CVV';
  static const String cvvHint = 'XXX';
  static const String save = 'حفظ';
  static const String cardAddedSuccess = 'تم إضافة البطاقة بنجاح';
  static const String addCardFailed = 'فشل إضافة البطاقة';
  static const String saveCard = 'حفظ البطاقة';
  static const String saving = 'جاري الحفظ...';

  // === Reviews / Edit Name ===
  static const String reviews = 'المراجعات';
  static const String noReviewsYet = 'لا توجد مراجعات بعد';
  static String beFirstToReview(String name) => 'كن أول من يقيّم $name';
  static const String enterYourName = 'أدخل اسمك';
  static const String yourNameHint = 'اسمك';
  static const String pleaseEnterName = 'يرجى إدخال اسم';
  static const String nameUpdatedSuccess = 'تم تحديث الاسم بنجاح';
  static const String updateNameFailed = 'فشل تحديث الاسم';

  // === Vendor Conflict Dialog ===
  static const String differentVendor = 'مورد مختلف';
  static const String cartDifferentVendorMessage =
      'تحتوي سلتك على عناصر من مورد مختلف. هل تريد مسح السلة وإضافة هذا العنصر؟';
  static const String clearAndAdd = 'مسح وإضافة';

  // === Order Tracking ===
  static const String orderTracking = 'تتبع الطلب';
  static const String orderStatusLabel = 'حالة الطلب';
  static const String statusAutoRefresh = 'تحدث الحالة تلقائياً. اسحب للأسفل للتحديث الآن.';
  static const String orderDeliveredLabel = 'تم توصيل الطلب';
  static const String confirmReceivedRate =
      'أكد استلام طلبك وقيّم التجربة.';
  static const String receivedRateNow = 'استلمت طلبي — قيّم الآن';
  static String orderItemsCount(int n) => 'عناصر الطلب ($n)';
  static String quantityLabel(int n) => 'الكمية: $n';
  static const String floor = 'الطابق';
  static String floorWithValue(String v) => 'الطابق: $v';
  static const String orderSummaryLabel = 'ملخص الطلب';

  // === Driver Contact ===
  static const String driverPhoneNotAvailable = 'رقم هاتف السائق غير متوفر';
  static const String cannotOpenDialer = 'لا يمكن فتح تطبيق الاتصال';
  static const String couldNotStartCall = 'تعذر بدء المكالمة';
  static const String driverAssigned = 'تم تعيين السائق';
  static const String contactYourDriver = 'تواصل مع السائق';

  // === Legal (سياسة الخصوصية والشروط) ===
  static const String legalLastUpdated = 'آخر تحديث: يناير 2026';

  // سياسة الخصوصية — تطبق على العملاء ومقدمي الخدمة
  static const String privacySection1Title = '١. البيانات التي نجمعها';
  static const String privacySection1Body =
      'نجمع البيانات اللازمة لتقديم الخدمة. للعملاء: رقم الهاتف، البريد الإلكتروني، الاسم، عنوان التوصيل، وبيانات الدفع (تُخزّن بشكل آمن عبر معالجات الدفع). لمقدمي الخدمة: بيانات التسجيل، معلومات المطبخ، الصور والفيديوهات، وأسعار الوجبات.';
  static const String privacySection2Title = '٢. استخدام البيانات';
  static const String privacySection2Body =
      'نستخدم بياناتك لـ: تنفيذ الطلبات وربط العملاء بمقدمي الخدمة، التواصل معك، تحسين الخدمة، عرض المحتوى (مثل فيديوهات الطباخين)، والامتثال للقانون.';
  static const String privacySection3Title = '٣. مشاركة البيانات';
  static const String privacySection3Body =
      'لا نبيع بياناتك. نشاركها فقط مع: مقدمي الخدمة (للطلبات) أو العملاء (لتنفيذ الطلب)، شركات التوصيل إن وُجدت، ومعالجات الدفع. قد نشارك بيانات مجمعة (بدون تعريف) لأغراض إحصائية.';
  static const String privacySection4Title = '٤. الأمان';
  static const String privacySection4Body =
      'نحمي بياناتك بتشفير الاتصال (HTTPS)، تخزين آمن للتوكنات، ولا نخزن كلمات المرور بصيغة نصية. نوصي بعدم مشاركة بيانات الدخول مع أي شخص.';
  static const String privacySection5Title = '٥. حقوقك';
  static const String privacySection5Body =
      'يمكنك طلب الوصول لبياناتك أو تصحيحها أو حذفها عبر التواصل معنا. قد نحتفظ ببعض البيانات للالتزامات القانونية أو حل النزاعات.';
  static const String privacySection6Title = '٦. التواصل';
  static const String privacySection6Body =
      'لأي استفسار عن الخصوصية: support@homekitchen.app (أو البريد المحدد في التطبيق).';

  // الشروط والأحكام — تطبق على العملاء ومقدمي الخدمة (الطباخين)
  static const String termsSection1Title = '١. قبول الشروط';
  static const String termsSection1Body =
      'باستخدام تطبيق مطبخ البيت (سواء كعميل أو كمقدم خدمة/طباخ)، فإنك توافق على هذه الشروط. إن لم توافق، يرجى عدم استخدام التطبيق.';

  static const String termsSection2Title = '٢. تعريف المنصة والخدمات';
  static const String termsSection2Body =
      'مطبخ البيت منصة إلكترونية تربط بين: (أ) العملاء الراغبين في طلب طعام منزلي، و(ب) مقدمي الخدمة (الطباخين المنزليين) الذين ينتجون طبخاً من بيوتهم أو يقدمون خدمات طبخ داخل منازل العملاء. نقدم: وجبات جاهزة من الطباخين، طبخ شعبي (الطباخ يأتي ليطبخ في مكانك)، مناسبات خاصة، وشوي. نحن وسيط فقط — لا ننتج الطعام ولا نتحكم بمحتواه.';

  static const String termsSection3Title = '٣. من يخاطب هذه الشروط';
  static const String termsSection3Body =
      'هذه الشروط تخاطب: (أ) العملاء: من يطلبون وجبات أو خدمات طبخ عبر التطبيق. (ب) مقدمي الخدمة: الطباخون المنزليون المسجلون الذين يقدمون وجبات جاهزة أو خدمات طبخ عند الطلب أو للمناسبات. كلا الطرفين ملزمان بهذه الشروط.';

  static const String termsSection4Title = '٤. مسؤولية المنصة';
  static const String termsSection4Body =
      'مطبخ البيت منصة وسيطة. لا نضمن جودة الطعام أو سلامته — المسؤولية تقع على مقدم الخدمة. نحن نتحقق من تسجيل مقدمي الخدمة ولا نتحكم بطريقة إعداد الطعام. أي نزاع متعلق بالجودة أو السلامة يُحل بين العميل ومقدم الخدمة، ونحن نساعد في التوسط عند الحاجة.';

  static const String termsSection5Title = '٥. مسؤولية مقدم الخدمة (الطباخ)';
  static const String termsSection5Body =
      'مقدم الخدمة مسؤول عن: سلامة وجودة الطعام المُعد، الالتزام بالأنظمة الصحية المحلية، صحة المعلومات المعروضة (الأسعار، المكونات، التوفر)، تنفيذ الطلبات في الوقت المحدد، والتعامل مع الشكاوى. يُفترض أن مقدم الخدمة يملك التصاريح أو التراخيص المطلوبة لمزاولة النشاط إن وجدت.';

  static const String termsSection6Title = '٦. مسؤولية العميل';
  static const String termsSection6Body =
      'العميل مسؤول عن: صحة بياناته وعنوان التوصيل، الدفع في الوقت المحدد، استلام الطلب أو استقبال مقدم الخدمة في المكان والوقت المتفق عليه، وإبلاغنا بأي مشكلة فور حدوثها. الطلبات المؤكدة تُعتبر ملزمة.';

  static const String termsSection7Title = '٧. سلامة الطعام والجودة';
  static const String termsSection7Body =
      'الطعام المُعد من المنازل يخضع لمسؤولية مقدم الخدمة. نوصي العملاء بالتحقق من التقييمات والمراجعات. في حال وجود حساسية أو ظروف صحية، يتحمل العميل مسؤولية إبلاغ مقدم الخدمة. المنصة لا تتحمل مسؤولية أي ضرر ناتج عن استهلاك الطعام.';

  static const String termsSection8Title = '٨. الدفع والرسوم';
  static const String termsSection8Body =
      'الأسعار المعروضة نهائية ما لم يُذكر غير ذلك. قد نخصم رسوماً أو عمولات من مقدمي الخدمة. الدفع يتم عبر الطرق المتاحة في التطبيق. في حال طلبات المناسبات أو الطبخ عند الطلب، قد يُطلب دفعة مقدمة أو اتفاق على السعر قبل التنفيذ.';

  static const String termsSection9Title = '٩. الإلغاء والاسترداد';
  static const String termsSection9Body =
      'تخضع سياسة الإلغاء لطبيعة الخدمة ووقت الإلغاء. للوجبات الجاهزة: يُحدد مع كل طلب. للمناسبات والطبخ عند الطلب: يُتفق عليه مع مقدم الخدمة. الاسترداد يتم وفق سياسة المنصة ومقدم الخدمة. الإلغاء المتكرر دون مبرر قد يؤدي لتعليق الحساب.';

  static const String termsSection10Title = '١٠. حل النزاعات';
  static const String termsSection10Body =
      'في حال نزاع بين عميل ومقدم خدمة، نعمل كوسيط لتسوية الخلاف. القرار النهائي للمنصة في النزاعات المتعلقة بالمنصة. للنزاعات القانونية: تخضع هذه الشروط لقوانين المملكة العربية السعودية، وتكون المحاكم المختصة فيها هي المحاكم السعودية.';

  static const String termsSection11Title = '١١. إنهاء الحساب';
  static const String termsSection11Body =
      'يحق للمنصة تعليق أو إنهاء أي حساب في حال مخالفة هذه الشروط أو السلوك غير المقبول أو الغش. يحق للمستخدم طلب إغلاق حسابه في أي وقت. عند الإغلاق، تبقى البيانات اللازمة للالتزامات القانونية وفق سياسة الخصوصية.';

  static const String termsSection12Title = '١٢. التعديلات';
  static const String termsSection12Body =
      'نحتفظ بحق تعديل هذه الشروط. سنُعلمك بالتغييرات الجوهرية عبر التطبيق أو البريد. استمرارك في استخدام التطبيق بعد التعديل يُعتبر موافقة على الشروط الجديدة.';

  static const String termsSection13Title = '١٣. التواصل';
  static const String termsSection13Body =
      'للاستفسارات والشكاوى: support@homekitchen.app (أو البريد المحدد في التطبيق). نلتزم بالرد خلال فترة معقولة.';
}
