import 'package:flutter/material.dart';

import '../../../core/theme/dimens.dart';
import '../view_models/app_drawer_viewmodel.dart';
import 'workspace_tile.dart';

class WorkspacesList extends StatelessWidget {
  const WorkspacesList({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.paddingHorizontal,
        ),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (_, _) {
            return ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: viewModel.workspaces.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: Dimens.paddingVertical / 1.75),
              itemBuilder: (_, index) {
                final workspace = viewModel.workspaces[index];
                return WorkspaceTile(
                  id: workspace.id,
                  name: workspace.name,
                  viewModel: viewModel,
                  isActive: viewModel.activeWorkspaceId == workspace.id,
                  pictureUrl: workspace.pictureUrl,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
