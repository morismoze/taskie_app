import 'package:json_annotation/json_annotation.dart';

import '../../../../user/models/response/user_response.dart';

part 'update_workspace_user_details_request.g.dart';

@JsonSerializable()
class UpdateWorkspaceUserDetailsRequest {
  UpdateWorkspaceUserDetailsRequest({this.firstName, this.lastName, this.role});

  final String? firstName;
  final String? lastName;

  /// This is the value of `WorkspaceRole` enum option
  final String? role;

  Map<String, dynamic> toJson() =>
      _$UpdateWorkspaceUserDetailsRequestToJson(this);
}
