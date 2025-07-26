import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../preferences_section.dart';
import '../preferences_section_option.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferencesSection(
      title: context.localization.preferencesTheme,
      children: [_ThemeDarkModeOption()],
    );
  }
}

class _ThemeDarkModeOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreferencesSectionOption(
      leadingIconData: FontAwesomeIcons.starHalfStroke,
      title: context.localization.preferencesThemeDarkMode,
      subtitle: context.localization.preferencesThemeDarkModeOff,
      trailing: Text(
        context.localization.comingSoon.toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
