import 'package:flutter/material.dart';

abstract final class WidgetsUtils {
  static Widget buildFormattedText({
    required BuildContext context,
    required String text,
    required TextStyle style,
  }) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge;

    // ** is parsed as bold
    // __ (double underscore) is parsed as underline
    // * is parsed as italic
    final regex = RegExp(r'\*\*(.*?)\*\*|__(.*?)__|(?<!\*)\*(.*?)\*(?!\*)');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    var lastIndex = 0;

    for (final match in matches) {
      // Add text before match
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: baseStyle,
          ),
        );
      }

      final boldText = match.group(1);
      final underlineText = match.group(2);
      final italicText = match.group(3);

      if (boldText != null) {
        spans.add(
          TextSpan(
            text: boldText,
            style: baseStyle?.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (underlineText != null) {
        spans.add(
          TextSpan(
            text: underlineText,
            style: baseStyle?.copyWith(decoration: TextDecoration.underline),
          ),
        );
      } else if (italicText != null) {
        spans.add(
          TextSpan(
            text: italicText,
            style: baseStyle?.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: baseStyle));
    }

    return Text.rich(TextSpan(children: spans));
  }
}
