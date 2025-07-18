import 'package:flutter/material.dart';

import '../../core/ui/blurred_circles_background.dart';
import '../view_models/preferences_screen_viewmodel.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key, required this.viewModel});

  final PreferencesScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PreferencesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(child: Text('preferences')),
      ),
    );
  }
}
