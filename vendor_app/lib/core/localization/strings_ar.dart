/// النصوص العربية — Phase 16.
class StringsAr {
  StringsAr._();

  static const String appTitle = 'شيف مطبخ البيت';
  static const String splashTagline = 'تطبيق الطباخ ومقدم الخدمة';
  static const String dashboard = 'لوحة التحكم';
  static const String orders = 'الطلبات';
  static const String menu = 'إعلان الفيديو';
  static const String services = 'الأطباق المتاحة';
  static const String staff = 'الموظفون';
  static const String settings = 'الإعدادات';
  static const String sideOrders = 'الطلبات الجانبية';
  static const String analytics = 'التحليلات';
  static const String videos = 'مقاطع الفيديو';
  static const String videosCountOfMax = 'من ٢٠'; // "٩ من ٢٠" = 9 of 20
  static const String videosMaxReached = 'الحد الأقصى ٢٠ مقطع. احذف مقطعاً لإضافة جديد.';
  static const String videosDeleteConfirm = 'حذف هذا المقطع؟';
  static const String videosDeleted = 'تم حذف المقطع';
  static const String videoMealLabel = 'عنصر القائمة المرتبط';
  static const String delete = 'حذف';
  static const String copy = 'نسخ';

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
  static const String registerSubtitleWithLocation =
      'مطلوب: الاسم والبريد وكلمة المرور، وموقع تنفيذ الخدمة (عنوان ومدينة + تحديد الموقع على الخريطة).';
  static const String registerServiceLocationTitle = 'موقع مقدم الخدمة';
  static const String registerStreetAddressLabel = 'عنوان الموقع';
  static const String registerStreetAddressHint = 'مثال: شارع، حي، رقم المبنى';
  static const String registerCityLabel = 'المدينة';
  static const String registerCityHint = 'مثال: الرياض';
  static const String registerLatitudeLabel = 'خط العرض (Latitude)';
  static const String registerLongitudeLabel = 'خط الطول (Longitude)';
  static const String registerCoordinatesHint =
      'يفضّل الضغط على الزر أدناه لتحديد موقعك تلقائياً — أسرع وأدق.';
  static const String registerManualCoordinates = 'إدخال خط العرض والطول يدوياً';
  static const String registerHideManualCoordinates = 'إخفاء الإحداثيات اليدوية';
  static const String registerNeedLocationOrManual =
      'حدّد موقعك: استخدم «موقعي الحالي» أو افتح «إدخال يدوي» وأكمل الإحداثيات.';
  static const String registerMapsPasteHint =
      'للإدخال اليدوي: من Google Maps اضغط على موقعك ثم انسخ خط العرض وخط الطول.';
  static const String registerCoordinatesZero =
      'الإحداثيات لا يمكن أن تكون صفراً — حدد موقعك الحقيقي على الخريطة.';
  static const String registerUseMyLocation = 'استخدام موقعي الحالي';
  static const String registerFetchingLocation = 'جاري تحديد الموقع...';
  static const String registerLocationServiceDisabled =
      'فعِّل خدمة الموقع (GPS) من إعدادات الجهاز.';
  static const String registerLocationPermissionDenied =
      'اسمح بالوصول للموقع لتعبئة العنوان والإحداثيات تلقائياً.';
  static const String registerLocationPermissionForever =
      'تم رفض الموقع من الإعدادات — فعِّل الإذن لتطبيق «شيف مطبخ البيت» ثم أعد المحاولة.';
  static const String registerLocationPositionUnavailable =
      'تعذر الحصول على الموقع. جرّب مرة أخرى أو أدخل الإحداثيات يدوياً من الخرائط.';
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
  static const String verifyEmail = 'التحقق من البريد';
  static const String verifyEmailDescription =
      'بعد موافقة الإدارة، يجب تأكيد بريدك برمز يُرسل إلى نفس البريد المسجّل حتى تستطيع إضافة وجبات أو رفع فيديو.';
  static const String verifyEmailSendOtp = 'إرسال رمز التحقق';
  static const String verifyEmailOtpLabel = 'رمز التحقق';
  static const String verifyEmailConfirm = 'تأكيد البريد';
  static const String verifyEmailSuccess = 'تم التحقق من البريد بنجاح';
  static const String verifyEmailAlreadyDone = 'البريد مُحقق مسبقاً.';
  static const String verifyEmailDevCodeTitle = 'رمز من الخادم (وضع اختبار)';
  static const String verifyEmailDevCodeHint =
      'يظهر هذا عندما يعيد الخادم الرمز في الاستجابة (قائمة OTP_FORCE_WHITELIST أو بيئة تطوير). انسخه وأدخله أعلاه.';
  static const String logout = 'تسجيل الخروج';
  static const String language = 'اللغة';
  static const String languageAr = 'العربية';
  static const String languageEn = 'English';

  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String readPrivacy = 'قراءة سياسة الخصوصية داخل التطبيق';
  static const String termsConditions = 'الشروط والأحكام';
  static const String readTerms = 'قراءة الشروط والأحكام داخل التطبيق';
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

