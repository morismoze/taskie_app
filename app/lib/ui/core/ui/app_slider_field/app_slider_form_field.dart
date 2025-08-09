import 'package:flutter/material.dart';

import '../../theme//theme.dart';
import 'app_slider_field.dart';

class AppSliderFormField extends FormField<double> {
  AppSliderFormField({
    super.key,
    super.validator,
    super.autovalidateMode,
    required String label,
    required double value,
    required void Function(double) onChanged,
    required double min,
    required double max,
    required int step,
    bool required = true,
    bool readOnly = false,
  }) : super(
         builder: (FormFieldState<double> state) {
           final context = state.context;
           final errorText = state.errorText;

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               AppSliderField(
                 label: label,
                 value: value,
                 onChanged: (value) {
                   state.didChange(value);
                   onChanged(value);
                 },
                 step: step,
                 min: min,
                 max: max,
                 required: required,
                 readOnly: readOnly,
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
