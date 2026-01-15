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

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'description': description,
    'pictureUrl': pictureUrl,
    'createdBy': createdBy?.toMap(),
  };

  factory Workspace.fromMap(Map<dynamic, dynamic> map) => Workspace(
    id: map['id'] as String,
    name: map['name'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    description: map['description'] as String?,
    pictureUrl: map['pictureUrl'] as String?,
    createdBy: map['createdBy'] == null
        ? null
        : CreatedBy.fromMap(
            Map<dynamic, dynamic>.from(map['createdBy'] as Map),
          ),
  );
}
