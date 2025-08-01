import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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
    final formattedDate = DateFormat.yMd(
      Localizations.localeOf(context).toString(),
    ).format(dueDate);

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
