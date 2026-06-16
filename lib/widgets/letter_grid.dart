import 'dart:math';
import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/app_colors.dart';

class LetterGrid extends StatefulWidget {
  final Puzzle puzzle;
  final Set<String> foundWords;
  final void Function(WordEntry entry) onWordFound;

  const LetterGrid({
    super.key,
    required this.puzzle,
    required this.foundWords,
    required this.onWordFound,
  });

  @override
  State<LetterGrid> createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  List<(int, int)> _selected = [];
  (int, int)? _startCell;

  Puzzle get puzzle => widget.puzzle;

  (int, int)? _cellAt(Offset pos, double cellSize) {
    final col = (pos.dx / cellSize).floor();
    final row = (pos.dy / cellSize).floor();
    if (row < 0 || row >= puzzle.rows || col < 0 || col >= puzzle.cols) return null;
    if (puzzle.grid[row][col] == null) return null;
    return (row, col);
  }

  void _onPanStart(Offset pos, double cellSize) {
    final cell = _cellAt(pos, cellSize);
    if (cell == null) return;
    setState(() {
      _startCell = cell;
      _selected = [cell];
    });
  }

  void _onPanUpdate(Offset pos, double cellSize) {
    if (_startCell == null) return;
    final cell = _cellAt(pos, cellSize);
    if (cell == null) return;

    final (sr, sc) = _startCell!;
    final (er, ec) = cell;

    final dr = (er - sr).sign;
    final dc = (ec - sc).sign;
    if (dr == 0 && dc == 0) return;

    final distR = (er - sr).abs();
    final distC = (ec - sc).abs();
    if (dr != 0 && dc != 0 && distR != distC) return;

    final steps = max(distR, distC);
    final newSelected = List.generate(
      steps + 1,
      (i) => (sr + i * dr, sc + i * dc),
    );

    if (newSelected.any((c) => puzzle.grid[c.$1][c.$2] == null)) return;

    setState(() => _selected = newSelected);
  }

  void _onPanEnd() {
    if (_selected.length >= 2) {
      final letters = _selected
          .map((c) => puzzle.grid[c.$1][c.$2]!)
          .join();
      final reversed = letters.split('').reversed.join();

      for (final entry in puzzle.words) {
        if (!widget.foundWords.contains(entry.word)) {
          if (entry.word == letters || entry.word == reversed) {
            widget.onWordFound(entry);
            break;
          }
        }
      }
    }
    setState(() {
      _selected = [];
      _startCell = null;
    });
  }

  bool _isCellFound(int row, int col) {
    for (final entry in puzzle.words) {
      if (widget.foundWords.contains(entry.word) && entry.containsCell(row, col)) {
        return true;
      }
    }
    return false;
  }

  bool _isCellSelected(int row, int col) =>
      _selected.any((c) => c.$1 == row && c.$2 == col);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cellSize = constraints.maxWidth / puzzle.cols;
      final gridHeight = cellSize * puzzle.rows;

      return GestureDetector(
        onPanStart: (d) => _onPanStart(d.localPosition, cellSize),
        onPanUpdate: (d) => _onPanUpdate(d.localPosition, cellSize),
        onPanEnd: (_) => _onPanEnd(),
        child: SizedBox(
          width: constraints.maxWidth,
          height: gridHeight,
          child: Stack(
            children: [
              // Cells
              for (int r = 0; r < puzzle.rows; r++)
                for (int c = 0; c < puzzle.cols; c++)
                  if (puzzle.grid[r][c] != null)
                    Positioned(
                      left: c * cellSize,
                      top: r * cellSize,
                      width: cellSize,
                      height: cellSize,
                      child: _GridCell(
                        letter: puzzle.grid[r][c]!,
                        isSelected: _isCellSelected(r, c),
                        isFound: _isCellFound(r, c),
                        cellSize: cellSize,
                      ),
                    ),
              // Selection line overlay
              if (_selected.length > 1)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _SelectionPainter(
                        selected: _selected,
                        cellSize: cellSize,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _GridCell extends StatelessWidget {
  final String letter;
  final bool isSelected;
  final bool isFound;
  final double cellSize;

  const _GridCell({
    required this.letter,
    required this.isSelected,
    required this.isFound,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    List<BoxShadow> shadows;

    if (isFound) {
      bg = AppColors.tileFound;
      textColor = Colors.white;
      shadows = [
        BoxShadow(color: AppColors.tileFoundGlow.withOpacity(0.6), blurRadius: 8, spreadRadius: 1),
      ];
    } else if (isSelected) {
      bg = AppColors.tileSelecting;
      textColor = AppColors.tileSelectingText;
      shadows = [
        BoxShadow(color: Colors.yellow.withOpacity(0.4), blurRadius: 6, spreadRadius: 1),
      ];
    } else {
      bg = AppColors.tile;
      textColor = Colors.white;
      shadows = [
        BoxShadow(color: AppColors.tileShadow, blurRadius: 3, offset: const Offset(0, 2)),
      ];
    }

    return Padding(
      padding: EdgeInsets.all(cellSize * 0.06),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(cellSize * 0.18),
          boxShadow: shadows,
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: textColor,
              fontSize: cellSize * 0.44,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionPainter extends CustomPainter {
  final List<(int, int)> selected;
  final double cellSize;

  const _SelectionPainter({required this.selected, required this.cellSize});

  Offset _center(int row, int col) => Offset(
        col * cellSize + cellSize / 2,
        row * cellSize + cellSize / 2,
      );

  @override
  void paint(Canvas canvas, Size size) {
    if (selected.length < 2) return;
    final paint = Paint()
      ..color = AppColors.tileSelecting.withOpacity(0.45)
      ..strokeWidth = cellSize * 0.55
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(_center(selected[0].$1, selected[0].$2).dx,
        _center(selected[0].$1, selected[0].$2).dy);
    for (int i = 1; i < selected.length; i++) {
      final c = _center(selected[i].$1, selected[i].$2);
      path.lineTo(c.dx, c.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SelectionPainter old) =>
      old.selected != selected || old.cellSize != cellSize;
}
