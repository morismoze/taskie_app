import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/repositories/auth/exceptions/refresh_token_failed_exception.dart';
import '../../../../routing/routes.dart';
import '../../../../utils/command.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/app_toast.dart';
import '../../app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import '../view_models/app_drawer_viewmodel.dart';
import 'footer.dart';
import 'workspaces_list.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.changeActiveWorkspace.addListener(
      _onActiveWorkspaceChangeResult,
    );
    widget.viewModel.leaveWorkspace.addListener(_onWorkspaceLeaveResult);
  }

  @override
  void didUpdateWidget(covariant AppDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.changeActiveWorkspace.removeListener(
      _onActiveWorkspaceChangeResult,
    );
    oldWidget.viewModel.leaveWorkspace.removeListener(_onWorkspaceLeaveResult);
    widget.viewModel.changeActiveWorkspace.addListener(
      _onActiveWorkspaceChangeResult,
    );
    widget.viewModel.leaveWorkspace.addListener(_onWorkspaceLeaveResult);
  }

  @override
  void dispose() {
    widget.viewModel.changeActiveWorkspace.removeListener(
      _onActiveWorkspaceChangeResult,
    );
    widget.viewModel.leaveWorkspace.removeListener(_onWorkspaceLeaveResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Dimens.paddingVertical * 2,
            bottom: kAppBottomNavigationBarHeight + Dimens.paddingVertical / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.paddingHorizontal,
                ),
                child: Text(
                  context.localization.appDrawerTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: Dimens.paddingVertical / 1.25),
              WorkspacesList(viewModel: widget.viewModel),
              Footer(viewModel: widget.viewModel),
            ],
          ),
        ),
      ),
    );
  }

  void _onActiveWorkspaceChangeResult() {
    if (widget.viewModel.changeActiveWorkspace.completed) {
      // Re-navigate to the same screen, but with different workspaceId path param
      // Using context.go so previous workspaceId tasks screen is not reachable.
      final newActiveWorkspaceId =
          (widget.viewModel.changeActiveWorkspace.result as Ok<String>).value;
      widget.viewModel.changeActiveWorkspace.clearResult();
      AppToast.showSuccess(
        context: context,
        message: context.localization.appDrawerChangeActiveWorkspaceSuccess,
      );
      context.go(Routes.tasks(workspaceId: newActiveWorkspaceId));
    }

    if (widget.viewModel.changeActiveWorkspace.error) {
      widget.viewModel.changeActiveWorkspace.clearResult();
      AppToast.showError(
        context: context,
        message: context.localization.appDrawerChangeActiveWorkspaceError,
      );
    }
  }

  void _onWorkspaceLeaveResult() {
    if (widget.viewModel.leaveWorkspace.completed) {
      final result =
          (widget.viewModel.leaveWorkspace.result as Ok<LeaveWorkspaceResult>)
              .value;
      widget.viewModel.leaveWorkspace.clearResult();
      AppToast.showSuccess(
        context: context,
        message: context.localization.appDrawerLeaveWorkspaceSuccess,
      );

      switch (result) {
        case LeaveWorkspaceResultNoAction():
          break;
        case LeaveWorkspaceResultCloseOverlays():
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Close bottom sheet
          break;
        case LeaveWorkspaceResultNavigateTo(workspaceId: final workspaceId):
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Close bottom sheet
          context.go(Routes.tasks(workspaceId: workspaceId));
      }
    }

    if (widget.viewModel.leaveWorkspace.error) {
      final errorResult = widget.viewModel.leaveWorkspace.result as Error;
      widget.viewModel.leaveWorkspace.clearResult();

      switch (errorResult.error) {
        case RefreshTokenFailedException():
          AppToast.showError(
            context: context,
            message: context.localization.appDrawerLeaveWorkspaceError,
          );
          Navigator.of(context).pop(); // Close dialog
          break;
        default:
          AppToast.showError(
            context: context,
            message: context.localization.appDrawerLeaveWorkspaceError,
          );
          Navigator.of(context).pop(); // Close dialog
      }
    }
  }
}
