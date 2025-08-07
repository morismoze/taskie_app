import 'created_by.dart';

class Workspace {
  Workspace({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.description,
    required this.pictureUrl,
    required this.createdBy,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String? description;
  final String? pictureUrl;
  final CreatedBy? createdBy;
}
