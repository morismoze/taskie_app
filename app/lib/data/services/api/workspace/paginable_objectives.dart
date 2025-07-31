import '../paginable.dart';
import 'progress_status.dart';

class ObjectiveRequestQueryParams extends RequestQueryParams {
  ObjectiveRequestQueryParams({
    super.page,
    super.limit = 20,
    super.search,
    this.status,
  });

  final ProgressStatus? status;

  Map<String, String> generateQueryParamsMap() {
    return {
      if (page != null) 'page': page!.toString(),
      if (limit != null) 'limit': limit!.toString(),
      if (search != null) 'search': search!,
      if (status != null) 'status': status!.value,
    };
  }
}