  // === Legal (نفس نصوص تطبيق العميل — العملاء ومقدمو الخدمة) ===
  static const String legalLastUpdated = 'آخر تحديث: يناير 2026';

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

  static const String termsSection1Title = '١. قبول الشروط';
  static const String termsSection1Body =
      'باستخدام تطبيق مطبخ البيت (سواء كعميل أو كمقدم خدمة/طباخ)، فإنك توافق على هذه الشروط. إن لم توافق، يرجى عدم استخدام التطبيق.';
  static const String termsSection2Title = '٢. تعريف المنصة والخدمات';
  static const String termsSection2Body =
      'مطبخ البيت منصة إلكترونية تربط بين: (أ) العملاء الراغبين في طلب طعام منزلي، و(ب) مقدمي الخدمة (الطباخين المنزليين) الذين ينتجون طبخاً من بيوتهم أو يقدمون خدمات طبخ داخل منازل العملاء. نقدم: وجبات جاهزة من الطباخين، طبخ الذبائح (الطباخ يأتي ليقوم بطبخ الذبائح في مكانك)، المناسبات والحفلات، والشواء الخارجي. نحن وسيط فقط — لا ننتج الطعام ولا نتحكم بمحتواه.';
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

  static const String ordersSummary = 'ملخص الطلبات';
  static const String menuItemsCount = 'عدد الوجبات';
  static const String analyticsSummary = 'ملخص الطلبات والإيرادات';
  static const String pendingOrders = 'طلبات قيد الانتظار';
  static const String completedOrders = 'طلبات مكتملة';
  static const String totalRevenue = 'إجمالي الإيرادات';

  static const String addMeal = 'إضافة وجبة';
  /// إعلان تعريفي للمطبخ المنزلي (وليس صنفاً للسلة).
  static const String addKitchenPromo = 'إضافة إعلان تعريفي للمطبخ';
  static const String kitchenPromoHeadlineLabel = 'عنوان الإعلان';
  static const String kitchenPromoDescriptionChipsTitle = 'عبارات جاهزة — اضغط للاختيار أو اكتب ما تريدين';
  static const String kitchenPromoImageOptionalHint = 'صورة الغلاف اختيارية؛ يمكن الاكتفاء بالفيديو والوصف.';
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
  static const String emptyPromoMenuTab = 'لا توجد عناصر للإعلان بعد';
  static const String noVideosYet = 'لا توجد مقاطع فيديو بعد';
  static const String mealNotFound = 'الوجبة غير موجودة';
  static const String available = 'متوفر';
  static const String unavailable = 'غير متوفر';

