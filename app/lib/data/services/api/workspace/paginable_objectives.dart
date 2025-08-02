import '../paginable.dart';
import 'progress_status.dart';

class ObjectiveRequestQueryParams extends RequestQueryParams {
  ObjectiveRequestQueryParams({
    super.page,
    super.search,
    required this.limit,
    this.status,
  }) : super(limit: limit);

  @override
  final int limit;
  final ProgressStatus? status;

  Map<String, String> generateQueryParamsMap() {
    return {
      if (page != null) 'page': page!.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search!,
      if (status != null) 'status': status!.value,
    };
  }
}
