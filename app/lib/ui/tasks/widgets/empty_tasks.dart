import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/utils/extensions.dart';
import '../../navigation/app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';

class EmptyTasks extends StatelessWidget {
  const EmptyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + kAppBottomNavigationBarHeight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FractionallySizedBox(
            widthFactor: 0.85,
            child: Image(image: AssetImage(Assets.emptyObjectivesIllustration)),
          ),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: context.localization.tasksNoTasks.format(
              style: Theme.of(context).textTheme.bodyMedium!,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
