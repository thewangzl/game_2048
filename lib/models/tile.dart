class Position {
  final int row;
  final int col;

  Position(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && runtimeType == other.runtimeType && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class Tile {
  int value;
  Position position;
  bool merged;  // 标记是否已经合并过

  Tile({
    required this.value,
    required this.position,
    this.merged = false,
  });

  Tile copy() {
    return Tile(
      value: value,
      position: Position(position.row, position.col),
      merged: merged,
    );
  }
}