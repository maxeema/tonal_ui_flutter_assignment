import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tonal_assignment/generated/assets.gen.dart';

import 'extensions.dart';
import 'styles.dart' as styles;

const _unit = "lbs";
const _animatedSwitcherDuration = Duration(milliseconds: 270);

class MetricsWidget extends StatelessWidget {
  static const minWeightValue = 0;
  static const maxWeightValue = 350;

  MetricsWidget({required String label, required int weight, double? preferredSize, Key? key})
      : assert(preferredSize == null || preferredSize > 0),
        assert(weight >= minWeightValue && weight <= maxWeightValue),
        _label = label,
        _weight = weight.clamp(minWeightValue, maxWeightValue),
        _preferredSize = preferredSize,
        super(key: key);

  final String _label;
  final int _weight;

  // If specified, the widget will take exactly 'preferredSize',
  // otherwise it will match the parent size
  final double? _preferredSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      late final double scaleFactor;
      if (_preferredSize != null) {
        scaleFactor = _preferredSize! / styles.bubbleDiameter.toDouble();
      } else {
        scaleFactor = math.min(constraints.maxWidth, constraints.maxHeight) / styles.bubbleDiameter.toDouble();
      }
      final size = styles.bubbleDiameter.toDouble() * scaleFactor;
      // print('scaleFactor: $scaleFactor, size: $size, maxWidth: ${constraints.maxWidth}');
      return SizedBox.fromSize(
        size: Size.square(size),
        // Use 'ClipPath' because we use an SvgPicture with a squared background image
        // but we want to look all circle
        child: Stack(
          // Setup background style
          children: [
            Positioned.fill(
              child: Container(
                decoration: styles.bubbleBoxDecoration.copyWithBoxShadow(
                  scaleFactor: scaleFactor,
                ),
              ),
            ),
            // Draw and place the waves effect image a top of background
            ClipPath.shape(
              shape: const CircleBorder(),
              child: Align(
                // Position and transform the image make it look like on the design
                alignment: const FractionalOffset(0.5, 1.2),
                child: Transform.rotate(
                  angle: -math.pi / 85.0,
                  child: FractionallySizedBox(
                    heightFactor: .5,
                    widthFactor: .97,
                    child: SvgPicture.asset(
                      Assets.images.graph,
                    ),
                  ),
                ),
              ),
            ),
            // Place labels and weight
            Stack(
              children: [
                Align(
                  alignment: const FractionalOffset(0.5, 0.2),
                  child: AnimatedSwitcher(
                    duration: _animatedSwitcherDuration,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: size * 0.7,
                      ),
                      child: Text(
                        _label,
                        key: Key(_label),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: styles.labelTextStyle.apply(
                          fontSizeFactor: scaleFactor,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const FractionalOffset(0.5, 0.55),
                  child: AnimatedSwitcher(
                    duration: _animatedSwitcherDuration,
                    child: Text(
                      '$_weight',
                      key: ObjectKey(_weight),
                      style: styles.weightTextStyle.apply(
                        fontSizeFactor: scaleFactor,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const FractionalOffset(0.5, 0.88),
                  child: Text(
                    _unit,
                    style: styles.unitTextStyle.apply(
                      fontSizeFactor: scaleFactor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
