/// App flavors (dev, staging, prod)
enum AppFlavor {
  development,
  staging,
  production,
}

/// Flavor configuration
class FlavorConfig {
  FlavorConfig._();

  static AppFlavor get current => AppFlavor.development;
  
  static String get apiBaseUrl {
    switch (current) {
      case AppFlavor.development:
        return 'http://localhost:3001/api';
      case AppFlavor.staging:
        return 'https://staging-api.example.com/api';
      case AppFlavor.production:
        return 'https://api.example.com/api';
    }
  }
}
