/// DTO لطلب حجز طبّاخ (ذبائح / شواء) — متوافق مع استجابة `event_requests` من الباك اند.
class ChefBookingRequestDto {
  const ChefBookingRequestDto({
    required this.id,
    required this.requestType,
    required this.scheduledDate,
    required this.scheduledTime,
    this.mealSlot,
    required this.guestsCount,
    required this.status,
    this.respondBy,
    this.notes,
    this.user,
    this.address,
    this.addOns,
  });

  final String id;
  final String requestType;
  final String scheduledDate;
  final String scheduledTime;
  final String? mealSlot;
  final int guestsCount;
  final String status;
  final String? respondBy;
  final String? notes;
  final ChefBookingUserDto? user;
  final ChefBookingAddressDto? address;
  final List<Map<String, dynamic>>? addOns;

  factory ChefBookingRequestDto.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>>? addOnsList;
    final rawAdd = json['addOns'] ?? json['add_ons'];
    if (rawAdd is List) {
      addOnsList = rawAdd
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return ChefBookingRequestDto(
      id: json['id'] as String? ?? '',
      requestType: json['requestType'] as String? ?? json['request_type'] as String? ?? '',
      scheduledDate:
          json['scheduledDate'] as String? ?? json['scheduled_date'] as String? ?? '',
      scheduledTime:
          json['scheduledTime'] as String? ?? json['scheduled_time'] as String? ?? '',
      mealSlot: json['mealSlot'] as String? ?? json['meal_slot'] as String?,
      guestsCount: json['guestsCount'] as int? ?? json['guests_count'] as int? ?? 1,
      status: json['status'] as String? ?? 'pending',
      respondBy: json['respondBy'] as String? ?? json['respond_by'] as String?,
      notes: json['notes'] as String?,
      user: json['user'] != null
          ? ChefBookingUserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? ChefBookingAddressDto.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      addOns: addOnsList,
    );
  }
}

class ChefBookingUserDto {
  const ChefBookingUserDto({this.name, this.phone});

  final String? name;
  final String? phone;

  factory ChefBookingUserDto.fromJson(Map<String, dynamic> json) {
    return ChefBookingUserDto(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class ChefBookingAddressDto {
  const ChefBookingAddressDto({
    this.streetAddress,
    this.city,
    this.district,
  });

  final String? streetAddress;
  final String? city;
  final String? district;

  factory ChefBookingAddressDto.fromJson(Map<String, dynamic> json) {
    return ChefBookingAddressDto(
      streetAddress: json['streetAddress'] as String? ?? json['street_address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
    );
  }
}
