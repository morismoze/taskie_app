import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_select_field.dart';

class AppSelectFormField extends FormField<List<AppSelectFieldOption>> {
  AppSelectFormField({
    super.key,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    required List<AppSelectFieldOption> options,
    required String label,
    required void Function(List<AppSelectFieldOption>) onSelected,
    bool multiple = false,
    bool required = true,
    String? disabledWidgetTrailingTooltipMessage,
  }) : super(
         builder: (FormFieldState<List<AppSelectFieldOption>> state) {
           final context = state.context;
           final errorText = state.errorText;

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
                 },
                 initialValue: initialValue,
                 enabled: enabled,
                 disabledWidgetTrailingTooltipMessage:
                     disabledWidgetTrailingTooltipMessage,
               ),
               Padding(
                 padding: EdgeInsets.only(
                   top: 2,
                   left: AppTheme.fieldInnerPadding,
                 ),
                 child: Text(
                   errorText ?? '',
                   style: TextStyle(
                     color: Theme.of(context).colorScheme.error,
                     fontSize: 14,
                   ),
                 ),
               ),
             ],
           );
         },
       );
}
