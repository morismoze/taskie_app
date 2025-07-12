import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n_extensions.dart';
import 'app_field_button.dart';
import 'app_filled_button.dart';
import 'app_modal_bottom_sheet.dart';
import 'app_text_button.dart';

class AppDatePickerField extends StatefulWidget {
  const AppDatePickerField({
    super.key,
    required this.onSelected,
    required this.label,
    this.required = true,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
  });

  final void Function(DateTime date) onSelected;
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
      _selectedDate = null;
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

    return AppFieldButton(
      label: widget.required
          ? widget.label
          : '${widget.label} (${context.localization.optional})',
      isFieldFocused: isDateSelected,
      onTap: () => _openDatePicker(context),
      trailingIcon: _selectedDate != null
          ? FontAwesomeIcons.solidCircleXmark
          : null,
      onTrailingIconPress: _clearSelections,
      child: _selectedDate != null
          ? Text(DateFormat.yMd().format(_selectedDate!))
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
    Navigator.of(context).pop();
  }

  void _onSubmit() {
    widget.onSubmit(_selectedDate);
    Navigator.of(context).pop();
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
            // This is called when the user changes the date.
            onDateTimeChanged: _onDateTimeChanged,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            AppFilledButton(
              onPress: _onSubmit,
              label: context.localization.submit,
            ),
            AppTextButton(onPress: _onClose, label: context.localization.close),
          ],
        ),
      ],
    );
  }
}
