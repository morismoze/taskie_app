import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_drawer/view_models/app_drawer_viewmodel.dart';
import '../app_drawer/widgets/app_drawer.dart';
import 'app_bottom_app_bar.dart';
import 'app_floating_action_button.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // This is a place which can be optimized - new instances of AppDrawerViewModel
    // are generated on every navigation inside the ShellRoute.
    final appDrawerViewModel = AppDrawerViewModel(
      workspaceRepository: context.read(),
      refreshTokenUseCase: context.read(),
    );

    return Scaffold(
      drawer: AppDrawer(viewModel: appDrawerViewModel),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          appDrawerViewModel.loadWorkspaces.execute();
          appDrawerViewModel.loadActiveWorkspaceId.execute();
        }
      },
      extendBody: true,
      bottomNavigationBar: const AppBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: const AppFloatingActionButton(),
      body: child,
    );
  }
}
