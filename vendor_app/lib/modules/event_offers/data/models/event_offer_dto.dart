/// DTO لعرض المناسبة — متوافق مع API الباك اند.
class EventOfferDto {
  const EventOfferDto({
    required this.id,
    required this.serviceType,
    required this.eventType,
    this.title,
    this.description,
    this.pricePerPerson,
    this.priceTotal,
    this.minGuests = 1,
    this.maxGuests,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String serviceType; // buffet, desserts, drinks, staff
  final String eventType; // wedding, graduation, henna, engagement, other
  final String? title;
  final String? description;
  final double? pricePerPerson;
  final double? priceTotal;
  final int minGuests;
  final int? maxGuests;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  factory EventOfferDto.fromJson(Map<String, dynamic> json) {
    return EventOfferDto(
      id: json['id'] as String? ?? '',
      serviceType: json['serviceType'] as String? ?? json['service_type'] as String? ?? '',
      eventType: json['eventType'] as String? ?? json['event_type'] as String? ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      pricePerPerson: (json['pricePerPerson'] as num?)?.toDouble() ??
          (json['price_per_person'] as num?)?.toDouble(),
      priceTotal: (json['priceTotal'] as num?)?.toDouble() ??
          (json['price_total'] as num?)?.toDouble(),
      minGuests: json['minGuests'] as int? ?? json['min_guests'] as int? ?? 1,
      maxGuests: json['maxGuests'] as int? ?? json['max_guests'] as int?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
      updatedAt: json['updatedAt'] as String? ?? json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'serviceType': serviceType,
      'eventType': eventType,
      'title': title,
      'description': description,
      'pricePerPerson': pricePerPerson,
      'priceTotal': priceTotal,
      'minGuests': minGuests,
      'maxGuests': maxGuests,
      'isActive': isActive,
    };
  }
}
