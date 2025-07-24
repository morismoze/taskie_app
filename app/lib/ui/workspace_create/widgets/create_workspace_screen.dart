import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/create_workspace_screen_viewmodel.dart';
import 'create_workspace_form.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key, required this.viewModel});

  final CreateWorkspaceScreenViewModel viewModel;

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createWorkspace.removeListener(_onResult);
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createWorkspace.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: Dimens.of(context).edgeInsetsScreenSymmetric,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(Assets.createWorkspaceIllustration),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            context.localization.workspaceCreateTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (builderContext, _) {
                              if (widget.viewModel.user != null) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    FractionallySizedBox(
                                      widthFactor: 0.75,
                                      child: Text(
                                        builderContext.localization
                                            .workspaceCreateSubtitle(
                                              widget.viewModel.user!.email!,
                                            ),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          builderContext,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      CreateWorkspaceForm(viewModel: widget.viewModel),
                      const Text('this is not initial create'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.createWorkspace.completed) {
      final newWorkspaceId =
          (widget.viewModel.createWorkspace.result as Ok<String>).value;
      context.go(Routes.tasks(workspaceId: newWorkspaceId));
      widget.viewModel.createWorkspace.clearResult();
    }

    if (widget.viewModel.createWorkspace.error) {
      widget.viewModel.createWorkspace.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.workspaceCreateError,
      );
    }
  }
}
