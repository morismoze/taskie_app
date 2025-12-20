import '../../data/services/api/paginable.dart';
import '../../data/services/api/workspace/progress_status.dart';

class Filter {
  Filter({required this.page, required this.limit, this.search});

  final int page;
  final int limit;
  final String? search;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! Filter) {
      return false;
    }

    return page == other.page && limit == other.limit && search == other.search;
  }

  @override
  int get hashCode => Object.hash(page, limit, search);

  Filter copyWith({int? page, int? limit, String? search}) {
    return Filter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
    );
  }
}

class ObjectiveFilter extends Filter {
  ObjectiveFilter({
    required super.page,
    required super.limit,
    super.search,
    required this.sort,
    // Status can be null because we have All statuses option
    this.status,
  });

  final SortBy sort;
  final ProgressStatus? status;

  // Sentinel for 'no change', used to differentiate from the real/wanted null value
  static const _unset = Object();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! ObjectiveFilter) {
      return false;
    }

    return page == other.page &&
        limit == other.limit &&
        search == other.search &&
        status == other.status &&
        sort == other.sort;
  }

  @override
  int get hashCode => Object.hash(page, limit, search, status);

  @override
  ObjectiveFilter copyWith({
    int? page,
    int? limit,
    String? search,
    // Sentinel value is used here, because null is a valid value
    // representing no filter by status, so we need a way to
    // differentiate between null value and no value.
    Object? status = _unset,
    SortBy? sort,
  }) {
    return ObjectiveFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      status: identical(status, _unset)
          ? this.status
          : status as ProgressStatus?,
      sort: sort ?? this.sort,
    );
  }
}
