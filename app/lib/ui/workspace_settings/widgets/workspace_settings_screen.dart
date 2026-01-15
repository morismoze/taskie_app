import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/constants/rbac.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/labeled_data/labeled_data.dart';
import '../../core/ui/labeled_data/labeled_data_text.dart';
import '../../core/ui/rbac.dart';
import '../../core/utils/user.dart';
import '../../navigation/app_drawer/widgets/workspace_image.dart';
import '../view_models/workspace_settings_screen_viewmodel.dart';

class WorkspaceSettingsScreen extends StatelessWidget {
  const WorkspaceSettingsScreen({super.key, required this.viewModel});

  final WorkspaceSettingsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.workspaceSettings,
                actions: [
                  Rbac(
                    permission: RbacPermission.workspaceSettingsManage,
                    child: AppHeaderActionButton(
                      iconData: FontAwesomeIcons.pencil,
                      onTap: () {
                        final workspaceId = viewModel.details?.id;

                        if (workspaceId != null) {
                          context.push(
                            Routes.workspaceSettingsEditWorkspaceSettings(
                              workspaceId: viewModel.activeWorkspaceId,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.of(context).paddingScreenVertical,
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
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

                    final createdByFullName = details.createdBy != null
                        ? UserUtils.constructFullName(
                            firstName: details.createdBy!.firstName,
                            lastName: details.createdBy!.lastName,
                          )
                        : context
                              .localization
                              .workspaceSettingsOwnerDeletedAccount;

                    return Column(
                      children: [
                        // First section
                        const WorkspaceImage(isActive: false, size: 100),
                        const SizedBox(height: Dimens.paddingVertical * 1.25),
                        // Second section
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Text(
                            details.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        if (details.description != null) ...[
                          const SizedBox(height: Dimens.paddingVertical / 2.25),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Text(
                              details.description!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: AppColors.grey2),
                            ),
                          ),
                        ],
                        const SizedBox(height: Dimens.paddingVertical / 1.25),
                        // Third section
                        LabeledData(
                          label:
                              context.localization.workspaceSettingsCreatedAt,
                          child: LabeledDataText(
                            data: DateFormat.yMd(
                              Localizations.localeOf(context).toString(),
                            ).format(details.createdAt),
                          ),
                        ),
                        const SizedBox(height: Dimens.paddingVertical / 1.6),
                        LabeledData(
                          label:
                              context.localization.workspaceSettingsCreatedBy,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              if (details.createdBy != null)
                                AppAvatar(
                                  hashString: details.createdBy!.id,
                                  firstName: details.createdBy!.firstName,
                                  imageUrl: details.createdBy!.profileImageUrl,
                                ),
                              Text(
                                createdByFullName,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
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
