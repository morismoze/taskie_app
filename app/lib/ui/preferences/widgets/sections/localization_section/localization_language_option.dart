import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/ui/action_button_bar.dart';
import '../../../../core/ui/app_dialog.dart';
import '../../../../core/ui/app_radio_list_tile.dart';
import '../../../../core/utils/intl.dart';
import '../../../view_models/preferences_screen_view_model.dart';
import '../../preferences_section_option.dart';

class LocalizationLanguageOption extends StatelessWidget {
  const LocalizationLanguageOption({super.key, required this.viewModel});

  final PreferencesScreenViewModel viewModel;

  void _onSubmit(BuildContext context, Locale newLocale) {
    if (newLocale != viewModel.appLocale) {
      viewModel.setAppLocale.execute(newLocale);
    }

    Navigator.of(context).pop(); // Close dialog
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop(); // Close dialog
  }

  @override
  Widget build(BuildContext context) {
    return PreferencesSectionOption(
      leadingIconData: FontAwesomeIcons.globe,
      title: context.localization.preferencesLocalizationLanguage,
      subtitle: IntlUtils.getDisplayName(viewModel.appLocale),
      onTap: () {
        // Local state for StatefulBuilder (acts as a field in a State class)
        var dialogSelectedLocale = viewModel.appLocale;

        AppDialog.show(
          context: context,
          title: Text(
            context.localization.preferencesLocalizationLanguage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
            builder: (BuildContext builderContext, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: IntlUtils.supportedLanguages.map((language) {
                  return AppRadioListTile<Locale>(
                    value: language.locale,
                    title: Text(
                      language.name,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                    ),
                    groupValue: dialogSelectedLocale,
                    onChanged: (Locale? locale) {
                      if (locale != null) {
                        setState(() {
                          dialogSelectedLocale = locale;
                        });
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: ActionButtonBar.withCommand(
            command: viewModel.setAppLocale,
            onSubmit: () => _onSubmit(context, dialogSelectedLocale),
            onCancel: () => _onCancel(context),
          ),
        );
      },
    );
  }
}
