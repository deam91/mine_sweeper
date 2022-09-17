import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_sweeper/widgets/open_cell.dart';

import '../data/cell.dart';
import 'covered_cell.dart';

class CellWidget extends ConsumerStatefulWidget {
  const CellWidget({
    super.key,
    this.flagged = false,
    this.size = 50,
    this.state = CellState.covered,
    this.count = 0,
    this.isMine = false,
    this.explosionController,
    required this.onLongPress,
    required this.onTap,
  });

  final bool flagged;
  final double size;
  final Function()? onLongPress;
  final Future<void> Function() onTap;
  final CellState state;
  final int count;
  final bool isMine;
  final ConfettiController? explosionController;

  @override
  ConsumerState<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends ConsumerState<CellWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  Path drawCircle(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: const Offset(0, 0),
      radius: size.width / 4,
    ));
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 175),
          child: widget.state != CellState.covered &&
                  widget.state != CellState.flagged
              ? OpenCell(
                  state: widget.state,
                  isMine: widget.isMine,
                  count: widget.count,
                  size: widget.size,
                )
              : CoveredCell(
                  onLongPress: widget.onLongPress,
                  onTap: () async {
                    if (widget.state == CellState.covered) {
                      await widget.onTap();
                      widget.explosionController?.play();
                      Future.delayed(const Duration(milliseconds: 600),
                          () => widget.explosionController?.stop());
                    }
                  },
                  flagged: widget.flagged,
                  size: widget.size,
                ),
        ),
        Center(
          child: widget.isMine && widget.explosionController != null
              ? ConfettiWidget(
                  confettiController: widget.explosionController!,
                  createParticlePath: drawCircle,
                  numberOfParticles: 15,
                  emissionFrequency: 0.04,
                  colors: const [
                    Colors.red,
                  ],
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                )
              : Container(),
        ),
      ],
    );
  }
}
