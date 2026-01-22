import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/colors.dart';
import '../theme/dimens.dart';
import 'app_icon_button.dart';

const _borderRadius = 16.0;
const _notchLineWidth = 20.0;
const _notchLineHeight = 2.0;

/// This is the base construct for the design look of the app
/// modal bottom sheet content. It displays the notch at the top,
/// close button on the left side and title on the right side
/// of the header, below it a separator line and child content.
class AppModalBottomSheetContentWrapper extends StatelessWidget {
  const AppModalBottomSheetContentWrapper({
    super.key,
    required this.title,
    required this.child,
    this.onCloseButtonPress,
  });

  final String title;
  final Widget child;
  final VoidCallback? onCloseButtonPress;

  void _onClosePress(BuildContext context) {
    onCloseButtonPress?.call();
    Navigator.of(context).pop(); // Close bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingVertical / 2),
              child: Container(
                width: _notchLineWidth,
                height: _notchLineHeight,
                decoration: BoxDecoration(
                  color: AppColors.grey3,
                  borderRadius: BorderRadius.circular(_notchLineHeight),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimens.paddingVertical / 2.5,
                bottom: Platform.isIOS
                    ? Dimens.paddingVertical
                    : MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.paddingHorizontal,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Title always centered
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.paddingHorizontal * 2.25,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              title,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(fontSize: 19),
                            ),
                          ),
                        ),
                        // Close button always on the left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppIconButton(
                            icon: const FaIcon(FontAwesomeIcons.xmark),
                            iconSize: 21,
                            onPress: () => _onClosePress(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.paddingVertical / 2),
                  Container(
                    height: 1,
                    color: AppColors.grey3.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: Dimens.paddingVertical),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.paddingHorizontal,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
