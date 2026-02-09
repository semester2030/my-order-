import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String label;
  final String streetAddress;
  final String? building;
  final String? floor;
  final String? apartment;
  final String city;
  final String? district;
  final String? postalCode;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final bool isActive;

  const Address({
    required this.id,
    required this.label,
    required this.streetAddress,
    this.building,
    this.floor,
    this.apartment,
    required this.city,
    this.district,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        streetAddress,
        building,
        floor,
        apartment,
        city,
        district,
        postalCode,
        latitude,
        longitude,
        isDefault,
        isActive,
      ];
}
