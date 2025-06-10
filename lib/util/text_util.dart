import 'package:flutter/material.dart';

class TextUtil {
  static double recalculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }
}
