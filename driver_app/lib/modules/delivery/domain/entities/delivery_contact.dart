/// Delivery Contact Entity
/// 
/// Represents contact information for vendor or customer
class DeliveryContact {
  final String id;
  final String? name;
  final String phone;
  final String? address;

  DeliveryContact({
    required this.id,
    this.name,
    required this.phone,
    this.address,
  });
}
