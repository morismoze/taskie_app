import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/dimens.dart';
import '../view_models/app_drawer_viewmodel.dart';
import 'footer.dart';
import 'workspaces_list.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Dimens.paddingVertical * 2,
            bottom: kBottomNavigationBarHeight + Dimens.paddingVertical / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.paddingHorizontal,
                ),
                child: Text(
                  context.localization.appDrawerTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: Dimens.paddingVertical / 1.25),
              WorkspacesList(viewModel: viewModel),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
