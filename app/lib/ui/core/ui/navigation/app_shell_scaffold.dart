import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_drawer/view_models/app_drawer_viewmodel.dart';
import '../../../app_drawer/widgets/app_drawer.dart';
import 'app_bottom_navigation_bar.dart';
import 'app_floating_action_button.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appDrawerViewModel = AppDrawerViewModel(
      workspaceRepository: context.read(),
    );

    return Scaffold(
      drawer: AppDrawer(viewModel: appDrawerViewModel),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          appDrawerViewModel.loadWorkspaces.execute();
        }
      },
      extendBody: true,
      bottomNavigationBar: const AppBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: const AppFloatingActionButton(),
      body: child,
    );
  }
}
