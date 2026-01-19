import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/rbac.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_toast.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/error_prompt.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/rbac.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';
import 'users_list.dart';

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
                    permission: RbacPermission.workspaceUsersCreate,
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
                  listenable: Listenable.merge([
                    widget.viewModel.loadWorkspaceMembers,
                    widget.viewModel,
                  ]),
                  builder: (builderContext, child) {
                    if (widget.viewModel.loadWorkspaceMembers.running &&
                        widget.viewModel.users == null) {
                      return const ActivityIndicator(radius: 16);
                    }

                    // Display error prompt only on initial load. In other cases, old list
                    // will still be shown, but we will show error snackbar.
                    if (widget.viewModel.loadWorkspaceMembers.error &&
                        widget.viewModel.users == null) {
                      return ErrorPrompt(
                        onRetry: () =>
                            widget.viewModel.loadWorkspaceMembers.execute(true),
                      );
                    }

                    // We don't have the standard 'First ListenableBuilder listening to a command
                    // and its child is the second ListenableBuilder listening to viewModel' because
                    // we want to show [ActivityIndicator] only on the initial load. All other loads
                    // after that will happen when user pulls-to-refresh (and if the app process was not
                    // killed by the underlying OS). And in that case we want to show the existing
                    // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async => await widget
                              .viewModel
                              .loadWorkspaceMembers
                              .execute(true),
                          refreshTriggerPullDistance: 150,
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(
                            bottom: 20,
                            left: Dimens.of(context).paddingScreenHorizontal,
                            right: Dimens.of(context).paddingScreenHorizontal,
                          ),
                          sliver: UsersList(viewModel: widget.viewModel),
                        ),
                      ],
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

    if (widget.viewModel.loadWorkspaceMembers.error) {
      // Show snackbar only in the case there already is some
      // cached data - basically when pull-to-refresh happens.
      // On the first load and error we display the ErrorPrompt widget.
      if (widget.viewModel.users != null) {
        widget.viewModel.loadWorkspaceMembers.clearResult();
        AppToast.showError(
          context: context,
          message: context.localization.workspaceUsersManagementLoadUsersError,
        );
      }
    }
  }

  void _onWorkspaceUserDeleteResult() {
    if (widget.viewModel.deleteWorkspaceUser.completed) {
      widget.viewModel.deleteWorkspaceUser.clearResult();
      AppToast.showSuccess(
        context: context,
        message: context.localization.workspaceUsersManagementDeleteUserSuccess,
      );
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pop(); // Close bottom sheet
    }

    if (widget.viewModel.deleteWorkspaceUser.error) {
      widget.viewModel.deleteWorkspaceUser.clearResult();
      AppToast.showError(
        context: context,
        message: context.localization.workspaceUsersManagementDeleteUserError,
      );
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pop(); // Close bottom sheet
    }
  }
}