  static const String addService = 'إضافة طبق متاح';
  static const String addMealForMenu = 'إضافة وجبة';
  static const String editService = 'تعديل طبق متاح';
  static const String serviceName = 'اسم الطبق';
  static const String myServices = 'الأطباق المتاحة';
  static const String noServices = 'لا توجد أطباق متاحة بعد';
  static const String serviceNotFound = 'الطبق غير موجود';
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
  // حجوزات الولائم والشوي (مسار منفصل عن المناسبات الخاصة)
  static const String chefBookingRequests = 'حجوزات الولائم والشوي';
  static const String noChefBookingRequests = 'لا توجد حجوزات';
  static const String homeCookingRequests = 'طلبات الطبخ المنزلي';
  static const String noHomeCookingRequests = 'لا توجد طلبات طبخ منزلي';
  static const String homeCookingStatusQuoted = 'تم عرض السعر — انتظار العميل';
  static const String homeCookingStatusPaymentPending = 'أعلن العميل عن التحويل — بانتظار التحقق';
  static const String homeCookingStatusAccepted = 'مؤكد الدفع — قيد التحضير';
  static const String homeCookingStatusReady = 'جاهز للاستلام';
  static const String homeCookingQuoteDialogTitle = 'عرض السعر (ر.س)';
  static const String homeCookingQuoteAmountHint = 'المبلغ الإجمالي';
  static const String homeCookingQuoteNotesHint = 'ملاحظات للعميل (اختياري)';
  static const String homeCookingSendQuote = 'إرسال السعر';
  static const String homeCookingRejectRequest = 'رفض الطلب';
  static const String homeCookingMarkReady = 'تعيين كجاهز للاستلام';
  static const String homeCookingInvalidAmount = 'أدخل مبلغاً صالحاً';
  static const String homeCookingDeliveryYes = 'توصيل';
  static const String homeCookingDeliveryNo = 'استلام من المطبخ';
  static const String homeCookingQuotedAmount = 'المبلغ المعروض';
  static const String homeCookingStatusReadyShort = 'جاهز — أكّد التسليم للعميل أو للمندوب';
  static const String homeCookingStatusHandedOver = 'تم التسليم — بانتظار تأكيد استلام العميل';
  static const String homeCookingStatusCompleted = 'مكتمل — رمز إتمام عند العميل والإدارة';
  static const String homeCookingMarkHandedOverButton = 'تأكيد التسليم';
  static const String homeCookingHandoverDialogTitle = 'تأكيد تسليم الطلب';
  static const String homeCookingHandoverDialogSubtitle =
      'سواء استلمه العميل بنفسه أو مندوب أو وسيط — بعد التأكيد يرى العميل خيار «تم الاستلام».';
  static const String homeCookingHandoverNotesHint = 'ملاحظة اختيارية (مثال: اسم المندوب، شركة الشحن)';
  static const String homeCookingHandoverConfirm = 'تأكيد التسليم';
  static const String homeCookingHandedOverSuccess = 'تم تسجيل التسليم';
  static const String homeCookingCompletionRefLabel = 'رمز إتمام الطلب (بعد تأكيد العميل)';
  static const String chefBookingTypePopularCooking = 'طبخ ذبائح';
  static const String chefBookingTypeGrilling = 'شواء خارجي';
  static const String chefBookingStatusAccepted = 'مقبول';
  static const String chefBookingStatusRejected = 'مرفوض';
  static const String chefBookingStatusCancelled = 'ملغى';
  static String chefBookingRespondByLine(String formatted) =>
      'آخر موعد للرد: $formatted';
  static const String chefMealSlotLunch = 'غداء';
  static const String chefMealSlotDinner = 'عشاء';
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
      'هذا القسم مخصّص لشروط تختلف بحسب فئة مقدّم الخدمة (مطبخ منزلي، الشواء الخارجي، المناسبات والحفلات، …). النصوص غير جاهزة بعد — سيُكمل الفريق لاحقاً دون تغيير شاشة الموافقة.';
  static const String vendorLegalAlreadyAccepted = 'تم قبول لوائح المنصّة مسبقاً لهذا الإصدار.';
  static const String vendorMenuTermsAlreadyAccepted = 'تم قبول شروط عرض الوجبات مسبقاً لهذا الإصدار.';
  static const String vendorCombinedTermsReadCheckbox =
      'قرأت اللوائح العامة للمنصّة والشروط العامة لعرض الوجبات والقسم الخاص بفئة الخدمة (عند توفره) وأوافق على الالتزام بها.';
  static const String vendorCombinedTermsLegalVersionLabel = 'إصدار لوائح المنصّة';
}
