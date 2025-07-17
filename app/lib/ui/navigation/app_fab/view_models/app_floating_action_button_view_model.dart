import 'package:flutter/foundation.dart';

class AppFloatingActionButtonViewModel extends ChangeNotifier {
  AppFloatingActionButtonViewModel({required String workspaceId})
    : _activeWorkspaceId = workspaceId;

  final String _activeWorkspaceId;

  String get activeWorkspaceId => _activeWorkspaceId;
}
