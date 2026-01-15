import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/user.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_modal_bottom_sheet.dart';
import '../../user_profile/widgets/user_profile.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openUserProfile(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAvatar(
            hashString: user.id,
            firstName: user.firstName,
            imageUrl: user.profileImageUrl,
            size: 30,
          ),
          const SizedBox(width: Dimens.paddingHorizontal / 2),
          const FaIcon(
            FontAwesomeIcons.sort,
            color: AppColors.black1,
            size: 17,
          ),
        ],
      ),
    );
  }

  void _openUserProfile(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      isDetached: true,
      child: UserProfile(viewModel: context.read()),
    );
  }
}
