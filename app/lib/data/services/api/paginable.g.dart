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
  total: (json['total'] as num).toInt(),
);
