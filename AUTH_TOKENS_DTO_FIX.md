# ✅ إصلاح auth_tokens_dto.dart - Auth Tokens DTO Fix

## ❌ المشكلة:

```
E Could not generate `fromJson` code for `user`.
  To support the type `InvalidType` you can:
  * Use `JsonConverter`
  * Use `JsonKey` fields `fromJson` and `toJson`
```

**السبب:**
- `UserEntity` هو entity وليس DTO
- `UserEntity` لا يحتوي على `@JsonSerializable`
- `json_serializable` لا يستطيع توليد كود لـ `UserEntity` تلقائياً

---

## ✅ الحل:

### 1. **استخدام `JsonKey` مع `fromJson` و `toJson`:**

تم تحديث `auth_tokens_dto.dart`:

```dart
@JsonSerializable()
class AuthTokensDto {
  final String accessToken;
  final String refreshToken;
  @JsonKey(fromJson: _userFromJson, toJson: _userToJson)
  final UserEntity? user;

  // Helper methods
  static UserEntity? _userFromJson(Map<String, dynamic>? json) {
    return AuthMapper.mapUserFromJson(json);
  }

  static Map<String, dynamic>? _userToJson(UserEntity? user) {
    if (user == null) return null;
    return {
      'id': user.id,
      'phone': user.phone,
      'name': user.name,
      'email': user.email,
      'isVerified': user.isVerified,
      'createdAt': user.createdAt.toIso8601String(),
    };
  }
}
```

### 2. **تحديث json_annotation:**

تم تحديث `json_annotation` من `^4.8.1` إلى `^4.9.0` في `pubspec.yaml`

---

## 🚀 الخطوات:

### 1. **تحديث الحزم:**

```bash
cd customer_app
flutter pub get
```

### 2. **تشغيل build_runner:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

أو:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ✅ النتيجة المتوقعة:

بعد إصلاح `auth_tokens_dto.dart`:
- ✅ `json_serializable` سيكون قادراً على توليد كود لـ `AuthTokensDto`
- ✅ `build_runner` سيعمل بنجاح
- ✅ سيتم إنشاء `auth_tokens_dto.g.dart`

---

## 📊 التغييرات:

### قبل:
```dart
final UserEntity? user;  // ❌ لا يمكن توليد كود JSON تلقائياً
```

### بعد:
```dart
@JsonKey(fromJson: _userFromJson, toJson: _userToJson)
final UserEntity? user;  // ✅ يمكن توليد كود JSON باستخدام helper methods
```

---

## ⚠️ ملاحظات:

1. **لماذا لا نستخدم UserDto؟**
   - `UserEntity` موجود بالفعل ويستخدم في جميع أنحاء التطبيق
   - استخدام `JsonKey` مع helper methods أبسط وأكثر كفاءة

2. **AuthMapper:**
   - `_userFromJson` يستخدم `AuthMapper.mapUserFromJson` الموجود بالفعل
   - `_userToJson` يقوم بتحويل `UserEntity` إلى `Map<String, dynamic>`

---

## ✅ الخلاصة:

**تم إصلاح `auth_tokens_dto.dart` بنجاح!**

**الخطوة التالية:** 
1. تشغيل `flutter pub get`
2. تشغيل `build_runner`

**النتيجة:** ✅ `build_runner` سيعمل بنجاح وستُنشأ جميع ملفات `.g.dart` و `.freezed.dart`!
