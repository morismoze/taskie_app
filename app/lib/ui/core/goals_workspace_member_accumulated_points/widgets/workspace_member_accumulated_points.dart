import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_user.dart';
import '../../../../utils/command.dart';
import '../../l10n/l10n_extensions.dart';
import '../../ui/activity_indicator.dart';
import '../../ui/app_text_button.dart';

class WorkspaceMemberAccumulatedPoints extends StatelessWidget {
  const WorkspaceMemberAccumulatedPoints({
    super.key,
    required this.selectedAssignee,
    required this.loadAccumulatedPointsCommand,
    required this.workspaceUserAccumulatedPointsNotifier,
  });

  final WorkspaceUser selectedAssignee;
  final Command1<void, String> loadAccumulatedPointsCommand;
  final ValueListenable<int?> workspaceUserAccumulatedPointsNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: loadAccumulatedPointsCommand,
      builder: (builderContext, child) {
        if (loadAccumulatedPointsCommand.running) {
          return ActivityIndicator(
            radius: 10,
            color: Theme.of(builderContext).colorScheme.primary,
          );
        }

        if (loadAccumulatedPointsCommand.error) {
          return Text.rich(
            TextSpan(
              text:
                  '${builderContext.localization.goalRequiredPointsCurrentAccumulatedPointsError} ',
              style: Theme.of(builderContext).textTheme.labelMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: AppTextButton(
                    underline: true,
                    onPress: () => loadAccumulatedPointsCommand.execute(
                      selectedAssignee.id,
                    ),
                    label: builderContext.localization.misc_tryAgain,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          );
        }

        return child!;
      },
      child: ValueListenableBuilder(
        valueListenable: workspaceUserAccumulatedPointsNotifier,
        builder: (innerBuilderContext, workspaceUserAccumulatedPointsvalue, _) {
          final fullName =
              '${selectedAssignee.firstName} ${selectedAssignee.lastName}';

          return Text.rich(
            textAlign: TextAlign.left,
            TextSpan(
              text:
                  '${innerBuilderContext.localization.goalRequiredPointsCurrentAccumulatedPoints} ',
              style: Theme.of(innerBuilderContext).textTheme.labelMedium!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.normal),
              children: [
                TextSpan(
                  text: '$fullName: ',
                  style: Theme.of(innerBuilderContext).textTheme.labelMedium!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: workspaceUserAccumulatedPointsvalue.toString(),
                  style: Theme.of(innerBuilderContext).textTheme.labelMedium!
                      .copyWith(
                        fontSize: 15,
                        color: Theme.of(
                          innerBuilderContext,
                        ).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
