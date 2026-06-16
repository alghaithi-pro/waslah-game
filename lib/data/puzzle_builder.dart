import 'dart:math';
import '../models/puzzle.dart';

class PuzzleBuilder {
  static const _shape = [
    [2, 3, 4],
    [1, 2, 3, 4, 5],
    [0, 1, 2, 3, 4, 5, 6],
    [0, 1, 2, 3, 4, 5, 6],
    [0, 1, 2, 3, 4, 5, 6],
    [1, 2, 3, 4, 5],
    [2, 3, 4],
  ];

  static const _fillPool = 'بتثجحخرزسشصضطظعغكلمنهوي';

  static const _dirs = [
    (0, 1), (0, -1), (1, 0), (-1, 0),
    (1, 1), (1, -1), (-1, 1), (-1, -1),
  ];

  static bool _active(int r, int c) {
    if (r < 0 || r >= 7 || c < 0 || c >= 7) return false;
    return _shape[r].contains(c);
  }

  static bool _canPlace(List<List<String?>> g, String w, int r, int c, int dr, int dc) {
    for (int i = 0; i < w.length; i++) {
      final nr = r + i * dr, nc = c + i * dc;
      if (!_active(nr, nc)) return false;
      final cell = g[nr][nc];
      if (cell != null && cell.isNotEmpty && cell != w[i]) return false;
    }
    return true;
  }

  static WordEntry _place(List<List<String?>> g, String w, int r, int c, int dr, int dc) {
    for (int i = 0; i < w.length; i++) {
      g[r + i * dr][c + i * dc] = w[i];
    }
    return WordEntry(word: w, startRow: r, startCol: c, dirRow: dr, dirCol: dc);
  }

  static List<(int, int)> _allActive() {
    final list = <(int, int)>[];
    for (int r = 0; r < 7; r++) {
      for (final c in _shape[r]) list.add((r, c));
    }
    return list;
  }

  static Puzzle build({
    required int number,
    required String category,
    required String topic,
    required List<String> words,
    required int seed,
  }) {
    final rng = Random(seed);
    final grid = List.generate(7, (_) => List<String?>.filled(7, null));

    for (int r = 0; r < 7; r++) {
      for (final c in _shape[r]) grid[r][c] = '';
    }

    final wordEntries = <WordEntry>[];
    final activePositions = _allActive();

    for (final word in words) {
      final dirs = [..._dirs]..shuffle(rng);
      final positions = [...activePositions]..shuffle(rng);
      bool placed = false;

      outer:
      for (final (dr, dc) in dirs) {
        for (final (r, c) in positions) {
          if (_canPlace(grid, word, r, c, dr, dc)) {
            wordEntries.add(_place(grid, word, r, c, dr, dc));
            placed = true;
            break outer;
          }
        }
      }

      if (!placed) {
        // Fallback: force into row 3 left-to-right
        for (int c = 0; c <= 7 - word.length; c++) {
          if (_active(3, c) && _active(3, c + word.length - 1)) {
            wordEntries.add(_place(grid, word, 3, c, 0, 1));
            break;
          }
        }
      }
    }

    // Fill empty active cells
    final pool = _fillPool.split('');
    for (int r = 0; r < 7; r++) {
      for (int c = 0; c < 7; c++) {
        if (grid[r][c] != null && grid[r][c]!.isEmpty) {
          grid[r][c] = pool[rng.nextInt(pool.length)];
        }
      }
    }

    return Puzzle(
      number: number,
      category: category,
      topic: topic,
      grid: grid,
      words: wordEntries,
    );
  }
}
