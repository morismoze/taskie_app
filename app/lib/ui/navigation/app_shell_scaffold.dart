import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_bottom_navigation_bar/view_models/app_bottom_navigation_bar_view_model.dart';
import 'app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import 'app_drawer/view_models/app_drawer_viewmodel.dart';
import 'app_drawer/widgets/app_drawer.dart';
import 'app_fab/view_models/app_floating_action_button_view_model.dart';
import 'app_fab/widgets/app_floating_action_button.dart';

final GlobalKey<ScaffoldState> appShellScaffoldKey = GlobalKey<ScaffoldState>();

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.workspaceId,
    required this.navigationShell,
  });

  final String workspaceId;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final appDrawerViewModel = context.read<AppDrawerViewModel>();

    return Scaffold(
      key: appShellScaffoldKey,
      drawer: AppDrawer(viewModel: appDrawerViewModel),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          appDrawerViewModel.loadWorkspaces.execute();
        }
      },
      extendBody: true,
      bottomNavigationBar: AppBottomNavigationBar(
        viewModel: context.read<AppBottomNavigationBarViewModel>(),
        navigationShell: navigationShell,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppFloatingActionButton(
        viewModel: AppFloatingActionButtonViewModel(workspaceId: workspaceId),
      ),
      body: navigationShell,
    );
  }
}
