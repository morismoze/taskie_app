import 'package:flutter/material.dart';

import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_text_button.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({
    super.key,
    required this.text,
    required this.onPress,
    required this.icon,
    this.isLoading = false,
    this.isDanger = false,
  });

  final String text;
  final VoidCallback onPress;
  final IconData icon;
  final bool isLoading;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Theme.of(context).colorScheme.error : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppTextButton(
            onPress: onPress,
            label: text,
            leadingIcon: icon,
            color: color,
          ),
        ),
        if (isLoading)
          ActivityIndicator(
            radius: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }
}
