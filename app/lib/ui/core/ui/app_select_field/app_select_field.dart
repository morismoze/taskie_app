import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/colors.dart';
import '../app_field_button.dart';
import '../app_modal_bottom_sheet.dart';
import '../info_icon_with_tooltip.dart';
import 'app_select_field_options.dart';

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
    this.disabledWidgetTrailingTooltipMessage,
    this.max,
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
  final String? disabledWidgetTrailingTooltipMessage;

  /// Defines how many options can be selected when [multiple] is true.
  final int? max;

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
      // Clear caller state
      widget.onCleared();
    });
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

    Widget? trailing = const FaIcon(
      FontAwesomeIcons.sort,
      color: AppColors.black1,
      size: 17,
    );
    if (!widget.enabled) {
      trailing = widget.disabledWidgetTrailingTooltipMessage != null
          ? InfoIconWithTooltip(
              message: widget.disabledWidgetTrailingTooltipMessage!,
            )
          : null;
    } else {
      if (hasSelection) {
        trailing = InkWell(
          onTap: _clearSelections,
          child: const FaIcon(
            FontAwesomeIcons.solidCircleXmark,
            color: AppColors.black1,
            size: 17,
          ),
        );
      }
    }

    return AppFieldButton(
      label: widget.label,
      required: widget.required,
      isFieldFocused: hasSelection,
      onTap: () {
        if (widget.enabled) {
          _openOptions(context);
        }
      },
      trailing: trailing,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: _selectedOptions
            .map(
              (option) => _AppSelectFieldSelectedOption(
                label: option.label,
                isFieldEnabled: widget.enabled,
              ),
            )
            .toList(),
      ),
    );
  }

  void _openOptions(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
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

class _AppSelectFieldSelectedOption extends StatelessWidget {
  const _AppSelectFieldSelectedOption({
    required this.label,
    this.isFieldEnabled = true,
  });

  final String label;
  final bool isFieldEnabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isFieldEnabled
                ? AppColors.grey2
                : Theme.of(context).disabledColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppColors.white1),
            ),
          ),
        ),
      ),
    );
  }
}
