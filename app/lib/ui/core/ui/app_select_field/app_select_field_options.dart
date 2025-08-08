import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n_extensions.dart';
import '../../theme/dimens.dart';
import '../app_checkbox.dart';
import '../app_filled_button.dart';
import '../app_text_button.dart';
import 'app_select_field.dart';

class AppSelectFieldOptions<T> extends StatefulWidget {
  const AppSelectFieldOptions({
    super.key,
    required this.options,
    required this.value,
    required this.onSubmit,
    this.multiple = false,
    this.isSubmitLoading = false,
    this.max,
  });

  final List<AppSelectFieldOption<T>> options;
  final List<AppSelectFieldOption<T>> value;
  final void Function(List<AppSelectFieldOption<T>>) onSubmit;
  final bool multiple;
  final bool isSubmitLoading;
  final int? max;

  @override
  State<AppSelectFieldOptions<T>> createState() =>
      _AppSelectFieldOptionsState<T>();
}

class _AppSelectFieldOptionsState<T> extends State<AppSelectFieldOptions<T>> {
  late List<AppSelectFieldOption<T>> _selectedOptions;

  @override
  void initState() {
    super.initState();
    // We need to copy values from the given list and not assign it directly
    // beacuse we would change direct reference (the given list).
    _selectedOptions = List.from(widget.value);
  }

  void _onOptionTap(AppSelectFieldOption<T> option) {
    setState(() {
      if (widget.multiple) {
        if (_selectedOptions.contains(option)) {
          _selectedOptions.remove(option);
        } else {
          if (widget.max != null) {
            if (_selectedOptions.length < widget.max!) {
              _selectedOptions.add(option);
            }
          } else {
            _selectedOptions.add(option);
          }
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
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
        const SizedBox(height: Dimens.paddingVertical),
        Column(
          children: [
            AppFilledButton(
              onPress: _onSubmit,
              loading: widget.isSubmitLoading,
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
