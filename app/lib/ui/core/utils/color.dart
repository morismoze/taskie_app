import 'package:flutter/material.dart';

abstract final class ColorGenerator {
  static Color generateColorFromString(String string, {double alpha = 1.0}) {
    final hash = string.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;
    return Color.fromRGBO(r, g, b, alpha);
  }
}
