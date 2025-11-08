import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../theme/colors.dart';
import '../../theme/dimens.dart';
import '../action_button_bar.dart';
import '../app_field_button.dart';
import '../app_modal_bottom_sheet.dart';

class AppDatePickerField extends StatefulWidget {
  const AppDatePickerField({
    super.key,
    required this.onSelected,
    required this.onCleared,
    required this.label,
    this.required = true,
    this.readOnly = false,
    this.initialValue,
    this.minimumDate,
    this.maximumDate,
  });

  final void Function(DateTime selectedDate) onSelected;
  final void Function() onCleared;
  final String label;
  final bool required;
  final bool readOnly;
  final DateTime? initialValue;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _selectedDate = widget.initialValue!;
    }
    super.initState();
  }

  void _clearSelections() {
    setState(() {
      // Clear local state
      _selectedDate = null;
      // Clear caller state
      widget.onCleared();
    });
  }

  void _onSubmit(DateTime date) {
    // Since this is date picker only (without time), the date is
    // in the device's local time without timezone offset. To be a
    // compliant full ISO 8601 string we have to add the zone offset.
    // In this case we are setting it to UTC, which will basically
    // take the date and append it midnight time and the `Z` (Zulu)
    // keyword - it won't change the date, but it will make compliant
    // datetime by adding the time.
    final utcDate = DateTime.utc(date.year, date.month, date.day);

    setState(() {
      _selectedDate = utcDate;
    });
    widget.onSelected(utcDate);
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
      onTap: widget.readOnly ? () {} : () => _openDatePicker(context),
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
        initialValue: widget.initialValue,
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
    this.initialValue,
    this.minimumDate,
    this.maximumDate,
  });

  final DateTime? selectedDate;
  final void Function(DateTime date) onSubmit;
  final DateTime? initialValue;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<_AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<_AppDatePicker> {
  DateTime _selectedDate = DateTime.now();

  void _onDateTimeChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _onCancel() {
    context.pop();
  }

  void _onSubmit() {
    widget.onSubmit(_selectedDate);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    var minimumDate = widget.minimumDate;

    // [initialDateTime] property must be inside the datetime interval defined
    // by [minimumDate] and [maximumDate] properties.
    // A task can have a `dueDate` which has maybe passed on the current DateTime,
    // meaning it can fall out of the lower [minimumDate] limit. In this case we
    // will make `dueDate` the [minimumDate] limit.
    if (widget.initialValue != null &&
        minimumDate != null &&
        widget.initialValue!.isBefore(minimumDate)) {
      minimumDate = widget.initialValue;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 216,
          child: CupertinoDatePicker(
            initialDateTime: widget.initialValue,
            minimumDate: minimumDate,
            maximumDate: widget.maximumDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            showDayOfWeek: true,
            onDateTimeChanged: _onDateTimeChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.paddingVertical / 2,
          ),
          child: ActionButtonBar(onSubmit: _onSubmit, onCancel: _onCancel),
        ),
      ],
    );
  }
}
