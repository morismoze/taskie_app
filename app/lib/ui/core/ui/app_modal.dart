import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/dimens.dart';

class AppDialog {
  AppDialog._();

  static void show({
    required BuildContext context,
    required Widget title,
    required Widget message,
    List<Widget>? actions = const [],
    bool canPop = true,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 10),
            title: Center(child: title),
            content: message,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: CupertinoColors.systemBackground.resolveFrom(
              dialogContext,
            ),
            actions: actions == null
                ? null
                : [
                    Padding(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: Dimens.paddingHorizontal,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: actions,
                      ),
                    ),
                  ],
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      },
    );
  }
}
