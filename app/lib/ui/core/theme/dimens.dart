import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  /// General horizontal padding used to separate UI items
  static const paddingHorizontal = 16.0;

  /// General vertical padding used to separate UI items
  static const paddingVertical = 24.0;

  /// Horizontal padding for screen edges
  double get paddingScreenHorizontal;

  /// Vertical padding for screen edges
  double get paddingScreenVertical;

  double get profilePictureSize;

  /// Horizontal symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  /// Symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreenSymmetric => EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static const Dimens mobile = _DimensMobile();

  /// Get dimensions definition based on screen size - for now only mobile is defined
  factory Dimens.of(BuildContext context) => mobile;
}

final class _DimensMobile extends Dimens {
  @override
  final double paddingScreenHorizontal = Dimens.paddingHorizontal;

  @override
  final double paddingScreenVertical = Dimens.paddingVertical;

  @override
  final double profilePictureSize = 64.0;

  const _DimensMobile();
}
