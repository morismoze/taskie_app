import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_text_field/app_text_field.dart';
import '../../core/utils/intl.dart';
import '../../core/utils/user.dart';
import '../view_models/task_details_edit_screen_view_model.dart';

class TaskDetailsMeta extends StatefulWidget {
  const TaskDetailsMeta({super.key, required this.viewModel});

  final TaskDetailsEditScreenViewModel viewModel;

  @override
  State<TaskDetailsMeta> createState() => _TaskDetailsMetaState();
}

class _TaskDetailsMetaState extends State<TaskDetailsMeta> {
  bool _isInit = true; // First init flag
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _createdByController.text = widget.viewModel.details!.createdBy != null
          ? UserUtils.constructFullName(
              firstName: widget.viewModel.details!.createdBy!.firstName,
              lastName: widget.viewModel.details!.createdBy!.lastName,
            )
          : context.localization.tasksDetailsEditCreatedByDeletedAccount;
      _createdAtController.text = IntlUtils.mapDateTimeToLocalTimeZoneFormat(
        context,
        widget.viewModel.details!.createdAt,
      );
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _createdByController,
          label: context.localization.tasksDetailsEditCreatedBy,
          readOnly: true,
          suffixIcon: FaIcon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).colorScheme.secondary,
            size: 15,
          ),
        ),
        AppTextField(
          controller: _createdAtController,
          label: context.localization.tasksDetailsEditCreatedAt,
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
