import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/ui/action_button_bar.dart';
import '../../../../core/ui/app_dialog.dart';
import '../../../../core/ui/app_radio_list_tile.dart';
import '../../../../core/utils/intl.dart';
import '../../../view_models/preferences_screen_viewmodel.dart';
import '../../preferences_section_option.dart';

class LocalizationLanguageOption extends StatefulWidget {
  const LocalizationLanguageOption({super.key, required this.viewModel});

  final PreferencesScreenViewModel viewModel;

  @override
  State<LocalizationLanguageOption> createState() =>
      _LocalizationLanguageOptionState();
}

class _LocalizationLanguageOptionState
    extends State<LocalizationLanguageOption> {
  late Locale _initialLocale;

  @override
  void initState() {
    setState(() {
      _initialLocale = widget.viewModel.appLocale;
    });
    super.initState();
  }

  void _onSubmit(Locale locale) {
    if (locale != widget.viewModel.appLocale) {
      widget.viewModel.setAppLocale.execute(locale);
      return;
    }
    // Don't close on locale change because locale change will cause
    // the entire MainApp to re-build, hence no need for closing, as it would
    // cause unwanted behaviour.
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PreferencesSectionOption(
      leadingIconData: FontAwesomeIcons.globe,
      title: context.localization.preferencesLocalizationLanguage,
      subtitle: IntlUtils.getDisplayName(widget.viewModel.appLocale),
      onTap: () {
        var dialogSelectedLocale = _initialLocale;
        AppDialog.show(
          context: context,
          title: Text(
            context.localization.preferencesLocalizationLanguage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
            builder: (BuildContext builderContext, StateSetter setState) {
              void onDialogLanguageSelected(Locale? locale) {
                // This just makes StatefulBuilder re-execute builder method again
                setState(() {
                  dialogSelectedLocale = locale!;
                });
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: IntlUtils.supportedLanguages.map((language) {
                  return AppRadioListTile(
                    value: language.locale,
                    title: Text(
                      language.name,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                    ),
                    groupValue: dialogSelectedLocale,
                    onChanged: onDialogLanguageSelected,
                  );
                }).toList(),
              );
            },
          ),
          actions: ActionButtonBar.withCommand(
            command: widget.viewModel.setAppLocale,
            onSubmit: (BuildContext builderContext) =>
                _onSubmit(dialogSelectedLocale),
            onCancel: (BuildContext builderContext) =>
                Navigator.pop(builderContext),
          ),
        );
      },
    );
  }
}
