import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/colors.dart';

class TaskDueDate extends StatelessWidget {
  const TaskDueDate({
    super.key,
    required this.dueDate,
    required this.appLocale,
  });

  final DateTime dueDate;
  final Locale appLocale;

  @override
  Widget build(BuildContext context) {
    final formattedDatetime =
        '${DateFormat.yMd(Localizations.localeOf(context).toString()).format(dueDate)} ${DateFormat.Hm(Localizations.localeOf(context).toString()).format(dueDate)}';

    return Row(
      spacing: 8,
      children: [
        const FaIcon(
          FontAwesomeIcons.clock,
          size: 16,
          color: AppColors.purple1Light,
        ),
        Text(
          formattedDatetime,
          style: Theme.of(
            context,
          ).textTheme.labelMedium!.copyWith(color: AppColors.purple1Light),
        ),
      ],
    );
  }
}
