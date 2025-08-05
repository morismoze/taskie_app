import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'app_date_picker_field.dart';

class AppDatePickerFormField extends FormField<DateTime> {
  AppDatePickerFormField({
    super.key,
    super.validator,
    super.initialValue,
    required String label,
    required void Function(DateTime selectedDate) onSelected,
    required void Function() onCleared,
    bool required = true,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           final context = state.context;
           final errorText = state.errorText;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               AppDatePickerField(
                 label: label,
                 onSelected: (selected) {
                   state.didChange(selected);
                   onSelected(selected);
                   state.validate();
                 },
                 onCleared: () {
                   if (!required) {
                     state.didChange(null);
                     onCleared();
                     state.validate();
                   }
                 },
                 initialValue: initialValue,
                 minimumDate: minimumDate,
                 maximumDate: maximumDate,
                 required: required,
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
