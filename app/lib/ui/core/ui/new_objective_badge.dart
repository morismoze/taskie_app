import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/colors.dart';

// Used on a a objective which was just created. New objectives
// are always shown at the top of the current objective list
// no matter the active list filtering.
class NewObjectiveBadge extends StatelessWidget {
  const NewObjectiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: AppColors.purple1Light,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      label: Row(
        spacing: 4,
        children: [
          FaIcon(
            FontAwesomeIcons.star,
            color: Theme.of(context).colorScheme.primary,
            size: 10,
          ),
          Text(
            context.localization.misc_new,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
