import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_text_field/app_text_field.dart';
import '../../core/utils/intl.dart';
import '../../core/utils/user.dart';
import '../view_models/goal_details_edit_screen_view_model.dart';

class GoalDetailsMeta extends StatefulWidget {
  const GoalDetailsMeta({super.key, required this.viewModel});

  final GoalDetailsEditScreenViewModel viewModel;

  @override
  State<GoalDetailsMeta> createState() => _GoalDetailsMetaState();
}

class _GoalDetailsMetaState extends State<GoalDetailsMeta> {
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createdByController.text = widget.viewModel.details!.createdBy != null
        ? UserUtils.constructFullName(
            firstName: widget.viewModel.details!.createdBy!.firstName,
            lastName: widget.viewModel.details!.createdBy!.lastName,
          )
        : context.localization.goalsDetailsEditCreatedByDeletedAccount;
    _createdAtController.text = IntlUtils.mapDateTimeToLocalTimeZoneFormat(
      context,
      widget.viewModel.details!.createdAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _createdByController,
          label: context.localization.goalsDetailsEditCreatedBy,
          readOnly: true,
          suffixIcon: FaIcon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).colorScheme.secondary,
            size: 15,
          ),
        ),
        AppTextField(
          controller: _createdAtController,
          label: context.localization.goalsDetailsEditCreatedAt,
          readOnly: true,
          suffixIcon: FaIcon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).colorScheme.secondary,
            size: 15,
          ),
        ),
      ],
    );
  }
}
