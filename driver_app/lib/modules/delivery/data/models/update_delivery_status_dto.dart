/// Update Delivery Status DTO
class UpdateDeliveryStatusDto {
  final String status; // 'picked_up' or 'delivered'

  UpdateDeliveryStatusDto({required this.status});

  Map<String, dynamic> toJson() => {
        'status': status,
      };
}
