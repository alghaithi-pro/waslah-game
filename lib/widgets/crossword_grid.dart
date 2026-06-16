import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/colors.dart';

class CrosswordGrid extends StatelessWidget {
  final CrosswordPuzzle puzzle;
  final Map<(int, int), String> playerAnswers;
  final CrosswordClue? selectedClue;
  final (int, int)? cursorCell;
  final void Function(int row, int col) onCellTap;

  const CrosswordGrid({
    super.key,
    required this.puzzle,
    required this.playerAnswers,
    required this.selectedClue,
    required this.cursorCell,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = puzzle.activeCells;
    final answers = puzzle.answerMap;

    // Compute bounding box of active cells
    if (active.isEmpty) return const SizedBox.shrink();
    int minR = 999, maxR = 0, minC = 999, maxC = 0;
    for (final c in active) {
      if (c.$1 < minR) minR = c.$1;
      if (c.$1 > maxR) maxR = c.$1;
      if (c.$2 < minC) minC = c.$2;
      if (c.$2 > maxC) maxC = c.$2;
    }

    final rows = maxR - minR + 1;
    final cols = maxC - minC + 1;

    return LayoutBuilder(builder: (context, constraints) {
      final cellSize = (constraints.maxWidth / cols).clamp(28.0, 60.0);
      final gridW = cellSize * cols;
      final gridH = cellSize * rows;

      return SizedBox(
        width: gridW,
        height: gridH,
        child: Stack(
          children: [
            for (int r = minR; r <= maxR; r++)
              for (int c = minC; c <= maxC; c++)
                Positioned(
                  left: (c - minC) * cellSize,
                  top:  (r - minR) * cellSize,
                  width:  cellSize,
                  height: cellSize,
                  child: _buildCell(r, c, cellSize, active, answers),
                ),
          ],
        ),
      );
    });
  }

  Widget _buildCell(int r, int c, double size,
      Set<(int, int)> active, Map<(int, int), String> answers) {
    if (!active.contains((r, c))) {
      return Container(color: AppColors.cellInactive);
    }

    final isSelected = selectedClue?.containsCell(r, c) ?? false;
    final isCursor   = cursorCell?.$1 == r && cursorCell?.$2 == c;
    final playerLetter = playerAnswers[(r, c)];
    final correctLetter = answers[(r, c)];
    final isSolved = playerLetter != null && playerLetter == correctLetter;

    Color bg;
    if (isCursor) {
      bg = AppColors.cellCursor;
    } else if (isSelected) {
      bg = AppColors.cellSelected;
    } else if (isSolved) {
      bg = AppColors.cellCorrect;
    } else {
      bg = AppColors.cellActive;
    }

    // Clue number in this cell?
    final starters = puzzle.cluesStartingAt(r, c);
    final cellNumber = starters.isNotEmpty ? starters.first.number : null;

    return GestureDetector(
      onTap: () => onCellTap(r, c),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: AppColors.gridBorder, width: 0.7),
        ),
        child: Stack(
          children: [
            // Clue number
            if (cellNumber != null)
              Positioned(
                top: 1,
                right: 2,
                child: Text(
                  '$cellNumber',
                  style: TextStyle(
                    fontSize: size * 0.22,
                    color: isCursor || isSelected
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.cellNumber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Letter
            if (playerLetter != null)
              Center(
                child: Text(
                  playerLetter,
                  style: TextStyle(
                    fontSize: size * 0.48,
                    fontWeight: FontWeight.w900,
                    color: isCursor || isSelected
                        ? Colors.white
                        : AppColors.cellText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
