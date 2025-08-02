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
import '../../core/ui/labeled_data.dart';
import '../../core/ui/rbac.dart';
import '../../core/ui/role_chip.dart';
import '../../core/utils/user.dart';
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
                actions: [
                  ListenableBuilder(
                    listenable: viewModel,
                    builder: (builderContext, _) {
                      final details = viewModel.details;

                      if (details == null) {
                        return const SizedBox.shrink();
                      }

                      // We don't want for the current user to edit own details.
                      if (viewModel.currentUser.id == details.userId) {
                        return const SizedBox.shrink();
                      }

                      return Rbac(
                        permission: RbacPermission.workspaceManageUsers,
                        child: AppHeaderActionButton(
                          iconData: FontAwesomeIcons.pencil,
                          onTap: () {
                            final workspaceUserId = viewModel.details?.id;

                            if (workspaceUserId != null) {
                              context.push(
                                Routes.workspaceUsersEditUserDetails(
                                  workspaceId: viewModel.activeWorkspaceId,
                                  workspaceUserId: workspaceUserId,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
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

                    final fullName = UserUtils.constructFullName(
                      firstName: details.firstName,
                      lastName: details.lastName,
                    );

                    return Column(
                      children: [
                        // First section
                        AppAvatar(
                          hashString: details.id,
                          firstName: details.firstName,
                          imageUrl: details.profileImageUrl,
                          radius: 50,
                        ),
                        const SizedBox(height: 30),
                        // Second section
                        RoleChip(role: details.role),
                        const SizedBox(height: 5),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Text(
                            fullName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        if (details.email != null) ...[
                          const SizedBox(height: 5),
                          Text(
                            details.email!,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.grey2),
                          ),
                        ],
                        const SizedBox(height: 30),
                        // Third section
                        LabeledData(
                          label: context
                              .localization
                              .workspaceUsersManagementUserDetailsCreatedAt,
                          data: DateFormat.yMd(
                            Localizations.localeOf(context).toString(),
                          ).format(details.createdAt),
                        ),
                        if (details.createdBy != null) ...[
                          const SizedBox(height: 15),
                          LabeledData(
                            label: context
                                .localization
                                .workspaceUsersManagementUserDetailsCreatedBy,
                            leading: AppAvatar(
                              hashString: details.id,
                              firstName: details.firstName,
                              imageUrl: details.createdBy!.profileImageUrl,
                            ),
                            data:
                                '${details.createdBy!.firstName} ${details.createdBy!.lastName}',
                          ),
                        ],
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
