import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/create_workspace_user_screen_viewmodel.dart';

class CreateWorkspaceUserScreen extends StatefulWidget {
  const CreateWorkspaceUserScreen({super.key, required this.viewModel});

  final CreateWorkspaceUserScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _CreateWorkspaceUserScreenState();
}

class _CreateWorkspaceUserScreenState extends State<CreateWorkspaceUserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceUserScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: SafeArea(
            child: Column(
              children: [
                HeaderBar(
                  title: context.localization.workspaceUsersManagementCreate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
