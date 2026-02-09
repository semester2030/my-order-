# هيكل الثيم الموحد (Unified Theme Structure)

## 📁 الهيكل الكامل للثيم

```
core/theme/
├─ app_theme.dart              # ThemeData الرئيسي (يجمع كل الثيمات)
├─ design_system.dart          # ✨ Facade - يجمع كل exports (import واحد)
│
├─ colors/                     # نظام الألوان الموحد
│  ├─ app_colors.dart          # الألوان الأساسية (Primary, Secondary, Background, Surface)
│  ├─ semantic_colors.dart     # ألوان دلالية (Success, Error, Warning, Info)
│  └─ gradient_colors.dart     # ألوان التدرجات (Gradients)
│
├─ typography/                 # نظام الخطوط الموحد
│  ├─ text_styles.dart         # أنماط النصوص (Headline, Body, Caption, etc.)
│  ├─ font_families.dart       # عائلات الخطوط (Primary, Secondary)
│  └─ font_sizes.dart          # أحجام الخطوط (H1-H6, Body, Small, etc.)
│
├─ icons/                      # نظام الأيقونات الموحد
│  ├─ app_icons.dart           # أيقونات التطبيق الموحدة (تعريفات + مسارات)
│  └─ icon_sizes.dart          # أحجام الأيقونات (Small, Medium, Large, XLarge)
│
├─ animations/                 # نظام الأنيميشن الموحد
│  ├─ durations.dart           # مدة الأنيميشن (Fast, Normal, Slow, VerySlow)
│  ├─ curves.dart              # منحنيات الأنيميشن (EaseIn, EaseOut, EaseInOut, etc.)
│  └─ transitions.dart         # انتقالات الصفحات (Slide, Fade, Scale)
│
├─ shapes/                     # نظام الأشكال والحدود الموحد
│  ├─ borders.dart             # أنماط الحدود (None, Thin, Medium, Thick)
│  ├─ radius.dart              # أنصاف الأقطار (Small, Medium, Large, XLarge, Circular)
│  └─ card_shapes.dart         # أشكال البطاقات (Rounded, Square, Custom)
│
├─ spacing/                    # نظام المسافات الموحد
│  ├─ insets.dart              # ✨ EdgeInsets موحد (padding + margin - Single Source)
│  └─ gaps.dart                # الفجوات بين العناصر (SizedBox - XS, S, M, L, XL)
│
├─ shadows/                    # نظام الظلال الموحد
│  └─ app_shadows.dart         # الظلال (None, Small, Medium, Large, XLarge)
│
└─ components/                  # ثيمات المكونات المخصصة
   ├─ button_theme.dart        # ثيم الأزرار (Primary, Secondary, Outlined, Text)
   ├─ input_theme.dart         # ثيم حقول الإدخال (TextField, Dropdown, etc.)
   ├─ card_theme.dart          # ثيم البطاقات (Elevated, Outlined, Filled)
   ├─ bottom_sheet_theme.dart  # ثيم Bottom Sheets
   └─ video_overlay_theme.dart # ✨ ثيم Video Overlay (Feed - Gradient, Text, Buttons)

core/widgets/
└─ app_icon.dart               # ✨ Widget موحد لعرض الأيقونات (SvgPicture/Icon)
```

---

## 📦 الأصول (Assets) المرتبطة بالثيم

```
assets/
├─ fonts/
│  └─ Montserrat/              # خط Montserrat
│     ├─ Montserrat-Regular.ttf
│     ├─ Montserrat-Medium.ttf
│     ├─ Montserrat-SemiBold.ttf
│     └─ Montserrat-Bold.ttf
│
├─ icons/
│  ├─ app_icons/              # أيقونات مخصصة للتطبيق
│  │  ├─ cart_icon.svg
│  │  ├─ heart_icon.svg
│  │  └─ (أيقونات أخرى)
│  └─ custom_icons/           # أيقونات إضافية
│
└─ lottie/
   ├─ loading.json            # أنيميشن التحميل
   ├─ success.json            # أنيميشن النجاح
   ├─ error.json              # أنيميشن الخطأ
   └─ (أنيميشن إضافية)
```

---

## 🎨 مكونات الثيم الموحد

