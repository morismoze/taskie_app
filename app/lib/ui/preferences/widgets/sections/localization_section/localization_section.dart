import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../view_models/preferences_screen_viewmodel.dart';
import '../../preferences_section.dart';
import 'localization_language_option.dart';

class LocalizationSection extends StatelessWidget {
  const LocalizationSection({super.key, required this.viewModel});

  final PreferencesScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PreferencesSection(
      title: context.localization.preferencesLocalization,
      children: [LocalizationLanguageOption(viewModel: viewModel)],
    );
  }
}
