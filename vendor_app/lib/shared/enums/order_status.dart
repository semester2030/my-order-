/// حالة الطلب — متوافق مع الباك اند (Phase 8).
enum OrderStatus {
  pending,
  accepted,
  rejected,
  preparing,
  ready,
  delivered,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  String get value => name;

  /// تسمية عربية للعرض في الواجهة (Phase 9).
  String get labelAr {
    switch (this) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.accepted:
        return 'مقبول';
      case OrderStatus.rejected:
        return 'مرفوض';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.ready:
        return 'جاهز';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغى';
    }
  }

  static OrderStatus? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    final lower = value.toLowerCase();
    // الباك اند يرجع confirmed بدل accepted
    if (lower == 'confirmed') return OrderStatus.accepted;
    for (final e in OrderStatus.values) {
      if (e.name == lower) return e;
    }
    return null;
  }
}
