import '../paginable.dart';
import 'progress_status.dart';

class ObjectiveRequestQueryParams extends RequestQueryParams {
  ObjectiveRequestQueryParams({
    required super.page,
    required super.limit,
    super.search,
    required this.sort,
    this.status,
  });

  final SortBy sort;
  final ProgressStatus? status;

  Map<String, String> generateQueryParamsMap() {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search!,
      if (status != null) 'status': status!.value,
      'sort': sort.value,
    };
  }
}
