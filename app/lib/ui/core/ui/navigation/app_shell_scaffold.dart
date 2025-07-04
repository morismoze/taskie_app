import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_bottom_navigation_bar/view_models/app_bottom_navigation_bar_viewmodel.dart';
import '../../../app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import '../../../app_drawer/view_models/app_drawer_viewmodel.dart';
import '../../../app_drawer/widgets/app_drawer.dart';
import 'app_floating_action_button.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // This is a place which can be optimized - new instances of AppDrawerViewModel
    // and AppBottomNavigationBarViewmodel are generated on every navigation inside the ShellRoute.
    final appDrawerViewModel = AppDrawerViewModel(
      workspaceRepository: context.read(),
    );
    final appBottomNavigationBarViewModel = AppBottomNavigationBarViewmodel(
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
      bottomNavigationBar: AppBottomNavigationBar(
        viewModel: appBottomNavigationBarViewModel,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: const AppFloatingActionButton(),
      body: child,
    );
  }
}
