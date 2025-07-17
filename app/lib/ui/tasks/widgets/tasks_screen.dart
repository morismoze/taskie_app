import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/utils/constants.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'tasks_header.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );
  }

  @override
  void didUpdateWidget(covariant TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BlurredCirclesBackground(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: Dimens.of(context).paddingScreenHorizontal,
              right: Dimens.of(context).paddingScreenHorizontal,
              bottom: kAppBottomNavigationBarHeight + Dimens.paddingVertical,
            ),
            child: Column(
              children: [
                ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (builderContext, _) {
                    if (widget.viewModel.user != null) {
                      return TasksHeader(viewModel: widget.viewModel);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (builderContext, _) {
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
