import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../data/cell.dart';

class OpenCell extends StatelessWidget {
  const OpenCell({
    super.key,
    required this.state,
    this.count = 0,
    this.size = 50,
    required this.isMine,
  });

  final CellState state;
  final int count;
  final double size;
  final bool isMine;

  _cellContent() {
    if (state == CellState.open && count > 0) {
      return '$count';
    } else {
      return '';
    }
  }

  _getGradientColors() {
    if (state == CellState.blown || isMine) {
      return [
        AppColors.letters[2].withOpacity(.5),
        AppColors.letters[2].withOpacity(.3),
      ];
    }
    return [
      AppColors.primary.withOpacity(.6),
      AppColors.primary.withOpacity(.4),
    ];
  }

  getColor(index) {
    return AppColors.letters[index];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 4.0, sigmaX: 4.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getGradientColors(),
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1,
              color: AppColors.accent.withOpacity(0.2),
            ),
          ),
          child: Center(
            child: state == CellState.blown || isMine
                ? Icon(
                    Icons.local_fire_department,
                    size: size - 5,
                    color: AppColors.letters[2],
                  )
                : Text(
                    _cellContent(),
                    style: TextStyle(
                      color: getColor(count > 0 ? count - 1 : 0),
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.clickedCard.withOpacity(.3);

    canvas.drawPath(
        Path.combine(
          PathOperation.difference, //simple difference of following operations
          //bellow draws a rectangle of full screen (parent) size
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          //bellow clips out the circular rectangle with center as offset and dimensions you need to set
          Path()
            ..addRRect(
              RRect.fromRectAndRadius(
                Rect.fromCenter(
                  center: Offset(size.width / 2, size.height / 2),
                  width: size.width,
                  height: size.height,
                ),
                const Radius.circular(10),
              ),
            )
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
