// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginableResponse<D> _$PaginableResponseFromJson<D>(
  Map<String, dynamic> json,
  D Function(Object? json) fromJsonD,
) => PaginableResponse<D>(
  items: (json['items'] as List<dynamic>).map(fromJsonD).toList(),
  totalPages: (json['totalPages'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);
