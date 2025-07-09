import 'package:flutter/material.dart';

import '../../core/ui/blurred_circles_background.dart';
import '../view_models/create_task_viewmodel.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, required this.viewModel});

  final CreateTaskViewmodel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState extends State<CreateTaskScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateTaskScreen oldWidget) {
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
        child: BlurredCirclesBackground(
          child: SafeArea(child: Text('create task')),
        ),
      ),
    );
  }
}
