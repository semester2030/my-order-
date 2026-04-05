/// النصوص العربية — Phase 16.
class StringsAr {
  StringsAr._();

  static const String appTitle = 'شيف مطبخ البيت';
  static const String splashTagline = 'تطبيق الطباخ ومقدم الخدمة';
  static const String dashboard = 'لوحة التحكم';
  static const String orders = 'الطلبات';
  static const String menu = 'الوجبات';
  static const String services = 'الخدمات';
  static const String staff = 'الموظفون';
  static const String settings = 'الإعدادات';
  static const String sideOrders = 'الطلبات الجانبية';
  static const String analytics = 'التحليلات';
  static const String videos = 'مقاطع الفيديو';
  static const String videosCountOfMax = 'من ٢٠'; // "٩ من ٢٠" = 9 of 20
  static const String videosMaxReached = 'الحد الأقصى ٢٠ مقطع. احذف مقطعاً لإضافة جديد.';
  static const String videosDeleteConfirm = 'حذف هذا المقطع؟';
  static const String videosDeleted = 'تم حذف المقطع';
  static const String videoMealLabel = 'الوجبة';
  static const String delete = 'حذف';

  static const String login = 'تسجيل الدخول';
  static const String register = 'التسجيل';
  static const String loginChecking = 'جاري التحقق...';
  static const String haveAccountLogin = 'لديك حساب؟ تسجيل الدخول';
  static const String backToLogin = 'العودة لتسجيل الدخول';
  static const String welcomeBack = 'مرحباً بعودتك';
  static const String enterEmailPassword = 'أدخل البريد وكلمة المرور';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String passwordLabel = 'كلمة المرور';
  static const String createAccount = 'إنشاء حساب جديد';
  /// بعد تسجيل مقدّم خدمة ناجح — حوار يوضّح الخطوات التالية (بريد، موافقة، رفض).
  static const String registerSuccessTitle = 'تم التسجيل بنجاح';
  static const String registerSuccessBody =
      'شكراً لتسجيلك في مطبخ البيت.\n\n'
      '• راجع بريدك الإلكتروني: قد تصلك رسالة تأكيد عند تفعيل الإرسال على الخادم (تحقّق أيضاً من «الرسائل غير المرغوبة»).\n\n'
      '• حالة طلبك الآن: بانتظار موافقة الإدارة، وقد يستغرق ذلك وقتاً.\n\n'
      'بعد الموافقة:\n'
      'سجّل الدخول بنفس البريد وكلمة المرور لإكمال بياناتك والبدء بالعمل.\n\n'
      'في حال الرفض:\n'
      'عند تسجيل الدخول ستظهر لك شاشة توضّح سبب الرفض عندما يحدده فريق الإدارة.\n\n'
      'يمكنك الآن الانتقال إلى تسجيل الدخول؛ أثناء الانتظار قد ترى شاشة «قيد المراجعة».';
  static const String registerSuccessGoLogin = 'الانتقال لتسجيل الدخول';
  static const String errorInvalidCredentials = 'البريد أو كلمة المرور غير صحيحة';
  static const String errorNetwork = 'تحقق من الاتصال بالإنترنت وحاول مرة أخرى';
  static const String errorServer = 'حدث خطأ في الخادم، حاول لاحقاً';
  static const String errorValidation = 'البيانات المدخلة غير صالحة';
  static const String errorGeneric = 'حدث خطأ، حاول مرة أخرى';

  static const String editProfile = 'تعديل البروفايل';
  static const String changePassword = 'تغيير كلمة المرور';
  static const String logout = 'تسجيل الخروج';
  static const String language = 'اللغة';
  static const String languageAr = 'العربية';
  static const String languageEn = 'English';

  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String readPrivacy = 'قراءة سياسة الخصوصية على الموقع';
  static const String termsConditions = 'الشروط والأحكام';
  static const String readTerms = 'قراءة الشروط على الموقع';
  static const String deleteAccount = 'حذف الحساب';
  static const String deleteAccountSubtitle =
      'حذف نهائي أو إخفاء بياناتك وفق سياسة الخصوصية';
  static const String deleteAccountTitle = 'حذف الحساب';
  static const String deleteAccountWarning =
      'لا يمكن التراجع. إن وُجدت طلبات أو بيانات تشغيل قد نُبقي السجلات دون بيانات تعريفية. أدخل كلمة المرور للتأكيد.';
  static const String deleteAccountPasswordLabel = 'كلمة المرور';
  static const String deleteAccountSubmit = 'تأكيد حذف الحساب';
  static const String deleteAccountSuccess =
      'تمت معالجة طلبك. يمكنك تسجيل الدخول لاحقاً بحساب جديد إن رغبت.';
  static const String passwordMinHint = '6 أحرف على الأقل';
  static const String couldNotOpenLink = 'تعذّر فتح الرابط';
  static const String loading = 'جاري التحميل...';

