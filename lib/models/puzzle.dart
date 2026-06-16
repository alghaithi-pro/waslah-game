enum ClueDir { across, down }

class CrosswordClue {
  final int number;
  final ClueDir direction;
  final String clue;
  final String answer;
  final int startRow;
  final int startCol;

  const CrosswordClue({
    required this.number,
    required this.direction,
    required this.clue,
    required this.answer,
    required this.startRow,
    required this.startCol,
  });

  int get length => answer.length;

  // across: letters go LEFT (decreasing col) — Arabic RTL
  // down:   letters go DOWN (increasing row)
  List<(int, int)> get cells => direction == ClueDir.across
      ? List.generate(length, (i) => (startRow, startCol - i))
      : List.generate(length, (i) => (startRow + i, startCol));

  bool containsCell(int r, int c) => cells.any((x) => x.$1 == r && x.$2 == c);

  int indexOfCell(int r, int c) {
    final list = cells;
    for (int i = 0; i < list.length; i++) {
      if (list[i].$1 == r && list[i].$2 == c) return i;
    }
    return -1;
  }
}

class CrosswordPuzzle {
  final int id;
  final String title;
  final int gridRows;
  final int gridCols;
  final List<CrosswordClue> clues;

  const CrosswordPuzzle({
    required this.id,
    required this.title,
    required this.gridRows,
    required this.gridCols,
    required this.clues,
  });

  Set<(int, int)> get activeCells {
    final s = <(int, int)>{};
    for (final c in clues) s.addAll(c.cells);
    return s;
  }

  Map<(int, int), String> get answerMap {
    final m = <(int, int), String>{};
    for (final c in clues) {
      final cs = c.cells;
      for (int i = 0; i < cs.length; i++) {
        m[cs[i]] = c.answer[i];
      }
    }
    return m;
  }

  // Which clues START at this cell
  List<CrosswordClue> cluesStartingAt(int r, int c) =>
      clues.where((cl) => cl.startRow == r && cl.startCol == c).toList();

  // Which clues CONTAIN this cell
  List<CrosswordClue> cluesContaining(int r, int c) =>
      clues.where((cl) => cl.containsCell(r, c)).toList();
}

class PuzzlePack {
  final String name;
  final String emoji;
  final List<CrosswordPuzzle> puzzles;
  const PuzzlePack({required this.name, required this.emoji, required this.puzzles});
}
