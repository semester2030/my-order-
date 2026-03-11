/// DTO لطلب المناسبة — متوافق مع API الباك اند.
class PrivateEventRequestDto {
  const PrivateEventRequestDto({
    required this.id,
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    required this.guestsCount,
    required this.services,
    this.notes,
    this.status = 'pending',
    this.user,
    this.address,
    this.createdAt,
  });

  final String id;
  final String eventType;
  final String eventDate;
  final String eventTime;
  final int guestsCount;
  final List<PrivateEventRequestServiceDto> services;
  final String? notes;
  final String status; // pending, accepted, rejected, cancelled
  final PrivateEventRequestUserDto? user;
  final PrivateEventRequestAddressDto? address;
  final String? createdAt;

  factory PrivateEventRequestDto.fromJson(Map<String, dynamic> json) {
    List<PrivateEventRequestServiceDto> servicesList = [];
    final svc = json['services'];
    if (svc is List) {
      for (final s in svc) {
        if (s is Map<String, dynamic>) {
          servicesList.add(PrivateEventRequestServiceDto.fromJson(s));
        }
      }
    }

    return PrivateEventRequestDto(
      id: json['id'] as String? ?? '',
      eventType: json['eventType'] as String? ?? json['event_type'] as String? ?? '',
      eventDate: json['eventDate'] as String? ?? json['event_date'] as String? ?? '',
      eventTime: json['eventTime'] as String? ?? json['event_time'] as String? ?? '',
      guestsCount: json['guestsCount'] as int? ?? json['guests_count'] as int? ?? 1,
      services: servicesList,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
      user: json['user'] != null
          ? PrivateEventRequestUserDto.fromJson(
              json['user'] as Map<String, dynamic>,
            )
          : null,
      address: json['address'] != null
          ? PrivateEventRequestAddressDto.fromJson(
              json['address'] as Map<String, dynamic>,
            )
          : null,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
    );
  }
}

class PrivateEventRequestServiceDto {
  const PrivateEventRequestServiceDto({
    required this.serviceType,
    required this.guestsCount,
    this.notes,
  });

  final String serviceType;
  final int guestsCount;
  final String? notes;

  factory PrivateEventRequestServiceDto.fromJson(Map<String, dynamic> json) {
    return PrivateEventRequestServiceDto(
      serviceType: json['serviceType'] as String? ?? json['service_type'] as String? ?? '',
      guestsCount: json['guestsCount'] as int? ?? json['guests_count'] as int? ?? 1,
      notes: json['notes'] as String?,
    );
  }
}

class PrivateEventRequestUserDto {
  const PrivateEventRequestUserDto({
    this.id,
    this.name,
    this.phone,
    this.email,
  });

  final String? id;
  final String? name;
  final String? phone;
  final String? email;

  factory PrivateEventRequestUserDto.fromJson(Map<String, dynamic> json) {
    return PrivateEventRequestUserDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }
}

class PrivateEventRequestAddressDto {
  const PrivateEventRequestAddressDto({
    this.label,
    this.streetAddress,
    this.city,
    this.district,
  });

  final String? label;
  final String? streetAddress;
  final String? city;
  final String? district;

  factory PrivateEventRequestAddressDto.fromJson(Map<String, dynamic> json) {
    return PrivateEventRequestAddressDto(
      label: json['label'] as String?,
      streetAddress: json['streetAddress'] as String? ??
          json['street_address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
    );
  }
}
