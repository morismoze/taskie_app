import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/rbac.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/rbac.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';
import 'workspace_user_tile.dart';

class WorkspaceUsersManagementScreen extends StatefulWidget {
  const WorkspaceUsersManagementScreen({super.key, required this.viewModel});

  final WorkspaceUsersManagementScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceUsersManagementScreenState();
}

class _WorkspaceUsersManagementScreenState
    extends State<WorkspaceUsersManagementScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadWorkspaceMembers.addListener(
      _onWorkspaceUsersLoadResult,
    );
    widget.viewModel.deleteWorkspaceUser.addListener(
      _onWorkspaceUserDeleteResult,
    );
  }

  @override
  void didUpdateWidget(covariant WorkspaceUsersManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadWorkspaceMembers.removeListener(
      _onWorkspaceUsersLoadResult,
    );
    oldWidget.viewModel.deleteWorkspaceUser.removeListener(
      _onWorkspaceUserDeleteResult,
    );
    widget.viewModel.loadWorkspaceMembers.addListener(
      _onWorkspaceUsersLoadResult,
    );
    widget.viewModel.deleteWorkspaceUser.addListener(
      _onWorkspaceUserDeleteResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.loadWorkspaceMembers.removeListener(
      _onWorkspaceUsersLoadResult,
    );
    widget.viewModel.deleteWorkspaceUser.removeListener(
      _onWorkspaceUserDeleteResult,
    );
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
                  listenable: widget.viewModel,
                  builder: (builderContext, child) {
                    if (widget.viewModel.users == null) {
                      return ActivityIndicator(
                        radius: 16,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    // If there was an error while fetching from origin, display error prompt
                    // only on initial load (`widget.viewModel.users will` be `null`). In other
                    // cases, old list will still be shown, but we will show snackbar.
                    if (widget.viewModel.loadWorkspaceMembers.error &&
                        widget.viewModel.users == null) {
                      // TODO: Usage of a generic error prompt widget
                      return const SizedBox.shrink();
                    }

                    // We don't have the standard 'First ListenableBuilder listening to a command
                    // and its child is the second ListenableBuilder listening to viewModel' because
                    // we want to show [ActivityIndicator] only on the initial load. All other loads
                    // after that will happen when user pulls-to-refresh (and if the app process was not
                    // killed by the underlying OS). And in that case we want to show the existing
                    // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
                    return RefreshIndicator(
                      displacement: 30,
                      onRefresh: () async {
                        widget.viewModel.loadWorkspaceMembers.execute((
                          widget.viewModel.activeWorkspaceId,
                          true,
                        ));
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          left: Dimens.of(context).paddingScreenHorizontal,
                          right: Dimens.of(context).paddingScreenHorizontal,
                        ),
                        itemCount: widget.viewModel.users!.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final workspaceUser = widget.viewModel.users![index];
                          final currentUser = widget.viewModel.currentUser;

                          final isCurrentUser =
                              currentUser.id == workspaceUser.userId;

                          return WorkspaceUserTile(
                            viewModel: widget.viewModel,
                            id: workspaceUser.id,
                            firstName: workspaceUser.firstName,
                            lastName: workspaceUser.lastName,
                            role: workspaceUser.role,
                            isCurrentUser: isCurrentUser,
                            email: workspaceUser.email,
                            profileImageUrl: workspaceUser.profileImageUrl,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onWorkspaceUsersLoadResult() {
    if (widget.viewModel.loadWorkspaceMembers.completed) {
      widget.viewModel.loadWorkspaceMembers.clearResult();
    }

    // Showing snackbar only on subsequest pull-to-refreshes
    // and not on initial load.
    if (widget.viewModel.loadWorkspaceMembers.error &&
        widget.viewModel.users != null) {
      widget.viewModel.loadWorkspaceMembers.clearResult();

      AppSnackbar.showError(
        context: context,
        message: context.localization.workspaceUsersManagementLoadUsersError,
      );
    }
  }

  void _onWorkspaceUserDeleteResult() {
    if (widget.viewModel.deleteWorkspaceUser.completed) {
      widget.viewModel.deleteWorkspaceUser.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.workspaceUsersManagementDeleteUserSuccess,
      );
      context.pop(); // Close dialog
      context.pop(); // Close bottom sheet
    }

    if (widget.viewModel.deleteWorkspaceUser.error) {
      widget.viewModel.deleteWorkspaceUser.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.workspaceUsersManagementDeleteUserError,
      );
      context.pop(); // Close dialog
      context.pop(); // Close bottom sheet
    }
  }
}
