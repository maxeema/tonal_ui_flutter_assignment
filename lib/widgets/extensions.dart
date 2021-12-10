import 'package:flutter/widgets.dart';

import 'styles.dart';

extension BoxDecorationX on BoxDecoration {
  BoxDecoration copyWithBoxShadow({
    double offsetX = bubbleBoxShadowOffsetX,
    double offsetY = bubbleBoxShadowOffsetY,
    double blurRadius = bubbleBoxShadowBlurRadius,
    double scaleFactor = 1.0,
    Color color = bubbleBoxShadowColor,
  }) {
    return copyWith(boxShadow: [
      BoxShadow(
          offset: Offset(offsetX * scaleFactor, offsetY * scaleFactor),
          blurRadius: blurRadius * scaleFactor,
          color: color)
    ]);
  }
}
