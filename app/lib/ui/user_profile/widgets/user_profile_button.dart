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
  });

  final String text;
  final VoidCallback onPress;
  final IconData icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppTextButton(
            onPress: onPress,
            label: text,
            leadingIcon: icon,
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
