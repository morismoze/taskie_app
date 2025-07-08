import 'package:flutter/material.dart';

import '../../core/ui/blurred_circles_background.dart';
import '../view_models/workspace_settings_viewmodel.dart';

class WorkspaceSettingsScreen extends StatefulWidget {
  const WorkspaceSettingsScreen({super.key, required this.viewModel});

  final WorkspaceSettingsViewmodel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState extends State<WorkspaceSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkspaceSettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(child: Text('Workspace settings')),
      ),
    );
  }
}
