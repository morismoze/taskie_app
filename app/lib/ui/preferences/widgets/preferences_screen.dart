import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/preferences_screen_viewmodel.dart';
import 'sections/localization_section/localization_section.dart';
import 'sections/theme_section/theme_section.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key, required this.viewModel});

  final PreferencesScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PreferencesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _getPreferencesSectionsWidgets() {
    return [
      LocalizationSection(viewModel: widget.viewModel),
      const ThemeSection(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final preferencesSections = _getPreferencesSectionsWidgets();

    return Scaffold(
      body: BlurredCirclesBackground(
        child: Column(
          children: [
            HeaderBar(title: context.localization.preferencesLabel),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.paddingVertical,
                ),
                itemCount: preferencesSections.length,
                separatorBuilder: (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.paddingVertical / 2,
                  ),
                  child: Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: AppColors.grey1,
                  ),
                ),
                itemBuilder: (builderContext, index) {
                  final section = preferencesSections[index];
                  return section;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
