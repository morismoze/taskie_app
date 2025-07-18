import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/rbac.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/rbac.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';
import 'workspace_user_tile.dart';

class WorkspaceUsersManagementScreen extends StatefulWidget {
  const WorkspaceUsersManagementScreen({super.key, required this.viewModel});

  final WorkspaceUsersScreenManagementViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceUsersManagementScreenState();
}

class _WorkspaceUsersManagementScreenState
    extends State<WorkspaceUsersManagementScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkspaceUsersManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.workspaceUsersManagement,
                actions: [
                  Rbac(
                    permission: RbacPermission.workspaceManageUsers,
                    child: AppHeaderActionButton(
                      iconData: FontAwesomeIcons.plus,
                      onTap: () {
                        context.push(
                          Routes.workspaceUsersCreate(
                            workspaceId: widget.viewModel.activeWorkspaceId,
                          ),
                        );
                      },
                    ),
                  ),
                  AppHeaderActionButton(
                    iconData: FontAwesomeIcons.question,
                    onTap: () => context.push(
                      Routes.workspaceUsersGuide(
                        workspaceId: widget.viewModel.activeWorkspaceId,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: widget.viewModel.loadWorkspaceMembers,
                  builder: (builderContext, child) {
                    if (widget.viewModel.loadWorkspaceMembers.running) {
                      return ActivityIndicator(
                        radius: 16,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    if (widget.viewModel.loadWorkspaceMembers.error) {
                      // Usage of a generic error prompt widget
                    }

                    return child!;
                  },
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (innerBuilderContext, _) => ListView.separated(
                      padding: EdgeInsets.only(
                        bottom: 20,
                        left: Dimens.of(context).paddingScreenHorizontal,
                        right: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      itemCount: widget.viewModel.users.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final workspaceUser = widget.viewModel.users[index];

                        return WorkspaceUserTile(
                          activeWorkspaceId: widget.viewModel.activeWorkspaceId,
                          id: workspaceUser.id,
                          firstName: workspaceUser.firstName,
                          lastName: workspaceUser.lastName,
                          role: workspaceUser.role,
                          email: workspaceUser.email,
                          profileImageUrl: workspaceUser.profileImageUrl,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
