import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';
import 'created_by.dart';

class WorkspaceGoal {
  WorkspaceGoal({
    required this.id,
    required this.title,
    required this.requiredPoints,
    required this.accumulatedPoints,
    required this.assignee,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    this.isNew = false,
  });

  final String id;
  final String title;
  final int requiredPoints;
  final int accumulatedPoints;
  final Assignee assignee;
  final ProgressStatus status;
  final DateTime createdAt;
  final CreatedBy? createdBy;
  final String? description;

  /// Indicates if the goal is newly created. Used
  /// for differentiating between newly created goals
  /// and cached ones from origin.
  final bool isNew;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'requiredPoints': requiredPoints,
    'accumulatedPoints': accumulatedPoints,
    'assignee': assignee.toMap(),
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy?.toMap(),
    'description': description,
    'isNew': isNew,
  };

  factory WorkspaceGoal.fromMap(Map<dynamic, dynamic> map) => WorkspaceGoal(
    id: map['id'] as String,
    title: map['title'] as String,
    requiredPoints: (map['requiredPoints'] as num).toInt(),
    accumulatedPoints: (map['accumulatedPoints'] as num).toInt(),
    assignee: Assignee.fromMap(
      Map<dynamic, dynamic>.from(map['assignee'] as Map),
    ),
    status: ProgressStatus.values.byName(map['status'] as String),
    createdAt: DateTime.parse(map['createdAt'] as String),
    createdBy: map['createdBy'] == null
        ? null
        : CreatedBy.fromMap(
            Map<dynamic, dynamic>.from(map['createdBy'] as Map),
          ),
    description: map['description'] as String?,
    isNew: (map['isNew'] as bool?) ?? false,
  );

  WorkspaceGoal copyWith({ProgressStatus? status}) {
    return WorkspaceGoal(
      id: id,
      title: title,
      requiredPoints: requiredPoints,
      accumulatedPoints: accumulatedPoints,
      createdAt: createdAt,
      createdBy: createdBy,
      description: description,
      assignee: assignee,
      status: status ?? this.status,
      isNew: isNew,
    );
  }
}
