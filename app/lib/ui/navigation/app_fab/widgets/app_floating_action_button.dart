import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/constants/rbac.dart';
import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/app_filled_button.dart';
import '../../../core/ui/app_modal_bottom_sheet.dart';
import '../../../core/ui/rbac.dart';
import '../view_models/app_floating_action_button_view_model.dart';

const double kAppFloatingActionButtonSize = 56.0;

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({super.key, required this.viewModel});

  final AppFloatingActionButtonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Rbac(
      permission: RbacPermission.objectiveCreate,
      child: SizedBox(
        width: kAppFloatingActionButtonSize,
        height: kAppFloatingActionButtonSize,
        child: FloatingActionButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kAppFloatingActionButtonSize),
          ),
          onPressed: () => _onPressed(context),
          child: const FaIcon(FontAwesomeIcons.plus, size: 18),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      isDetached: true,
      child: Column(
        spacing: 12,
        children: [
          AppFilledButton(
            label: context.localization.taskCreateNew,
            onPress: () {
              context.pop(); // Close bottom sheet
              context.push(
                Routes.taskCreate(workspaceId: viewModel.activeWorkspaceId),
              );
            },
          ),
          AppFilledButton(
            label: context.localization.goalCreateNew,
            onPress: () {
              context.pop(); // Close bottom sheet
              context.push(
                Routes.goalCreate(workspaceId: viewModel.activeWorkspaceId),
              );
            },
          ),
        ],
      ),
    );
  }
}