### 1. الألوان (Colors)
- **app_colors.dart**: الألوان الأساسية للتطبيق
- **semantic_colors.dart**: ألوان دلالية (نجاح، خطأ، تحذير)
- **gradient_colors.dart**: تدرجات لونية

### 2. الخطوط (Typography)
- **text_styles.dart**: أنماط النصوص (Headline1-6, Body1-2, Caption, etc.)
- **font_families.dart**: عائلات الخطوط
- **font_sizes.dart**: أحجام الخطوط

### 3. الأيقونات (Icons)
- **app_icons.dart**: تعريفات الأيقونات الموحدة
- **icon_sizes.dart**: أحجام موحدة للأيقونات

### 4. الأنيميشن (Animations)
- **durations.dart**: مدة الأنيميشن (Fast: 150ms, Normal: 300ms, Slow: 500ms)
- **curves.dart**: منحنيات الأنيميشن (EaseIn, EaseOut, EaseInOut)
- **transitions.dart**: انتقالات الصفحات

### 5. الأشكال (Shapes)
- **borders.dart**: أنماط الحدود
- **radius.dart**: أنصاف الأقطار (Small: 4px, Medium: 8px, Large: 16px)
- **card_shapes.dart**: أشكال البطاقات

### 6. المسافات (Spacing)
- **padding.dart**: المسافات الداخلية
- **margin.dart**: المسافات الخارجية
- **gaps.dart**: الفجوات بين العناصر

### 7. الظلال (Shadows)
- **app_shadows.dart**: ظلال موحدة (Small, Medium, Large)

### 8. مكونات مخصصة (Components)
- **button_theme.dart**: ثيم الأزرار
- **input_theme.dart**: ثيم حقول الإدخال
- **card_theme.dart**: ثيم البطاقات
- **bottom_sheet_theme.dart**: ثيم Bottom Sheets

---

## 🔗 الربط مع MaterialApp

```dart
// app.dart
MaterialApp.router(
  theme: AppTheme.lightTheme,   // من app_theme.dart
  darkTheme: AppTheme.darkTheme, // إن رغبت
  // ...
)
```

---

## ✅ الفوائد

1. **اتساق التصميم**: كل العناصر تستخدم نفس الثيم
2. **سهولة الصيانة**: تعديل واحد يؤثر على كل التطبيق
3. **قابلية التوسع**: إضافة ثيمات جديدة سهل
4. **الأداء**: استخدام ثابت للألوان والخطوط
5. **التجربة**: تجربة مستخدم موحدة في كل التطبيق

---

## 📝 ملاحظات

- كل ملف في `theme/` يحتوي على تعريفات موحدة
- `app_theme.dart` يجمع كل الثيمات في `ThemeData` واحد
- الأصول (fonts, icons, lottie) في `assets/`
- الثيمات المكونات في `components/` لتخصيص مكونات Material

---

## ✨ التعديلات الجديدة (10/10)

### 1. design_system.dart (Facade Pattern)
**السبب:** تقليل friction - import واحد بدل 6-7 imports

**الاستخدام:**
```dart
// بدل:
import 'package:customer_app/core/theme/colors/app_colors.dart';
import 'package:customer_app/core/theme/spacing/insets.dart';
// ... 5 imports أخرى

// الآن:
import 'package:customer_app/core/theme/design_system.dart';
// كل شيء متاح!
```

### 2. insets.dart (توحيد Padding/Margin)
**السبب:** Single Source of Truth - Padding و Margin كلاهما EdgeInsets

**الاستخدام:**
```dart
// padding و margin من نفس المصدر
Container(
  padding: AppInsets.md,    // EdgeInsets
  margin: AppInsets.sm,      // EdgeInsets
)
```

### 3. app_icon.dart (Widget موحد للأيقونات)
**السبب:** توحيد عرض الأيقونات - التحكم المركزي

**الاستخدام:**
```dart
// بدل:
SvgPicture.asset('assets/icons/cart_icon.svg', width: 24, height: 24)

// الآن:
AppIcon.cart(size: AppIconSize.medium)
```

### 4. video_overlay_theme.dart (ثيم Feed Overlay)
**السبب:** Feed هو Core Feature - يحتاج ثيم موحد للفخامة

**يحتوي على:**
- Gradient overlay styles
- Text shadow/contrast
- Button styles (Add to cart)
- ETA display styles
