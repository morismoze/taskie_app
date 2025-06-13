import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/tasks_viewmodel.dart';
import 'tasks_header.dart';

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
    widget.viewModel.loadUser.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadUser.removeListener(_onResult);
    widget.viewModel.loadUser.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadUser.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimens.of(context).paddingScreenHorizontal,
                right: Dimens.of(context).paddingScreenHorizontal,
                bottom: kBottomNavigationBarHeight + Dimens.paddingVertical,
              ),
              child: Column(
                children: [
                  ListenableBuilder(
                    listenable: widget.viewModel.loadUser,
                    builder: (context, child) {
                      if (widget.viewModel.loadUser.completed) {
                        return child!;
                      }
                      return const SizedBox.shrink();
                    },
                    child: TasksHeader(viewModel: widget.viewModel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {}
}
