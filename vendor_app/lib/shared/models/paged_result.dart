import 'api_meta.dart';

/// نتيجة صفحة واحدة من قائمة — data + meta (Phase 8).
class PagedResult<T> {
  const PagedResult({
    required this.data,
    required this.meta,
  });

  final List<T> data;
  final ApiMeta meta;

  bool get hasNextPage => meta.hasNextPage;
  bool get hasPreviousPage => meta.hasPreviousPage;
  int get total => meta.total;
  int get page => meta.page;
}
