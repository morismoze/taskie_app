import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_select_field.dart';

class AppSelectFormField<T> extends FormField<List<AppSelectFieldOption<T>>> {
  AppSelectFormField({
    super.key,
    super.validator,
    super.enabled,
    required List<AppSelectFieldOption<T>> options,
    required String label,
    required void Function(List<AppSelectFieldOption<T>> selectedOptions)
    onChanged,
    List<AppSelectFieldOption<T>> value = const [],
    bool multiple = false,
    bool required = true,
    final void Function()? onCleared,
    int? max,
    Widget? trailing,
  }) : super(
         initialValue: value,
         builder: (FormFieldState<List<AppSelectFieldOption<T>>> state) {
           final context = state.context;
           final errorText = state.errorText;
           final selectedCount = state.value?.length ?? 0;
           final counterText = max != null ? '$selectedCount/$max' : null;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               AppSelectField<T>(
                 options: options,
                 label: label,
                 multiple: multiple,
                 required: required,
                 onChanged: (selected) {
                   state.didChange(selected);
                   onChanged(selected);
                   state.validate();
                 },
                 onCleared: onCleared != null
                     ? () {
                         state.didChange([]);
                         onCleared();
                         state.validate();
                       }
                     : null,
                 value: state.value ?? [],
                 enabled: enabled,
                 max: max,
                 trailing: trailing,
               ),
               Padding(
                 padding: EdgeInsets.only(
                   top: 2,
                   left: AppTheme.fieldInnerPadding,
                   right: AppTheme.fieldInnerPadding,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(
                       child: Text(
                         errorText ?? '',
                         style: TextStyle(
                           color: Theme.of(context).colorScheme.error,
                           fontSize: 14,
                         ),
                       ),
                     ),
                     if (multiple && counterText != null)
                       Text(
                         counterText,
                         style: Theme.of(context).textTheme.labelMedium,
                       ),
                   ],
                 ),
               ),
             ],
           );
         },
       );

  /// Single-selection select field
  factory AppSelectFormField.single({
    Key? key,
    String? Function(List<AppSelectFieldOption<T>>?)? validator,
    bool enabled = true,
    required List<AppSelectFieldOption<T>> options,
    required String label,
    AppSelectFieldOption<T>? value,
    required void Function(AppSelectFieldOption<T> selectedOption) onChanged,
    void Function()? onCleared,
    bool required = true,
    bool isSubmitLoading = false,
    Widget? trailing,
  }) {
    return AppSelectFormField<T>(
      key: key,
      validator: validator,
      enabled: enabled,
      options: options,
      label: label,
      onChanged: (selectedList) {
        if (selectedList.isNotEmpty) {
          onChanged(selectedList.first);
        }
      },
      multiple: false,
      required: required,
      onCleared: onCleared,
      value: value != null ? [value] : [],
      trailing: trailing,
    );
  }
}
