import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/dimens.dart';
import 'app_filled_button.dart';
import 'app_text_button.dart';

class AppModal {
  AppModal._();

  static void show({
    required BuildContext context,
    required Widget title,
    required Widget message,
    required CtaButton ctaButton,
    required CancelButton cancelButton,
  }) {
    final ctaColor = switch (ctaButton.type) {
      CtaType.success => const Color(0xFF52DC69),
      CtaType.error => Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.primary,
    };

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
                children: [
                  AppFilledButton(
                    onPress: () => ctaButton.onPress,
                    label: ctaButton.label,
                    backgroundColor: ctaColor,
                    isLoading: ctaButton.isLoading,
                  ),
                  const SizedBox(height: 8),
                  AppTextButton(
                    onPress: cancelButton.onPress,
                    label: cancelButton.label,
                  ),
                ],
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}

enum CtaType { success, error, normal }

class CtaButton {
  CtaButton({
    required this.label,
    required this.onPress,
    this.type = CtaType.normal,
    this.isLoading = false,
  });

  final String label;
  final void Function() onPress;
  final CtaType type;
  final bool isLoading;
}

class CancelButton {
  CancelButton({required this.label, required this.onPress});

  final String label;
  final void Function() onPress;
}
