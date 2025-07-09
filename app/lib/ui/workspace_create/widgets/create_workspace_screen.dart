import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/create_workspace_viewmodel.dart';
import 'form.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key, required this.viewModel});

  final CreateWorkspaceScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
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
                        CreateForm(viewModel: widget.viewModel),
                        const Text('this is not initial create'),
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
}
