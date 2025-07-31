import 'package:json_annotation/json_annotation.dart';

part 'paginable.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PaginableResponse<D> {
  PaginableResponse({required this.items, required this.total});

  final List<D> items;
  final int total;

  factory PaginableResponse.fromJson(
    Map<String, dynamic> json,
    D Function(Object? json) fromJsonT,
  ) => _$PaginableResponseFromJson(json, fromJsonT);
}

class RequestQueryParams {
  RequestQueryParams({this.page = 1, this.limit, this.search});

  final int? page;
  final int? limit;
  final String? search;
}
