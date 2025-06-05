import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../view_models/initial_create_workspace_viewmodel.dart';

class InitialCreateWorkspaceScreen extends StatefulWidget {
  const InitialCreateWorkspaceScreen({super.key, required this.viewModel});

  final InitialWorkspacesViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _InitialCreateWorkspaceScreenState();
}

class _InitialCreateWorkspaceScreenState
    extends State<InitialCreateWorkspaceScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
    widget.viewModel.getTasks.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant InitialCreateWorkspaceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.getTasks.removeListener(_onResult);
    widget.viewModel.getTasks.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.getTasks.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('initial create workspace')],
        ),
      ),
    );
  }

  void _onResult() {}
}
