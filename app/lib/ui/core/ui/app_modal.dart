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
                        children: () {
                          final separatedActions = <Widget>[];
                          for (var i = 0; i < actions.length; i++) {
                            separatedActions.add(actions[i]);
                            if (i < actions.length - 1) {
                              separatedActions.add(const SizedBox(height: 8));
                            }
                          }
                          return separatedActions;
                        }(),
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
