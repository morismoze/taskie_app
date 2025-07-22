import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n_extensions.dart';
import '../../theme/colors.dart';
import '../../theme/dimens.dart';
import '../app_checkbox.dart';
import '../app_field_button.dart';
import '../app_filled_button.dart';
import '../app_modal_bottom_sheet.dart';
import '../app_text_button.dart';
import '../blocked_info_icon.dart';

class AppSelectFieldOption {
  const AppSelectFieldOption({
    required this.label,
    required this.value,
    this.leading,
  });

  final String label;
  final Object value;
  final Widget? leading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

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
    required this.label,
    this.multiple = false,
    this.required = true,
    this.enabled = true,
    this.initialValue,
    this.disabledWidgetTrailingTooltipMessage,
  });

  final List<AppSelectFieldOption> options;
  final void Function(List<AppSelectFieldOption> selectedOptions) onSelected;
  final String label;

  /// Defines if this a multiple option selection field.
  final bool multiple;
  final bool required;
  final bool enabled;
  final List<AppSelectFieldOption>? initialValue;
  final String? disabledWidgetTrailingTooltipMessage;

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
      _selectedOptions.clear();
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

    Widget? trailing;
    if (!widget.enabled) {
      trailing = widget.disabledWidgetTrailingTooltipMessage != null
          ? BlockedInfoIcon(
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
            size: 15,
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
      isScrollControlled: widget.options.length > 3,
      shrinkWrap: false,
      child: _AppSelectFieldOptions(
        options: widget.options,
        selectedOptions: _selectedOptions,
        onSubmit: _onSubmit,
        multiple: widget.multiple,
      ),
    );
  }
}

class _AppSelectFieldOptions extends StatefulWidget {
  const _AppSelectFieldOptions({
    required this.options,
    required this.selectedOptions,
    required this.onSubmit,
    required this.multiple,
  });

  final List<AppSelectFieldOption> options;
  final List<AppSelectFieldOption> selectedOptions;
  final void Function(List<AppSelectFieldOption>) onSubmit;
  final bool multiple;

  @override
  State<_AppSelectFieldOptions> createState() => _AppSelectFieldOptionsState();
}

class _AppSelectFieldOptionsState extends State<_AppSelectFieldOptions> {
  late List<AppSelectFieldOption> _selectedOptions;

  @override
  void initState() {
    super.initState();
    // We need to copy values from the given list and not assign it directly
    // beacuse we would change direct reference (the given list).
    _selectedOptions = List.from(widget.selectedOptions);
  }

  void _onOptionTap(AppSelectFieldOption option) {
    setState(() {
      if (widget.multiple) {
        if (_selectedOptions.contains(option)) {
          _selectedOptions.remove(option);
        } else {
          _selectedOptions.add(option);
        }
      } else {
        if (!_selectedOptions.contains(option)) {
          _selectedOptions.clear();
          _selectedOptions.add(option);
        }
      }
    });
  }

  void _onClose() {
    context.pop();
  }

  void _onSubmit() {
    widget.onSubmit(_selectedOptions);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: widget.options.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: Dimens.paddingVertical / 2),
            itemBuilder: (_, index) {
              final option = widget.options[index];

              return ListTile(
                leading: option.leading,
                title: Text(option.label),
                trailing: AppCheckbox(
                  isChecked: _selectedOptions.contains(option),
                ),
                onTap: () => _onOptionTap(option),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
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
