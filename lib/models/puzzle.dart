class WordEntry {
  final String word;
  final int startRow;
  final int startCol;
  final int dirRow;
  final int dirCol;

  const WordEntry({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.dirRow,
    required this.dirCol,
  });

  List<(int, int)> get cells => List.generate(
        word.length,
        (i) => (startRow + i * dirRow, startCol + i * dirCol),
      );

  bool containsCell(int row, int col) =>
      cells.any((c) => c.$1 == row && c.$2 == col);
}

class Puzzle {
  final int number;
  final String category;
  final String topic;
  final List<List<String?>> grid;
  final List<WordEntry> words;

  const Puzzle({
    required this.number,
    required this.category,
    required this.topic,
    required this.grid,
    required this.words,
  });

  int get rows => grid.length;
  int get cols => grid.isNotEmpty ? grid[0].length : 0;
  String? letterAt(int r, int c) => grid[r][c];
}

class Category {
  final String name;
  final String emoji;
  final int colorIndex;
  final List<Puzzle> puzzles;

  const Category({
    required this.name,
    required this.emoji,
    required this.colorIndex,
    required this.puzzles,
  });
}
