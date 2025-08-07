import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/colors.dart';
import '../app_modal_bottom_sheet.dart';
import 'app_select_field_options.dart';
import 'app_select_field_selected_options.dart';

class AppSelectFieldOption {
  const AppSelectFieldOption({
    required this.label,
    required this.value,
    this.leading,
  });

  final String label;
  final Object? value;
  final Widget? leading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppSelectFieldOption && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// When field is set as disabled ([enabled] = false), a info trailing
/// icon with tooltip will be added automatically if [disabledWidgetTrailingTooltipMessage]
/// is passed.
class AppSelectField extends StatefulWidget {
  const AppSelectField({
    super.key,
    required this.options,
    required this.onSelected,
    required this.onCleared,
    required this.label,
    this.multiple = false,
    this.required = true,
    this.enabled = true,
    this.initialValue,
    this.max,
    this.trailing,
  });

  final List<AppSelectFieldOption> options;
  final void Function(List<AppSelectFieldOption> selectedOptions) onSelected;
  final void Function() onCleared;
  final String label;

  /// Defines if this is a multiple option selection field.
  final bool multiple;
  final bool required;
  final bool enabled;
  final List<AppSelectFieldOption>? initialValue;

  /// Defines how many options can be selected when [multiple] is true.
  final int? max;

  /// This is mostly used in disabled state.
  final Widget? trailing;

  @override
  State<AppSelectField> createState() => _AppSelectFieldState();
}

class _AppSelectFieldState extends State<AppSelectField> {
  late List<AppSelectFieldOption> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List.from(widget.initialValue ?? []);
  }

  void _clearSelections() {
    setState(() {
      // Clear local state
      _selectedOptions.clear();
    });
    widget.onCleared();
  }

  void _onSubmit(List<AppSelectFieldOption> options) {
    setState(() {
      _selectedOptions = options;
    });
    widget.onSelected(_selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedOptions.isNotEmpty;

    Widget? trailing =
        widget.trailing ??
        const FaIcon(FontAwesomeIcons.sort, color: AppColors.black1, size: 17);
    if (widget.enabled && hasSelection) {
      // Clear selections icon
      trailing = InkWell(
        onTap: _clearSelections,
        child: const FaIcon(
          FontAwesomeIcons.solidCircleXmark,
          color: AppColors.black1,
          size: 17,
        ),
      );
    }

    return AppSelectFieldSelectedOptions(
      label: widget.label,
      selectedOptions: _selectedOptions,
      isFieldFocused: hasSelection,
      onTap: () {
        if (widget.enabled) {
          _openOptions(context);
        }
      },
      trailing: trailing,
      enabled: widget.enabled,
      required: widget.required,
    );
  }

  void _openOptions(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      isScrollControlled: true,
      child: AppSelectFieldOptions(
        options: widget.options,
        selectedOptions: _selectedOptions,
        onSubmit: _onSubmit,
        multiple: widget.multiple,
        max: widget.max,
      ),
    );
  }
}
