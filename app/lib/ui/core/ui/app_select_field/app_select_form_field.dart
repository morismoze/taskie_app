import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_select_field.dart';

class AppSelectFormField extends FormField<List<AppSelectFieldOption>> {
  AppSelectFormField({
    super.key,
    super.validator,
    super.enabled,
    super.initialValue,
    required List<AppSelectFieldOption> options,
    required String label,
    required void Function(List<AppSelectFieldOption> selectedOptions)
    onSelected,
    required final void Function() onCleared,
    bool multiple = false,
    bool required = true,
    bool isScrollControlled = false,
    int? max,
    Widget? trailing,
  }) : super(
         builder: (FormFieldState<List<AppSelectFieldOption>> state) {
           final context = state.context;
           final errorText = state.errorText;
           final selectedCount = state.value?.length ?? 0;
           final counterText = max != null ? '$selectedCount/$max' : null;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               AppSelectField(
                 options: options,
                 label: label,
                 multiple: multiple,
                 required: required,
                 onSelected: (selected) {
                   state.didChange(selected);
                   onSelected(selected);
                   state.validate();
                 },
                 onCleared: () {
                   state.didChange([]);
                   onCleared();
                   state.validate();
                 },
                 initialValue: initialValue,
                 enabled: enabled,
                 max: max,
                 isScrollControlled: isScrollControlled,
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
}
