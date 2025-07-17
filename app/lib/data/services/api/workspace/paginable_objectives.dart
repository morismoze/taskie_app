import '../paginable.dart';
import 'progress_status.dart';

class PaginableObjectivesRequestQueryParams
    extends PaginableRequestQueryParams {
  PaginableObjectivesRequestQueryParams({
    super.page,
    super.limit,
    super.search,
    this.status,
  });

  final ProgressStatus? status;

  static Map<String, String> generateQueryParams({
    int? page,
    int? limit,
    String? search,
    ProgressStatus? status,
  }) {
    return {
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (search != null) 'search': search,
      if (status != null) 'status': status.value,
    };
  }
}
