import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n_extensions.dart';
import '../../theme/colors.dart';
import '../app_field_button.dart';
import '../app_filled_button.dart';
import '../app_modal_bottom_sheet.dart';
import '../app_text_button.dart';

class AppDatePickerField extends StatefulWidget {
  const AppDatePickerField({
    super.key,
    required this.onSelected,
    required this.onCleared,
    required this.label,
    this.required = true,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
  });

  final void Function(DateTime date) onSelected;
  final void Function() onCleared;
  final String label;
  final bool required;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  DateTime? _selectedDate;

  void _clearSelections() {
    setState(() {
      // Clear local state
      _selectedDate = null;
      // Clear caller state
      widget.onCleared();
    });
  }

  void _onSubmit(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDateSelected = _selectedDate != null;

    Widget? trailing;
    if (isDateSelected) {
      trailing = InkWell(
        onTap: _clearSelections,
        child: const FaIcon(
          FontAwesomeIcons.solidCircleXmark,
          color: AppColors.black1,
          size: 17,
        ),
      );
    }

    return AppFieldButton(
      required: widget.required,
      label: widget.label,
      isFieldFocused: isDateSelected,
      onTap: () => _openDatePicker(context),
      trailing: trailing,
      child: _selectedDate != null
          ? Text(
              DateFormat.yMd(
                Localizations.localeOf(context).toString(),
              ).format(_selectedDate!),
            )
          : const SizedBox.shrink(),
    );
  }

  void _openDatePicker(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      child: _AppDatePicker(
        selectedDate: _selectedDate,
        onSubmit: _onSubmit,
        initialDateTime: widget.initialDateTime,
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
      ),
    );
  }
}

class _AppDatePicker extends StatefulWidget {
  const _AppDatePicker({
    required this.selectedDate,
    required this.onSubmit,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
  });

  final DateTime? selectedDate;
  final void Function(DateTime date) onSubmit;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<_AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<_AppDatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void _onDateTimeChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _onClose() {
    context.pop();
  }

  void _onSubmit() {
    widget.onSubmit(_selectedDate);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 216,
          child: CupertinoDatePicker(
            initialDateTime: widget.initialDateTime,
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            showDayOfWeek: true,
            onDateTimeChanged: _onDateTimeChanged,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            AppFilledButton(
              onPress: _onSubmit,
              label: context.localization.misc_submit,
            ),
            AppTextButton(
              onPress: _onClose,
              label: context.localization.misc_close,
            ),
          ],
        ),
      ],
    );
  }
}
