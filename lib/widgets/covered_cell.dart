import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/colors.dart';

class CoveredCell extends StatelessWidget {
  const CoveredCell({
    super.key,
    this.flagged = false,
    this.size = 50,
    required this.onLongPress,
    required this.onTap,
  });

  final bool flagged;
  final double size;
  final Function()? onLongPress;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        splashColor: AppColors.accent.withOpacity(.8),
        hoverColor: AppColors.accent.withOpacity(.8),
        highlightColor: AppColors.accent.withOpacity(.8),
        borderRadius: BorderRadius.circular(10),
        onLongPress: onLongPress,
        onTap: onTap,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(.8),
                  AppColors.accent.withOpacity(.6),
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 1.5,
                color: AppColors.accent.withOpacity(0.2),
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: flagged
                    ? Image.asset(
                        'assets/images/shield.png',
                        fit: BoxFit.contain,
                      )
                    : const Text(''),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
