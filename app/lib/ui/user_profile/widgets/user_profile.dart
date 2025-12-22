import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/role_chip.dart';
import '../../core/utils/user.dart';
import '../view_models/user_profile_view_model.dart';
import 'user_profile_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.viewModel});

  final UserProfileViewModel viewModel;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.signOut.addListener(_onSignOutResult);
  }

  @override
  void didUpdateWidget(covariant UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.signOut.removeListener(_onSignOutResult);
    widget.viewModel.signOut.addListener(_onSignOutResult);
  }

  @override
  void dispose() {
    widget.viewModel.signOut.removeListener(_onSignOutResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewModel.loadUserDetails,
        widget.viewModel.signOut,
        widget.viewModel,
      ]),
      builder: (builderContext, _) {
        final details = widget.viewModel.details;

        if (details == null) {
          return ActivityIndicator(
            radius: 16,
            color: Theme.of(builderContext).colorScheme.primary,
          );
        }

        final fullName = UserUtils.constructFullName(
          firstName: details.firstName,
          lastName: details.lastName,
        );
        final currentWorkspaceRole = details.roles
            .firstWhere(
              (role) => role.workspaceId == widget.viewModel.activeWorkspaceId,
            )
            .role;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Column(
            children: [
              Row(
                spacing: Dimens.paddingHorizontal / 1.5,
                children: [
                  AppAvatar(
                    hashString: details.id,
                    firstName: details.firstName,
                    imageUrl: details.profileImageUrl,
                    size: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fullName,
                        style: Theme.of(builderContext).textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold, height: 1),
                      ),
                      // Flutter Chip for some reason has vertical padding even though
                      // it is set to 0 in RoleChip impl.
                      RoleChip(role: currentWorkspaceRole),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Dimens.paddingVertical),
              UserProfileButton(
                onPress: () {
                  context.push(Routes.preferences);
                },
                text: context.localization.preferencesLabel,
                icon: FontAwesomeIcons.gear,
              ),
              UserProfileButton(
                onPress: () {
                  widget.viewModel.signOut.execute();
                },
                text: context.localization.signOut,
                icon: FontAwesomeIcons.arrowRightFromBracket,
                isLoading: widget.viewModel.signOut.running,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSignOutResult() {
    if (widget.viewModel.signOut.completed) {
      widget.viewModel.signOut.clearResult();
    }

    if (widget.viewModel.signOut.error) {
      widget.viewModel.signOut.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.signOutError,
      );
    }
  }
}
