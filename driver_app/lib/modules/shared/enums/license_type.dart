/// License Type Enum
enum LicenseType {
  private,
  public,
  transport,
}

extension LicenseTypeExtension on LicenseType {
  String get displayName {
    switch (this) {
      case LicenseType.private:
        return 'Private';
      case LicenseType.public:
        return 'Public';
      case LicenseType.transport:
        return 'Transport';
    }
  }
}
