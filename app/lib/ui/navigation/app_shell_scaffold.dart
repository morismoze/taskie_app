import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_bottom_navigation_bar/view_models/app_bottom_navigation_bar_view_model.dart';
import 'app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import 'app_drawer/view_models/app_drawer_viewmodel.dart';
import 'app_drawer/widgets/app_drawer.dart';
import 'app_fab/view_models/app_floating_action_button_view_model.dart';
import 'app_fab/widgets/app_floating_action_button.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.workspaceId,
    required this.child,
  });

  final String workspaceId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appDrawerViewModel = AppDrawerViewModel(
      workspaceId: workspaceId,
      workspaceRepository: context.read(),
      workspaceTaskRepository: context.read(),
      refreshTokenUseCase: context.read(),
    );

    return Scaffold(
      drawer: AppDrawer(viewModel: appDrawerViewModel),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          appDrawerViewModel.loadWorkspaces.execute();
        }
      },
      extendBody: true,
      bottomNavigationBar: AppBottomNavigationBar(
        key: ValueKey(workspaceId),
        viewModel: AppBottomNavigationBarViewModel(
          workspaceId: workspaceId,
          rbacUseCase: context.read(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: AppFloatingActionButton(
        key: ValueKey(workspaceId),
        viewModel: AppFloatingActionButtonViewModel(workspaceId: workspaceId),
      ),
      body: child,
    );
  }
}