  static const String ordersSummary = 'ملخص الطلبات';
  static const String menuItemsCount = 'عدد الوجبات';
  static const String analyticsSummary = 'ملخص الطلبات والإيرادات';
  static const String pendingOrders = 'طلبات قيد الانتظار';
  static const String completedOrders = 'طلبات مكتملة';
  static const String totalRevenue = 'إجمالي الإيرادات';

  static const String addMeal = 'إضافة وجبة';
  static const String editMeal = 'تعديل الوجبة';
  static const String mealName = 'اسم الوجبة';
  static const String description = 'الوصف';
  static const String priceSar = 'السعر (ر.س)';
  static const String priceSarOptional = 'السعر (ر.س) — اختياري';
  static const String priceRequired = 'السعر مطلوب';
  static const String enterValidPrice = 'أدخل سعراً صالحاً';
  static const String addImage = 'إضافة صورة';
  static const String imageSelected = 'تم اختيار صورة';
  static const String save = 'حفظ';
  static const String saving = 'جاري الحفظ...';
  static const String cancel = 'إلغاء';
  static const String noMeals = 'لا توجد وجبات';
  static const String mealNotFound = 'الوجبة غير موجودة';
  static const String available = 'متوفر';
  static const String unavailable = 'غير متوفر';

  static const String addService = 'إضافة خدمة';
  static const String editService = 'تعديل الخدمة';
  static const String serviceName = 'اسم الخدمة';
  static const String myServices = 'ما أقدمه للزبائن';
  static const String noServices = 'لا توجد خدمات';
  static const String serviceNotFound = 'الخدمة غير موجودة';
  static const String active = 'نشط';
  static const String inactive = 'غير نشط';

  static const String addStaff = 'إضافة موظف';
  static const String editStaff = 'تعديل الموظف';
  static const String staffName = 'اسم الموظف';
  static const String roleOptional = 'الدور — اختياري';
  static const String emailOptional = 'البريد — اختياري';
  static const String phoneOptional = 'الجوال — اختياري';
  static const String noStaff = 'لا يوجد موظفون';
  static const String staffNotFound = 'الموظف غير موجود';

  static const String sideOrdersTitle = 'الطلبات الجانبية';
  static const String noSideOrderAddOns = 'لا توجد إضافات للطلبات الجانبية';
  static const String addSideOrderItem = 'إضافة صنف';
  static const String editSideOrderItem = 'تعديل الصنف';
  static const String itemName = 'اسم الصنف';
  static const String enterPrice = 'أدخل السعر';

  static const String chooseImageOrVideo = 'اختر صورة أو فيديو';
  static const String imageFromGallery = 'صورة من المعرض';
  static const String imageFromCamera = 'صورة من الكاميرا';
  static const String videoFromGallery = 'فيديو من المعرض';
  static const String recordVideo = 'تسجيل فيديو';

  static const String orderDetails = 'تفاصيل الطلب';
  static const String orderAccepted = 'تم قبول الطلب';
  static const String orderRejected = 'تم رفض الطلب';
  static const String noData = 'لا توجد بيانات';
  static const String noOrders = 'لا توجد طلبات';
  static const String uploadingImage = 'جاري رفع الصورة...';
  static const String uploadingVideo = 'جاري رفع الفيديو...';
  static const String retry = 'إعادة المحاولة';

  // المناسبات الخاصة
  static const String eventOffers = 'عروض المناسبات';
  static const String eventRequests = 'طلبات المناسبات';
  static const String eventOfferBuffet = 'بوفيه';
  static const String eventOfferDesserts = 'حلويات';
  static const String eventOfferDrinks = 'مشروبات';
  static const String eventOfferStaff = 'طاقم';
  static const String eventTypeWedding = 'حفل زواج';
  static const String eventTypeGraduation = 'حفل تخرج';
  static const String eventTypeHenna = 'حفل ملكة';
  static const String eventTypeEngagement = 'خطوبة';
  static const String eventTypeOther = 'أخرى';
  static const String addEventOffer = 'إضافة عرض';
  static const String editEventOffer = 'تعديل العرض';
  static const String noEventOffers = 'لا توجد عروض';
  static const String noEventRequests = 'لا توجد طلبات';
  static const String accept = 'قبول';
  static const String reject = 'رفض';
  static const String eventStatusPending = 'قيد الانتظار';
  static const String eventType = 'نوع المناسبة';
  static const String serviceType = 'نوع الخدمة';
  static const String titleOptional = 'العنوان — اختياري';
  static const String minGuests = 'الحد الأدنى للضيوف';
  static const String maxGuests = 'الحد الأقصى للضيوف';
  static const String pricePerPersonOptional = 'السعر للفرد (ر.س) — اختياري';
  static const String priceTotalOptional = 'السعر الإجمالي (ر.س) — اختياري';
  static String guestsCount(int n) => '$n ضيوف';

