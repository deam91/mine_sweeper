import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Shaker extends StatelessWidget {
  const Shaker({
    super.key,
    required this.child,
    required this.animation,
    this.shakeCount = 3,
    this.shakeOffset = 5,
  });
  final Animation<double> animation;
  final int shakeCount;
  final int shakeOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final sineValue = sin(shakeCount * 2 * pi * animation.value);
        return Transform.scale(
          scale: lerpDouble(1, 1.1, animation.value),
          child: Transform.translate(
            offset: Offset(sineValue * shakeOffset, 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
