/// كيان عرض المناسبة في الطبقة التطبيقية.
class EventOffer {
  const EventOffer({
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
  });

  final String id;
  final String serviceType;
  final String eventType;
  final String? title;
  final String? description;
  final double? pricePerPerson;
  final double? priceTotal;
  final int minGuests;
  final int? maxGuests;
  final bool isActive;
}
