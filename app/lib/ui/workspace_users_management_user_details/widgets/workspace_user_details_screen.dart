import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/workspace_user_details_screen_view_model.dart';

class WorkspaceUserDetailsScreen extends StatelessWidget {
  const WorkspaceUserDetailsScreen({super.key, required this.viewModel});

  final WorkspaceUserDetailsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.workspaceUsersManagementUserDetails,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: Dimens.paddingVertical,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
                ),
                child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (builderContext, _) {
                    final details = viewModel.details;

                    if (details == null) {
                      return ActivityIndicator(
                        radius: 11,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    final fullName = '${details.firstName} ${details.lastName}';

                    return Column(
                      children: [
                        AppAvatar(
                          text: fullName,
                          imageUrl: details.profileImageUrl,
                          radius: 50,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          fullName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 5),
                        if (details.email != null)
                          Text(
                            details.email!,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.grey2),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
