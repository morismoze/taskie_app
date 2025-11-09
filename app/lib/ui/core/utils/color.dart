import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../theme/colors.dart';
import 'extensions.dart';

abstract final class ColorsUtils {
  static Color generateColorFromString(String string, {double alpha = 1.0}) {
    final hash = string.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;
    return Color.fromRGBO(r, g, b, alpha);
  }

  static (Color textColor, Color backgroundColor) getProgressStatusColors(
    ProgressStatus status,
  ) {
    switch (status) {
      case ProgressStatus.inProgress:
        return (AppColors.orange1, AppColors.orange1.lighten());
      case ProgressStatus.completed:
        return (AppColors.green1, AppColors.green1.lighten());
      case ProgressStatus.completedAsStale:
        return (AppColors.purple1, AppColors.purple1.lighten());
      case ProgressStatus.notCompleted:
        return (AppColors.red1, AppColors.red1.lighten());
      case ProgressStatus.closed:
        return (AppColors.grey2, AppColors.grey2.lighten());
    }
  }
}
