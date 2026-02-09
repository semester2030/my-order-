/// Route names constants for Driver App
class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String phoneInput = '/phone-input';
  static const String otpVerification = '/otp-verification';
  static const String pinSetup = '/pin-setup';
  static const String pinVerification = '/pin-verification';

  // Registration
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String trackApplication = '/track-application';

  // Main Shell
  static const String mainShell = '/main';
  
  // Jobs (nested under /main - path is relative to /main)
  static const String jobs = '/main/jobs';
  
  // Delivery (nested under /main - paths are relative to /main)
  static const String activeDelivery = '/main/delivery/active';
  static const String navigateToRestaurant = '/main/delivery/navigate-restaurant';
  static const String pickup = '/main/delivery/pickup';
  static const String navigateToCustomer = '/main/delivery/navigate-customer';
  static const String delivered = '/main/delivery/delivered';
  
  // Profile (nested under /main - path is relative to /main)
  static const String profile = '/main/profile';
  static const String languageSettings = '/main/profile/language-settings';
  static const String notificationSettings = '/main/profile/notification-settings';
  static const String help = '/main/profile/help';
}
