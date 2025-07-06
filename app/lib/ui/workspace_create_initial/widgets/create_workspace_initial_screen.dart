import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../domain/models/workspace.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../workspace_create_initial/widgets/form.dart';
import '../view_models/create_workspace_initial_viewmodel.dart';

class CreateWorkspaceInitialScreen extends StatefulWidget {
  const CreateWorkspaceInitialScreen({super.key, required this.viewModel});

  final CreateWorkspaceInitialViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _CreateWorkspaceInitialScreenState();
}

class _CreateWorkspaceInitialScreenState
    extends State<CreateWorkspaceInitialScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceInitialScreen oldWidget) {
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
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
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
                              listenable: widget.viewModel.loadUser,
                              builder: (context, _) {
                                if (widget.viewModel.loadUser.completed) {
                                  // This return is not defined inside child property of `ListenableBuilder`
                                  // because child is built only once, when the ListenableBuilder is built. And because
                                  // of that widget.viewModel.user is going to be captured as null.
                                  return Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      FractionallySizedBox(
                                        widthFactor: 0.75,
                                        child: Text(
                                          context.localization
                                              .workspaceCreateSubtitle(
                                                widget.viewModel.user!.email!,
                                              ),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(
                                            context,
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
                        CreateFormInitial(viewModel: widget.viewModel),
                      ],
                    ),
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
          (widget.viewModel.createWorkspace.result as Ok<Workspace>).value.id;
      widget.viewModel.createWorkspace.clearResult();
      GoRouter.of(context).go(Routes.tasks(workspaceId: newWorkspaceId));
    }

    if (widget.viewModel.createWorkspace.error) {
      widget.viewModel.createWorkspace.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.errorWhileCreatingWorkspace,
      );
    }
  }
}
