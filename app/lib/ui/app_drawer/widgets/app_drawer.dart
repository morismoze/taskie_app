import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_text_button.dart';
import '../view_models/app_drawer_viewmodel.dart';
import '../view_models/workspace_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
          top: Dimens.paddingVertical,
          bottom: kBottomNavigationBarHeight + Dimens.paddingVertical / 2,
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.paddingHorizontal,
                ),
                child: ListView(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        context.localization.appDrawerTitle,
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
                                      WorkspaceTile(
                                        id: workspace.id,
                                        name: workspace.name,
                                        viewModel: viewModel,
                                        pictureUrl: workspace.pictureUrl,
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
            ),
            const SizedBox(height: 12),
            const Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: AppColors.grey1,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.paddingHorizontal,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AppTextButton(
                  onPress: () => context.push(Routes.createWorkspace),
                  label: context.localization.appDrawerCreateNewWorkspace,
                  leadingIcon: FontAwesomeIcons.plus,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
