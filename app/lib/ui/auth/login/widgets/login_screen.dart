import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../routing/routes.dart';
import '../view_models/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loginWithGoogle.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loginWithGoogle.removeListener(_onResult);
    widget.viewModel.loginWithGoogle.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loginWithGoogle.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  void _onResult() {
    if (widget.viewModel.loginWithGoogle.completed) {
      widget.viewModel.loginWithGoogle.clearResult();
      context.go(Routes.tasks);
    }

    if (widget.viewModel.loginWithGoogle.error) {
      widget.viewModel.loginWithGoogle.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.localization.somethingWentWrong)),
      );
    }
  }
}
