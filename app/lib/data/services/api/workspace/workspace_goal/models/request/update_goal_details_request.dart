import '../../../../value_patch.dart';

class UpdateGoalDetailsRequest {
  UpdateGoalDetailsRequest({
    this.title,
    this.description,
    this.requiredPoints,
    this.assigneeId,
  });

  final ValuePatch<String>? title;
  final ValuePatch<String?>? description;
  final ValuePatch<int>? requiredPoints;
  final ValuePatch<String?>? assigneeId; // Workspace user ID

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (title != null) {
      json['title'] = title!.value;
    }
    if (description != null) {
      json['description'] = description!.value;
    }
    if (requiredPoints != null) {
      json['requiredPoints'] = requiredPoints!.value;
    }
    if (assigneeId != null) {
      json['assigneeId'] = assigneeId!.value;
    }

    return json;
  }
}
