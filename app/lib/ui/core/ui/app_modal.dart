import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/dimens.dart';

class AppModal {
  AppModal._();

  static void show({
    required BuildContext context,
    required Widget title,
    required Widget message,
    required Widget ctaButton,
    required Widget cancelButton,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.symmetric(vertical: 10),
          title: Center(child: title),
          content: message,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: CupertinoColors.systemBackground.resolveFrom(
            dialogContext,
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: Dimens.paddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ctaButton, const SizedBox(height: 8), cancelButton],
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
