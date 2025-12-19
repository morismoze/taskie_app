import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/colors.dart';
import '../app_modal_bottom_sheet.dart';
import 'app_select_field_options.dart';
import 'app_select_field_selected_options.dart';

class AppSelectFieldOption<T> {
  const AppSelectFieldOption({
    required this.label,
    required this.value,
    this.leading,
  });

  final String label;
  final T value;
  final Widget? leading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppSelectFieldOption<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// When field is set as disabled ([enabled] = false), a info trailing
/// icon with tooltip will be added automatically if [disabledWidgetTrailingTooltipMessage]
/// is passed.
class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.options,
    required this.onChanged,
    required this.label,
    this.value = const [],
    this.onCleared,
    this.multiple = true,
    this.required = true,
    this.enabled = true,
    this.isSubmitLoading = false,
    this.max,
    this.trailing,
  });

  /// Single-selection select field
  factory AppSelectField.single({
    Key? key,
    required List<AppSelectFieldOption<T>> options,
    required String label,
    AppSelectFieldOption<T>? value,
    required void Function(AppSelectFieldOption<T> selectedOption) onChanged,
    void Function()? onCleared,
    bool required = true,
    bool enabled = true,
    bool isSubmitLoading = false,
    Widget? trailing,
  }) {
    return AppSelectField<T>(
      key: key,
      options: options,
      onChanged: (selectedOptions) {
        if (selectedOptions.isNotEmpty) {
          onChanged(selectedOptions.first);
        }
      },
      label: label,
      multiple: false,
      required: required,
      enabled: enabled,
      isSubmitLoading: isSubmitLoading,
      onCleared: onCleared,
      trailing: trailing,
      value: value != null ? [value] : [],
    );
  }

  final List<AppSelectFieldOption<T>> options;
  final void Function(List<AppSelectFieldOption<T>> selectedOptions) onChanged;
  final String label;

  final List<AppSelectFieldOption<T>> value;

  /// Defines if this is a multiple option selection field.
  final bool multiple;
  final bool required;
  final bool enabled;
  final bool isSubmitLoading;

  /// 'Clear" trailing icon will be displayed if this method is passed
  /// (and if the field is enabled).
  final void Function()? onCleared;

  /// Defines how many options can be selected when [multiple] is true.
  final int? max;

  /// This is mostly used in disabled state.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final hasSelection = value.isNotEmpty;

    Widget? trailingWidget =
        trailing ??
        const FaIcon(FontAwesomeIcons.sort, color: AppColors.black1, size: 17);
    // Clearing is enabled if:
    // 1. field is enabled
    // 2. `onCleared` was passed
    if (enabled && onCleared != null && hasSelection) {
      // Clear selections icon
      trailingWidget = InkWell(
        onTap: onCleared,
        child: const FaIcon(
          FontAwesomeIcons.solidCircleXmark,
          color: AppColors.black1,
          size: 17,
        ),
      );
    }

    return AppSelectFieldSelectedOptions(
      label: label,
      selectedOptions: value,
      isFieldFocused: hasSelection,
      onTap: () {
        if (enabled) {
          _openOptions(context);
        }
      },
      trailing: trailingWidget,
      enabled: enabled,
      required: required,
    );
  }

  void _openOptions(BuildContext context) {
    // Unfocus last field as this custom select field
    // does not "own" its own focus
    FocusManager.instance.primaryFocus?.unfocus();

    AppModalBottomSheet.show(
      context: context,
      isScrollControlled: true,
      child: AppSelectFieldOptions<T>(
        options: options,
        value: value,
        onSubmit: onChanged,
        multiple: multiple,
        max: max,
      ),
    );
  }
}
