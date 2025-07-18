import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/colors.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(height: 10, thickness: 1, color: AppColors.grey3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label != null
                  ? label!.toUpperCase()
                  : context.localization.orSeparator,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: AppColors.grey2,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const Expanded(
            child: Divider(height: 10, thickness: 1, color: AppColors.grey3),
          ),
        ],
      ),
    );
  }
}
