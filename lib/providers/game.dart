import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_sweeper/providers/audio.dart';

import '../data/cell.dart';
import 'alive.dart';
import 'cells.dart';
import 'game_over.dart';
import 'mines.dart';
import 'mines_founded.dart';
import 'timer.dart';

final gameStateProvider = StateNotifierProvider<GameState, bool>((ref) {
  return GameState(ref);
});

class GameState extends StateNotifier<bool> {
  GameState(this._ref) : super(false);
  final Ref _ref;

  late final _cellsProvider = _ref.read(cellsProvider.notifier);
  late final _minesProvider = _ref.read(minesProvider.notifier);
  late final _alive = _ref.read(alive);
  late final _startStopTimer = _ref.read(startStopTimer.notifier);

  void probe(int x, int y) {
    if (!_alive) return;
    if (_cellsProvider.isFlagged(x, y)) return;
    if (_minesProvider.isMine(x, y)) {
      _ref.read(gameOver.notifier).gameOver = true;
      _ref.read(alive.notifier).alive = false;
      _cellsProvider.setCellState(x, y, CellState.blown);
      _startStopTimer.stop();
      state = false;
    } else {
      open(x, y);
      _startStopTimer.start();
    }
  }

  void resetGame() {
    print('resetGame()');
    _cellsProvider.reset();
    _minesProvider.reset();
    _ref.read(alive.notifier).alive = true;
    _ref.read(gameOver.notifier).gameOver = false;
    _ref.read(minesFounded.notifier).reset();
    _ref.read(audioProvider.notifier).state = false;
    _startStopTimer.reset();
    state = false;
  }

  void open(int x, int y) {
    if (!inBoard(x, y)) return;
    if (_cellsProvider.isOpen(x, y)) return;
    _cellsProvider.setCellState(x, y, CellState.open);

    if (mineCount(x, y) > 0) return;

    open(x - 1, y);
    open(x + 1, y);
    open(x, y - 1);
    open(x, y + 1);
    open(x - 1, y - 1);
    open(x + 1, y + 1);
    open(x + 1, y - 1);
    open(x - 1, y + 1);
  }

  void flag(int x, int y) {
    if (!_alive) return;
    if (_cellsProvider.isFlagged(x, y)) {
      _cellsProvider.setCellState(x, y, CellState.covered);
      _ref.read(minesFounded.notifier).decrement();
    } else {
      _cellsProvider.setCellState(x, y, CellState.flagged);
      _ref.read(minesFounded.notifier).increment();
    }
  }

  int mineCount(int x, int y) {
    int count = 0;
    count += bombs(x - 1, y);
    count += bombs(x + 1, y);
    count += bombs(x, y - 1);
    count += bombs(x, y + 1);
    count += bombs(x - 1, y - 1);
    count += bombs(x + 1, y + 1);
    count += bombs(x + 1, y - 1);
    count += bombs(x - 1, y + 1);
    return count;
  }

  int bombs(int x, int y) =>
      inBoard(x, y) && _minesProvider.isMine(x, y) ? 1 : 0;
  inBoard(int x, int y) => x >= 0 && x < 6 && y >= 0 && y < 6;
}
