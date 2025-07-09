import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import '../core/l10n/l10n_extensions.dart';
import '../core/ui/app_filled_button.dart';
import '../core/ui/app_modal_bottom_sheet.dart';
import '../core/util/constants.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kAppFloatingActionButtonSize,
      height: kAppFloatingActionButtonSize,
      child: FloatingActionButton(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () => _onPressed(context),
        child: const FaIcon(FontAwesomeIcons.plus, size: 18),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      isDetached: true,
      child: Column(
        children: [
          AppFilledButton(
            label: context.localization.bottomNavigationBarFabTask,
            onPress: () {
              Navigator.of(context).pop(); // Close bottom sheet
              context.push(Routes.tasksCreate);
            },
          ),
          const SizedBox(height: 15),
          AppFilledButton(
            label: context.localization.bottomNavigationBarFabGoal,
            onPress: () {
              Navigator.of(context).pop(); // Close bottom sheet
              context.push(Routes.goalsCreate);
            },
          ),
        ],
      ),
    );
  }
}
