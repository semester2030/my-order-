/// Vehicle Type Enum
enum VehicleType {
  motorcycle,
  car,
  van,
  truck,
}

extension VehicleTypeExtension on VehicleType {
  String get displayName {
    switch (this) {
      case VehicleType.motorcycle:
        return 'Motorcycle';
      case VehicleType.car:
        return 'Car';
      case VehicleType.van:
        return 'Van';
      case VehicleType.truck:
        return 'Truck';
    }
  }
}
