import '../../../../user/models/response/user_response.dart';
import '../../../../value_patch.dart';

class UpdateWorkspaceUserDetailsRequest {
  UpdateWorkspaceUserDetailsRequest({this.firstName, this.lastName, this.role});

  final ValuePatch<String>? firstName;
  final ValuePatch<String>? lastName;
  final ValuePatch<WorkspaceRole>? role;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (firstName != null) {
      json['firstName'] = firstName!.value;
    }
    if (lastName != null) {
      json['lastName'] = lastName!.value;
    }
    if (role != null) {
      json['role'] = role!.value.value;
    }

    return json;
  }
}
