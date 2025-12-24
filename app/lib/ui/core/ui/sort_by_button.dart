import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_filled_button.dart';
import 'app_modal_bottom_sheet.dart';
import 'app_modal_bottom_sheet_content_wrapper.dart';
import 'app_select_field/app_select_field.dart';
import 'app_select_field/app_select_field_options.dart';

class SortByButton extends StatefulWidget {
  const SortByButton({
    super.key,
    required this.title,
    required this.options,
    required this.activeValue,
    required this.onSubmit,
  });

  final String title;
  final List<AppSelectFieldOption> options;
  final AppSelectFieldOption activeValue;
  final void Function(AppSelectFieldOption selectedOption) onSubmit;

  @override
  State<SortByButton> createState() => _SortByButtonState();
}

class _SortByButtonState extends State<SortByButton> {
  late List<AppSelectFieldOption> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List.from([widget.activeValue]);
  }

  void _onSubmit(List<AppSelectFieldOption> selectedOptions) {
    // All sort selectors are single value
    final selectedOption = selectedOptions[0];
    setState(() {
      _selectedOptions = [selectedOption];
    });
    widget.onSubmit(selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    return AppFilledButton(
      shrinkWrap: true,
      fontSize: 13,
      trailingIcon: FontAwesomeIcons.sort,
      onPress: () => _openSortByTime(
        context,
        widget.title,
        widget.options,
        _selectedOptions,
      ),
      label: widget.activeValue.label,
    );
  }

  void _openSortByTime(
    BuildContext context,
    String title,
    List<AppSelectFieldOption> options,
    List<AppSelectFieldOption> selectedOptions,
  ) {
    AppModalBottomSheet.show(
      context: context,
      isScrollControlled: true,
      child: AppModalBottomSheetContentWrapper(
        title: title,
        child: AppSelectFieldOptions(
          options: options,
          value: selectedOptions,
          onSubmit: _onSubmit,
        ),
      ),
    );
  }
}
