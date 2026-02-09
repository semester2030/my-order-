/// Build flavor for Vendor App (dev, staging, prod).
enum Flavor {
  dev,
  staging,
  prod,
}

/// Current flavor. Defaults to [Flavor.dev] in debug and [Flavor.prod] in release.
Flavor get currentFlavor {
  const value = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );
  return Flavor.values.firstWhere(
    (f) => f.name == value,
    orElse: () => Flavor.dev,
  );
}
