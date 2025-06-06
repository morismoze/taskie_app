import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view_models/tasks_viewmodel.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.viewModel});

  final TasksViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
  void didUpdateWidget(covariant TasksScreen oldWidget) {
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('initial create workspace')],
      ),
    );
  }

  void _onResult() {}
}
