import 'dart:math';

enum ClueType { text, image, logo, phrase, flag }

enum WordDirection { horizontal, vertical }

class CrosswordWord {
  final int id;
  final String answer;
  final ClueType clueType;
  final String clueText;
  final String? clueAsset;
  final int startRow;
  final int startCol;
  final WordDirection direction;

  const CrosswordWord({
    required this.id,
    required this.answer,
    required this.clueType,
    required this.clueText,
    this.clueAsset,
    required this.startRow,
    required this.startCol,
    required this.direction,
  });

  List<(int, int)> get cells => List.generate(
        answer.length,
        (i) => direction == WordDirection.horizontal
            ? (startRow, startCol + i)
            : (startRow + i, startCol),
      );

  int get endRow => direction == WordDirection.horizontal
      ? startRow
      : startRow + answer.length - 1;

  int get endCol => direction == WordDirection.horizontal
      ? startCol + answer.length - 1
      : startCol;
}

class CrosswordLevel {
  final int id;
  final int number;
  final int rows;
  final int cols;
  final List<CrosswordWord> words;

  const CrosswordLevel({
    required this.id,
    required this.number,
    required this.rows,
    required this.cols,
    required this.words,
  });

  /// Solution grid: key = 'row,col' → correct letter
  Map<String, String> buildSolutionGrid() {
    final grid = <String, String>{};
    for (final word in words) {
      for (int i = 0; i < word.answer.length; i++) {
        final key = word.direction == WordDirection.horizontal
            ? '${word.startRow},${word.startCol + i}'
            : '${word.startRow + i},${word.startCol}';
        grid[key] = word.answer[i];
      }
    }
    return grid;
  }

  /// All active cell keys that belong to at least one word
  Set<String> get activeCells {
    final cells = <String>{};
    for (final word in words) {
      for (final cell in word.cells) {
        cells.add('${cell.$1},${cell.$2}');
      }
    }
    return cells;
  }

  /// Shuffled letters for the custom keyboard (word letters + distractors)
  List<String> keyboardLetters({int distractorCount = 4}) {
    final unique = <String>{};
    for (final word in words) {
      unique.addAll(word.answer.split(''));
    }
    const pool = 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي';
    final rng = Random(id * 31);
    final result = unique.toList();
    int added = 0;
    int tries = 0;
    while (added < distractorCount && tries < 200) {
      final ch = pool[rng.nextInt(pool.length)];
      if (!unique.contains(ch)) {
        result.add(ch);
        unique.add(ch);
        added++;
      }
      tries++;
    }
    result.shuffle(rng);
    return result;
  }
}

class CrosswordGroup {
  final int id;
  final String name;
  final int starsRequired;
  final List<CrosswordLevel> levels;

  const CrosswordGroup({
    required this.id,
    required this.name,
    required this.starsRequired,
    required this.levels,
  });

  int get totalStarsPossible => levels.length * 3;
}
