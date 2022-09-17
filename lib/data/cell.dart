enum CellState { covered, blown, open, flagged, revealed }

class Cell {
  int row;
  int col;
  CellState state;
  Cell(this.row, this.col, this.state);
}
