import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final minesProvider =
    StateNotifierProvider<MinesManager, List<List<bool>>>((ref) {
  final mines =
      List<List<bool>>.generate(6, (x) => List<bool>.generate(6, (y) => false));
  int count = 36 ~/ 8;
  int auxCount = count;
  Random random = Random();
  while (auxCount > 0) {
    int pos = random.nextInt(6 * 6);
    int x = pos ~/ 6;
    int y = pos % 6;
    if (!mines[x][y]) {
      mines[x][y] = true;
      auxCount--;
    }
  }
  return MinesManager(ref.read, mines, countMines: count);
});

class MinesManager extends StateNotifier<List<List<bool>>> {
  MinesManager(this.ref, List<List<bool>> mines, {required this.countMines})
      : super(mines) {
    _count = countMines;
  }

  final Reader ref;
  final int countMines;
  int _count = 0;

  int get count => _count;

  reset() {
    state.clear();
    final mines = List<List<bool>>.generate(
        6, (x) => List<bool>.generate(6, (y) => false));
    _count = 36 ~/ 8;
    int count = _count;
    print('mines $count');
    Random random = Random();
    while (count > 0) {
      int pos = random.nextInt(6 * 6);
      int x = pos ~/ 6;
      int y = pos % 6;
      if (!mines[x][y]) {
        mines[x][y] = true;
        count--;
      }
    }
    state = mines;
  }

  isMine(int x, int y) => state[x][y];
}
