import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_sweeper/providers/audio.dart';
import 'package:mine_sweeper/providers/cells.dart';
import 'package:mine_sweeper/providers/game.dart';
import 'package:mine_sweeper/providers/game_over.dart';
import 'package:mine_sweeper/providers/mines.dart';
import 'package:mine_sweeper/widgets/cell.dart';
import 'package:mine_sweeper/widgets/shaker.dart';
import 'package:mine_sweeper/widgets/timer_widget.dart';

import '../data/cell.dart';
import '../providers/alive.dart';
import '../providers/mines_founded.dart';
import '../providers/timer.dart';
import '../widgets/shields_count.dart';
import '../widgets/time.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView>
    with TickerProviderStateMixin {
  late bool wonGame;
  late AnimationController animationController;
  ConfettiController explosionController =
      ConfettiController(duration: const Duration(seconds: 600));

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(cellsProvider);
    ref.read(minesProvider);
    ref.read(minesFounded);
    ref.read(audioProvider);
    ref.read(alive.notifier).addListener((state) {
      if (!state) {
        loseDialog();
      }
    });
    ref.read(audioProvider.notifier).addListener((state) {
      if (state && wonGame && mounted) {
        wonDialog(context);
      }
    });
  }

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
  }

  stopTimer() {
    ref.read(startStopTimer.notifier).stop();
  }

  startStopwatch() {
    ref.read(startStopTimer.notifier).start();
  }

  @override
  void dispose() {
    explosionController.dispose();
    super.dispose();
  }

  loseDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (_, a1, a2) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 3),
            const Text(
              'You Lose!',
              style: TextStyle(fontSize: 40, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            TextButton(
              child: const Text(
                'Try again!!',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                ref.read(gameStateProvider.notifier).resetGame();
                setState(() {});
                Navigator.of(_).pop();
              },
            ),
          ],
        );
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeOutBack.transform(a1.value);
        return Transform.scale(
          scale: curve,
          // child: Transform.rotate(
          //   angle: math.radians(180 * a1.value),
          child: AlertDialog(
            content: child,
          ),
          // ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  wonDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (_, a1, a2) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/cup.png',
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 3),
                const Text(
                  'You Won!',
                  style: TextStyle(fontSize: 40, color: Colors.black54),
                ),
                const SizedBox(height: 8),
              ],
            ),
            Time(
              duration:
                  Duration(seconds: ref.read(startStopTimer.notifier).state),
            ),
            const SizedBox(height: 8),
            TextButton(
              child: const Text(
                'Restart',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                ref.read(gameStateProvider.notifier).resetGame();
                setState(() {});
                Navigator.of(_).pop();
              },
            ),
          ],
        );
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeOutBack.transform(a1.value);
        return Transform.scale(
          scale: curve,
          // child: Transform.rotate(
          //   angle: math.radians(180 * a1.value),
          child: AlertDialog(
            content: child,
          ),
          // ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  Future<void> onTap(AnimationController widgetAnimation, int i, int j,
      CellState state) async {
    widgetAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (state == CellState.covered) {
          ref.read(gameStateProvider.notifier).probe(i, j);
          setState(() {});
        }
      }
    });
    await widgetAnimation.forward();
    ref.read(audioProvider.notifier).playBlown();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD MAIN VIEW');
    return Stack(
      fit: StackFit.expand,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.blue.withOpacity(.2)),
            child: Image.asset(
              'assets/images/dart-logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: kToolbarHeight * 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: ShieldsCount(),
                ),
                Expanded(
                  child: TimerWidget(),
                ),
              ],
            ),
            LayoutBuilder(
              builder: (BuildContext context, constraints) {
                print('BUILD LayoutBuilder');
                double width = (constraints.maxWidth / 6) - 8;
                bool hasCoveredCell = false;

                final widget = Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: IgnorePointer(
                      ignoring: ref.read(gameOver),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 36,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                        itemBuilder: (context, index) {
                          final i = (index) ~/ 6;
                          final j = index - (i * 6);
                          CellState state = ref.read(cellsProvider)[i][j].state;
                          int count = ref
                              .read(gameStateProvider.notifier)
                              .mineCount(i, j);

                          if (!ref.read(alive)) {
                            if (state != CellState.blown) {
                              state = ref.read(minesProvider)[i][j]
                                  ? CellState.revealed
                                  : state;
                            }
                          }

                          if (state == CellState.covered) {
                            hasCoveredCell = true;
                          }

                          bool isMine =
                              ref.read(minesProvider.notifier).isMine(i, j);

                          var topWidget = CellWidget(
                            size: width,
                            isMine: isMine,
                            state: state,
                            count: count,
                            onLongPress: () => setState(() {
                              ref.read(gameStateProvider.notifier).flag(i, j);
                            }),
                            flagged: state == CellState.flagged,
                            onTap: () async {
                              if (state == CellState.covered) {
                                ref
                                    .read(audioProvider.notifier)
                                    .playItemSelection();
                                ref
                                    .read(gameStateProvider.notifier)
                                    .probe(i, j);
                                setState(() {});
                              }
                            },
                          );
                          if (isMine) {
                            AnimationController widgetAnimation =
                                AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 600),
                            );
                            Animation<double> animation =
                                Tween<double>(begin: 0, end: 1)
                                    .animate(widgetAnimation);

                            topWidget = CellWidget(
                              size: width,
                              isMine: isMine,
                              state: state,
                              count: count,
                              explosionController: explosionController,
                              onLongPress: () => setState(() {
                                ref.read(gameStateProvider.notifier).flag(i, j);
                              }),
                              flagged: state == CellState.flagged,
                              onTap: () async =>
                                  await onTap(widgetAnimation, i, j, state),
                            );

                            return Shaker(
                              animation: animation,
                              shakeCount: 4,
                              child: topWidget,
                            );
                          }

                          return topWidget;
                        },
                      ),
                    ),
                  ),
                );

                if (!hasCoveredCell) {
                  if (ref.read(minesFounded.notifier).state ==
                          ref.read(minesProvider.notifier).count &&
                      ref.read(alive)) {
                    stopTimer();
                    wonGame = true;
                    ref.read(audioProvider.notifier).playWon();
                  }
                }

                return widget;
              },
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
