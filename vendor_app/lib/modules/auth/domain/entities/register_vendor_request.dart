import 'package:equatable/equatable.dart';

/// Domain request for vendor registration (no dependency on data DTOs).
class RegisterVendorRequest with EquatableMixin {
  const RegisterVendorRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.providerCategory,
    this.tradeName,
    this.description,
    this.popularCookingAddOns,
  });

  final String name;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? providerCategory;
  final String? tradeName;
  final String? description;
  final String? popularCookingAddOns;

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        phoneNumber,
        providerCategory,
        tradeName,
        description,
        popularCookingAddOns,
      ];
}
