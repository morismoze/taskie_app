import '../../../../value_patch.dart';

class UpdateTaskDetailsRequest {
  UpdateTaskDetailsRequest({
    this.title,
    this.description,
    this.rewardPoints,
    this.dueDate,
  });

  // non-nullable fields
  final ValuePatch<String>? title;
  final ValuePatch<int>? rewardPoints;

  // nullable fields
  final ValuePatch<String?>? description;
  final ValuePatch<DateTime?>? dueDate;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (title != null) {
      json['title'] = title!.value;
    }
    if (description != null) {
      json['description'] = description!.value;
    }
    if (rewardPoints != null) {
      json['rewardPoints'] = rewardPoints!.value;
    }
    if (dueDate != null) {
      json['dueDate'] = dueDate!.value?.toIso8601String();
    }

    return json;
  }
}
