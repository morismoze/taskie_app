import '../../data/services/api/workspace/progress_status.dart';

class Assignee {
  Assignee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final ProgressStatus status;
  final String? profileImageUrl;
}
