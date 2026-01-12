import 'package:flutter/material.dart';

import '../../../domain/models/workspace.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../navigation/app_drawer/widgets/workspace_image.dart';

class WorkspaceInfo extends StatelessWidget {
  const WorkspaceInfo({super.key, required this.info});

  final Workspace info;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.paddingVertical,
      children: [
        WorkspaceImage(isActive: false, url: info.pictureUrl, size: 100),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Text(
            info.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        if (info.description != null)
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Text(
              info.description!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.grey2),
            ),
          ),
      ],
    );
  }
}
