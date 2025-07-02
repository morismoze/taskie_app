import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../view_models/app_drawer_viewmodel.dart';
import '../view_models/workspace_image.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.paddingVertical,
          horizontal: Dimens.paddingHorizontal,
        ),
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                context.localization.tasksDrawerTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 12),
            ListenableBuilder(
              listenable: viewModel.loadWorkspaces,
              builder: (context, child) {
                if (viewModel.loadWorkspaces.completed) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: viewModel.workspaces
                        .map(
                          (workspace) => Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: WorkspaceImage(
                                  url: workspace.pictureUrl,
                                ),
                                trailing: const InkWell(
                                  child: FaIcon(
                                    FontAwesomeIcons.ellipsisVertical,
                                    color: AppColors.grey2,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  workspace.name,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        )
                        .toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
