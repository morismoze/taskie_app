import '../../../../value_patch.dart';

class UpdateWorkspaceDetailsRequest {
  UpdateWorkspaceDetailsRequest({this.name, this.description});

  final ValuePatch<String>? name;
  final ValuePatch<String?>? description;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) {
      json['name'] = name!.value;
    }
    if (description != null) {
      json['description'] = description!.value;
    }

    return json;
  }
}
