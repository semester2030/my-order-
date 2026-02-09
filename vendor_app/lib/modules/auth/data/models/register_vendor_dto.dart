/// Request DTO for POST /vendors/register.
/// Aligned with backend RegisterVendorDto: required name, email, password; optional fields.
class RegisterVendorDto {
  const RegisterVendorDto({
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
  /// home_cooking | popular_cooking | private_events | grilling
  final String? providerCategory;
  final String? tradeName;
  final String? description;
  /// JSON string for popular cooking add-ons: e.g. [{"name":"جريش","price":50}]
  final String? popularCookingAddOns;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (providerCategory != null) map['providerCategory'] = providerCategory;
    if (tradeName != null) map['tradeName'] = tradeName;
    if (description != null) map['description'] = description;
    if (popularCookingAddOns != null) map['popularCookingAddOns'] = popularCookingAddOns;
    return map;
  }
}
