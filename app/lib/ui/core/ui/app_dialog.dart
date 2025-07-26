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
            actionsPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            title: Center(child: title),
            content: content,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: actions == null
                ? null
                : [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: actions,
                    ),
                  ],
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
    List<Widget>? actions,
    bool canPop = true,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: canPop,
          child: Dialog(
            insetPadding: const EdgeInsets.all(Dimens.paddingVertical),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 4,
                    ),
                    child: content,
                  ),
                  if (actions != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: actions,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
