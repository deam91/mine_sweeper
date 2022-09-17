import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final startStopTimer =
    StateNotifierProvider<StartStopTimer, int>((ref) => StartStopTimer(0));

class StartStopTimer extends StateNotifier<int> {
  StartStopTimer(super.state);
  Timer? timer;
  Stopwatch stopwatch = Stopwatch();
  stop() {
    if (timer != null) {
      timer?.cancel();
    }
    stopwatch.stop();
    stopwatch.reset();
  }

  reset() {
    if (stopwatch.isRunning) stopwatch.stop();
    if (timer != null) timer?.cancel();
    stopwatch.reset();
    state = 0;
  }

  start() {
    if (!stopwatch.isRunning) {
      if (timer != null) {
        timer?.cancel();
      }
      stopwatch.reset();
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        int time = stopwatch.elapsedMilliseconds ~/ 1000;
        state = time;
      });
      stopwatch.start();
    }
  }
}
