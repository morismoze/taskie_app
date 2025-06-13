import 'package:flutter/material.dart';

import 'app_bottom_navigation_bar.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const AppBottomNavigationBar(),
      body: child,
    );
  }
}
