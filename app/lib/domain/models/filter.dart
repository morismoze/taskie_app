import '../../data/services/api/workspace/progress_status.dart';

class Filter {
  Filter({this.page = 1, this.limit, this.search});

  final int page;
  final int? limit;
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
}

class ObjectiveFilter extends Filter {
  ObjectiveFilter({super.page, super.limit, super.search, this.status});

  final ProgressStatus? status;

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
        status == other.status;
  }

  @override
  int get hashCode => Object.hash(page, limit, search, status);
}
