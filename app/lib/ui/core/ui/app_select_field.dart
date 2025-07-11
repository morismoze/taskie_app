import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import 'app_checkbox.dart';
import 'app_filled_button.dart';
import 'app_modal_bottom_sheet.dart';
import 'app_text_button.dart';

class AppSelectFieldOption {
  const AppSelectFieldOption({
    required this.label,
    required this.value,
    this.leading,
  });

  final String label;
  final String value;
  final Widget? leading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSelectFieldOption && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class AppSelectField extends StatefulWidget {
  const AppSelectField({
    super.key,
    required this.options,
    required this.onSelected,
    required this.label,
    this.multiple = false,
  });

  final List<AppSelectFieldOption> options;
  final void Function(List<AppSelectFieldOption> selectedOptions) onSelected;
  final String label;

  /// Defines if this a multiple option selection field.
  final bool multiple;

  @override
  State<AppSelectField> createState() => _AppSelectFieldState();
}

class _AppSelectFieldState extends State<AppSelectField> {
  List<AppSelectFieldOption> _selectedOptions = [];

  void _onSubmit(List<AppSelectFieldOption> options) {
    setState(() {
      _selectedOptions = options;
    });
    widget.onSelected(_selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedOptions.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            _openOptions(context);
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.grey2.withValues(alpha: 0.075),
            ),
          ),
        ),
        Positioned(
          top: hasSelection ? -10 : 17,
          left: 16,
          child: IgnorePointer(
            child: Text(
              widget.label,
              style: TextStyle(
                color: hasSelection
                    ? AppColors.grey2
                    : AppColors.grey2.withValues(alpha: 0.5),
                fontSize: hasSelection ? 14 : 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openOptions(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      isScrollControlled: true,
      child: UsersList(
        options: widget.options,
        selectedOptions: _selectedOptions,
        onSubmit: _onSubmit,
        multiple: widget.multiple,
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  const UsersList({
    super.key,
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
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
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
    Navigator.of(context).pop();
  }

  void _onSubmit() {
    widget.onSubmit(_selectedOptions);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: widget.options.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: Dimens.paddingVertical / 1.75),
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
          const SizedBox(height: 40),
          Column(
            children: [
              AppFilledButton(
                onPress: _onSubmit,
                label: context.localization.submit,
              ),
              const SizedBox(height: 8),
              AppTextButton(
                onPress: _onClose,
                label: context.localization.close,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
