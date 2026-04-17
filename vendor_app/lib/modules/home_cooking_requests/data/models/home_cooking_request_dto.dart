import 'package:vendor_app/modules/chef_booking_requests/data/models/chef_booking_request_dto.dart';

/// طلب طبخ منزلي — استجابة `GET /vendors/home-cooking-requests`.
class HomeCookingRequestDto {
  const HomeCookingRequestDto({
    required this.id,
    required this.requestType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.guestsCount,
    required this.status,
    this.notes,
    this.quotedAmount,
    this.quoteNotes,
    this.customDishNames,
    this.delivery,
    this.handedOverAt,
    this.handoverNotes,
    this.completionCertificateCode,
    this.user,
    this.address,
  });

  final String id;
  final String requestType;
  final String scheduledDate;
  final String scheduledTime;
  final int guestsCount;
  final String status;
  final String? notes;
  final String? quotedAmount;
  final String? quoteNotes;
  final String? customDishNames;
  final bool? delivery;
  final String? handedOverAt;
  final String? handoverNotes;
  final String? completionCertificateCode;
  final ChefBookingUserDto? user;
  final ChefBookingAddressDto? address;

  factory HomeCookingRequestDto.fromJson(Map<String, dynamic> json) {
    final rawQuoted = json['quotedAmount'] ?? json['quoted_amount'];
    String? quotedStr;
    if (rawQuoted != null) {
      quotedStr = rawQuoted is num ? rawQuoted.toString() : rawQuoted.toString();
    }
    final del = json['delivery'];
    return HomeCookingRequestDto(
      id: json['id'] as String? ?? '',
      requestType:
          json['requestType'] as String? ?? json['request_type'] as String? ?? 'home_cooking',
      scheduledDate:
          json['scheduledDate'] as String? ?? json['scheduled_date'] as String? ?? '',
      scheduledTime:
          json['scheduledTime'] as String? ?? json['scheduled_time'] as String? ?? '',
      guestsCount: json['guestsCount'] as int? ?? json['guests_count'] as int? ?? 1,
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      quotedAmount: quotedStr,
      quoteNotes: json['quoteNotes'] as String? ?? json['quote_notes'] as String?,
      customDishNames:
          json['customDishNames'] as String? ?? json['custom_dish_names'] as String?,
      delivery: del is bool ? del : null,
      handedOverAt: json['handedOverAt'] as String? ?? json['handed_over_at'] as String?,
      handoverNotes: json['handoverNotes'] as String? ?? json['handover_notes'] as String?,
      completionCertificateCode: json['completionCertificateCode'] as String? ??
          json['completion_certificate_code'] as String?,
      user: json['user'] != null
          ? ChefBookingUserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? ChefBookingAddressDto.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}
