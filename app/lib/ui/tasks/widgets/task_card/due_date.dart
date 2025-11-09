import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/intl.dart';

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
    final formattedDate = IntlUtils.mapDateTimeToLocalTimeZoneFormat(
      context,
      dueDate,
    );

    return Row(
      spacing: 5,
      children: [
        FaIcon(
          FontAwesomeIcons.clock,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          formattedDate,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
