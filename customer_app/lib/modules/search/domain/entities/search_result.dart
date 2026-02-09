import 'package:equatable/equatable.dart';
import '../../../vendors/domain/entities/vendor.dart';

class SearchResult extends Equatable {
  final Vendor vendor;
  final double? distance; // in kilometers

  const SearchResult({
    required this.vendor,
    this.distance,
  });

  @override
  List<Object?> get props => [vendor, distance];
}
