/// Environment variables
class Env {
  Env._();

  static const String appName = 'Driver App';
  static const String appVersion = '1.0.0';
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}