  /// شروط عرض الوجبات العامة (قبل أول إضافة وجبة)
  static const String menuOfferingTermsTitle = 'الشروط العامة لعرض الوجبات';
  static const String menuOfferingTermsSubtitle =
      'تنطبق على جميع فئات مقدّمي الخدمة. يمكن إكمال النصوص التفصيلية لاحقاً دون تغيير آلية الموافقة.';
  static const String menuOfferingTermsNotice =
      'ما يلي إطار عام مؤقت يعبّر عن الالتزامات الشائعة؛ يُستبدل أو يُوسَّع بنصوص قانونية كاملة عند الحاجة.';
  static const String menuOfferingTermsBullet1 =
      'الالتزام بدقة وصف الوجبات والأسعار وعدم التضليل.';
  static const String menuOfferingTermsBullet2 =
      'عدم نشر محتوى أو وسائط مخالفة للنظام أو الآداب العامة.';
  static const String menuOfferingTermsBullet3 =
      'الالتزام بسياسات المنصّة في التعامل مع العملاء والطلبات.';
  static const String menuOfferingTermsBullet4 =
      'تحديث البيانات المعروضة عند تغيّر المنتج أو السعر أو التوفر.';
  static const String menuOfferingTermsBullet5 =
      'المسؤولية عن صحة المعلومات المعروضة تقع على مقدّم الخدمة.';
  static const String menuOfferingTermsReadCheckbox =
      'قرأت الشروط أعلاه وأوافق على الالتزام بها.';
  static const String menuOfferingTermsAgreeButton = 'موافقة ومتابعة';
  static const String menuOfferingTermsVersionLabel = 'إصدار الشروط';
  static const String menuOfferingTermsLoading = 'جاري التحميل...';
  static const String menuOfferingTermsSubmitting = 'جاري الحفظ...';

  /// شاشة موحّدة: لوائح المنصّة + شروط عرض الوجبات + مكان لشروط الفئة (لاحقاً)
  static const String vendorCombinedTermsTitle = 'الشروط والالتزامات';
  static const String vendorPlatformTermsSectionTitle = 'اللوائح والالتزامات العامة (المنصّة)';
  static const String vendorPlatformTermsIntro =
      'بالموافقة أنت تقرّ بما يلي في علاقتك مع منصّة مطبخ البيت كمقدّم خدمة. تُحدَّث هذه الفقرات عند الحاجة من الإدارة أو فريق المنتج.';
  static const String vendorPlatformTermsFeesTitle = 'رسوم الخدمة والعمولة';
  static const String vendorPlatformTermsFeesBody =
      'قد تطبّق المنصّة رسوماً أو عمولة على الطلبات أو الخدمات المعروضة. تُحدَّد النسب وآلية الاستقطاع والدفع في إشعارات أو لوحة التحكم حسب سياسة الإدارة. يتحمّل مقدّم الخدمة مسؤولية الاطلاع على أي تحديث.';
  static const String vendorPlatformTermsPayoutTitle = 'المستحقات والتسوية';
  static const String vendorPlatformTermsPayoutBody =
      'تُصرف مستحقات مقدّم الخدمة وفق سياسة الدفع المعتمدة (مثلاً بشكل دوري أو بعد تأكيد التسليم)، مع خصم أي رسوم أو عمولات مستحقة للمنصّة.';
  static const String vendorPlatformTermsComplianceTitle = 'صحة البيانات والالتزام بالأنظمة';
  static const String vendorPlatformTermsComplianceBody =
      'يُقدّم مقدّم الخدمة معلومات صحيحة عن الوجبات والأسعار والتوفر، ويلتزم بالأنظمة المعمول بها في المملكة العربية السعودية.';
  static const String vendorCombinedTermsMenuSectionTitle = 'الشروط العامة لعرض الوجبات';
  static const String vendorCategoryTermsSectionTitle = 'شروط إضافية حسب نوع الخدمة';
  static const String vendorCategoryTermsPlaceholder =
      'هذا القسم مخصّص لشروط تختلف بحسب فئة مقدّم الخدمة (مطبخ منزلي، شوي، مناسبات، …). النصوص غير جاهزة بعد — سيُكمل الفريق لاحقاً دون تغيير شاشة الموافقة.';
  static const String vendorLegalAlreadyAccepted = 'تم قبول لوائح المنصّة مسبقاً لهذا الإصدار.';
  static const String vendorMenuTermsAlreadyAccepted = 'تم قبول شروط عرض الوجبات مسبقاً لهذا الإصدار.';
  static const String vendorCombinedTermsReadCheckbox =
      'قرأت اللوائح العامة للمنصّة والشروط العامة لعرض الوجبات والقسم الخاص بفئة الخدمة (عند توفره) وأوافق على الالتزام بها.';
  static const String vendorCombinedTermsLegalVersionLabel = 'إصدار لوائح المنصّة';
}
