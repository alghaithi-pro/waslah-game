import 'dart:math';

enum Difficulty { easy, medium, hard }

class WordPlacement {
  final String word;
  final String clue;
  final int row;
  final int col;
  final bool horizontal;

  const WordPlacement({
    required this.word,
    required this.clue,
    required this.row,
    required this.col,
    required this.horizontal,
  });
}

class WordSearchLevel {
  final int id;
  final String name;
  final Difficulty difficulty;
  final int rows;
  final int cols;
  final List<WordPlacement> words;

  const WordSearchLevel({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.rows,
    required this.cols,
    required this.words,
  });

  List<List<String>> buildGrid() {
    final grid = List.generate(rows, (_) => List.filled(cols, ''));
    for (final wp in words) {
      for (int i = 0; i < wp.word.length; i++) {
        if (wp.horizontal) {
          grid[wp.row][wp.col + i] = wp.word[i];
        } else {
          grid[wp.row + i][wp.col] = wp.word[i];
        }
      }
    }
    const arabic = 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي';
    final rng = Random(id * 13 + rows * 7);
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].isEmpty) {
          grid[r][c] = arabic[rng.nextInt(arabic.length)];
        }
      }
    }
    return grid;
  }
}

class WordSearchGroup {
  final int id;
  final String name;
  final int starsRequired;
  final List<WordSearchLevel> levels;

  const WordSearchGroup({
    required this.id,
    required this.name,
    required this.starsRequired,
    required this.levels,
  });
}
