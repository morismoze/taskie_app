import 'package:flutter/material.dart';

import '../theme/dimens.dart';

class AppDialog {
  AppDialog._();

  static void showAlert({
    required BuildContext context,
    required Widget title,
    required Widget content,
    List<Widget>? actions,
    bool canPop = true,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            contentPadding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingVertical,
              horizontal: Dimens.paddingHorizontal,
            ),
            title: Center(child: title),
            content: content,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            actionsPadding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingVertical,
              horizontal: Dimens.paddingHorizontal,
            ),
            actions: actions,
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      },
    );
  }

  static void show({
    required BuildContext context,
    required Widget title,
    required Widget content,
    Widget? actions,
    bool canPop = true,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: canPop,
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.paddingVertical,
                horizontal: Dimens.paddingHorizontal,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Center(child: title),
                  content,
                  if (actions != null) actions,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
