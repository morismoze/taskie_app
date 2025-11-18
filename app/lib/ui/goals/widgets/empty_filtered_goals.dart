import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';

class EmptyFilteredGoals extends StatelessWidget {
  const EmptyFilteredGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Text(
            context.localization.goalsNoFilteredGoals,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
