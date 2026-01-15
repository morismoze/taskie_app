import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';
import 'created_by.dart';

class WorkspaceTask {
  WorkspaceTask({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.dueDate,
    this.isNew = false,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<WorkspaceTaskAssignee> assignees;
  final DateTime createdAt;
  final CreatedBy? createdBy;
  final String? description;
  final DateTime? dueDate;

  /// Indicates if the task is newly created. Used
  /// for differentiating between newly created tasks
  /// and cached ones from origin.
  final bool isNew;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'rewardPoints': rewardPoints,
    'assignees': assignees.map((a) => a.toMap()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy?.toMap(),
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'isNew': isNew,
  };

  factory WorkspaceTask.fromMap(Map<dynamic, dynamic> map) => WorkspaceTask(
    id: map['id'] as String,
    title: map['title'] as String,
    rewardPoints: (map['rewardPoints'] as num).toInt(),
    assignees: ((map['assignees'] as List?) ?? const [])
        .map(
          (e) => WorkspaceTaskAssignee.fromMap(
            Map<dynamic, dynamic>.from(e as Map),
          ),
        )
        .toList(),
    createdAt: DateTime.parse(map['createdAt'] as String),
    createdBy: map['createdBy'] == null
        ? null
        : CreatedBy.fromMap(
            Map<dynamic, dynamic>.from(map['createdBy'] as Map),
          ),
    description: map['description'] as String?,
    dueDate: map['dueDate'] == null
        ? null
        : DateTime.parse(map['dueDate'] as String),
    isNew: (map['isNew'] as bool?) ?? false,
  );

  WorkspaceTask copyWith({List<WorkspaceTaskAssignee>? assignees}) {
    return WorkspaceTask(
      id: id,
      title: title,
      rewardPoints: rewardPoints,
      assignees: assignees ?? this.assignees,
      createdAt: createdAt,
      createdBy: createdBy,
      description: description,
      dueDate: dueDate,
      isNew: isNew,
    );
  }
}

class WorkspaceTaskAssignee extends Assignee {
  WorkspaceTaskAssignee({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
    required this.status,
  });

  final ProgressStatus status;

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'status': status.name};

  factory WorkspaceTaskAssignee.fromMap(Map<dynamic, dynamic> map) =>
      WorkspaceTaskAssignee(
        id: map['id'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        profileImageUrl: map['profileImageUrl'] as String?,
        status: ProgressStatus.values.byName(map['status'] as String),
      );

  WorkspaceTaskAssignee copyWith({ProgressStatus? status}) {
    return WorkspaceTaskAssignee(
      id: id,
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
      status: status ?? this.status,
    );
  }
}
