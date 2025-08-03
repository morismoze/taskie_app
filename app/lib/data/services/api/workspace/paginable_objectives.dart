import '../paginable.dart';
import 'progress_status.dart';

class ObjectiveRequestQueryParams extends RequestQueryParams {
  ObjectiveRequestQueryParams({
    required super.page,
    required super.limit,
    super.search,
    required this.status,
    required this.sort,
  });

  final ProgressStatus status;
  final SortBy sort;

  Map<String, String> generateQueryParamsMap() {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search!,
      'status': status.value,
      'sort': sort.value,
    };
  }
}
