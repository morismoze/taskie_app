import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/colors.dart';

class PreferencesSectionOption extends StatelessWidget {
  const PreferencesSectionOption({
    super.key,
    required this.leadingIconData,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData leadingIconData;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FaIcon(leadingIconData, color: AppColors.grey2, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: AppColors.grey2),
            ),
          ],
        ),
        trailing: trailing,
      ),
    );
  }
}
