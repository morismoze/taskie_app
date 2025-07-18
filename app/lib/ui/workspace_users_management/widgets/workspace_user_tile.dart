import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../routing/routes.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_avatar.dart';

class WorkspaceUserTile extends StatelessWidget {
  const WorkspaceUserTile({
    super.key,
    required this.activeWorkspaceId,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.email,
    this.profileImageUrl,
  });

  final String activeWorkspaceId;
  final String id;
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final String? email;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final fullName = '$firstName $lastName';
    final roleChipBackgroundColor = role == WorkspaceRole.manager
        ? AppColors.purple1Light
        : AppColors.green1Light;
    final roleChipTextColor = role == WorkspaceRole.manager
        ? AppColors.purple1
        : AppColors.green1;

    return InkWell(
      onTap: () => context.push(
        Routes.workspaceUsersWithId(
          workspaceId: activeWorkspaceId,
          workspaceUserId: id,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white1,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 12,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          leading: AppAvatar(text: fullName, imageUrl: profileImageUrl),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              if (email != null)
                Text(
                  email!,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              Text(
                fullName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          trailing: Chip(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
            side: BorderSide.none,
            backgroundColor: roleChipBackgroundColor,
            label: Text(
              role.value,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: roleChipTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
