import 'package:flutter/material.dart';
import 'package:tonal_assignment/generated/fonts.gen.dart';

const bubbleDiameter = 272;

const bubbleBoxColor = Color(0xff53a99a);
const bubbleBoxShadowColor = Color(0x3827ae96);
const bubbleBoxShadowOffsetX = 0.0;
const bubbleBoxShadowOffsetY = 27.0;
const bubbleBoxShadowBlurRadius = 33.0;

const bubbleBoxDecoration = BoxDecoration(
  color: bubbleBoxColor,
  shape: BoxShape.circle,
  boxShadow: [
    BoxShadow(
      offset: Offset(bubbleBoxShadowOffsetX, bubbleBoxShadowOffsetY),
      blurRadius: bubbleBoxShadowBlurRadius,
      color: bubbleBoxShadowColor,
    )
  ],
);

const labelTextStyle = TextStyle(
  fontFamily: FontFamily.helvetica,
  fontWeight: FontWeight.bold,
  fontSize: 19,
  color: Colors.white,
);

const weightTextStyle = TextStyle(
  fontFamily: FontFamily.leagueGothic,
  fontSize: 127,
  color: Colors.white,
);

const unitTextStyle = TextStyle(
  fontFamily: FontFamily.leagueGothic,
  fontSize: 38,
  color: Color(0x80ffffff),
);
