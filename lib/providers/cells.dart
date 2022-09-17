import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cell.dart';

final cellsProvider =
    StateNotifierProvider<CellsManager, List<List<Cell>>>((ref) {
  final cells = List<List<Cell>>.generate(
      6, (x) => List<Cell>.generate(6, (y) => Cell(x, y, CellState.covered)));
  return CellsManager(ref.read, cells);
});

class CellsManager extends StateNotifier<List<List<Cell>>> {
  CellsManager(this.ref, List<List<Cell>> cells) : super(cells);

  final Reader ref;

  reset() {
    state.clear();
    state = List<List<Cell>>.generate(
        6, (x) => List<Cell>.generate(6, (y) => Cell(x, y, CellState.covered)));
  }

  isFlagged(int x, int y) => state[x][y].state == CellState.flagged;
  isOpen(int x, int y) => state[x][y].state == CellState.open;
  isBlown(int x, int y) => state[x][y].state == CellState.blown;

  setCellState(int x, int y, CellState cellState) =>
      state[x][y].state = cellState;
}
