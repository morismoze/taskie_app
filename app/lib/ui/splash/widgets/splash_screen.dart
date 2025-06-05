import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../view_models/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.viewModel});

  final SplashViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
  void didUpdateWidget(covariant SplashScreen oldWidget) {
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
    return FScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('splash')],
        ),
      ),
    );
  }

  void _onResult() {}
}
