import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/colors.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/arabic_keyboard.dart';
import 'win_screen.dart';

class GameScreen extends StatefulWidget {
  final CrosswordPuzzle puzzle;
  const GameScreen({super.key, required this.puzzle});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  CrosswordPuzzle get puzzle => widget.puzzle;

  final Map<(int, int), String> _answers = {};
  CrosswordClue? _selectedClue;
  (int, int)? _cursorCell;

  @override
  void initState() {
    super.initState();
    // Select first clue by default
    if (puzzle.clues.isNotEmpty) {
      _selectedClue = puzzle.clues.first;
      _cursorCell = _selectedClue!.cells.first;
    }
  }

  // All clues solved?
  bool get _isComplete {
    final ansMap = puzzle.answerMap;
    return ansMap.keys.every((cell) => _answers[cell] == ansMap[cell]);
  }

  void _onCellTap(int r, int c) {
    final clues = puzzle.cluesContaining(r, c);
    if (clues.isEmpty) return;

    if (_selectedClue != null && clues.contains(_selectedClue) &&
        _cursorCell?.$1 == r && _cursorCell?.$2 == c) {
      // Toggle direction if both directions available
      final other = clues.where((cl) => cl != _selectedClue).toList();
      if (other.isNotEmpty) {
        setState(() {
          _selectedClue = other.first;
          _cursorCell   = (r, c);
        });
        return;
      }
    }

    setState(() {
      _selectedClue = clues.first;
      _cursorCell   = (r, c);
    });
  }

  void _onLetter(String letter) {
    if (_cursorCell == null || _selectedClue == null) return;
    final cell = _cursorCell!;
    setState(() {
      _answers[cell] = letter;
    });

    if (_isComplete) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => WinScreen(puzzle: puzzle)));
      });
      return;
    }

    _advanceCursor();
  }

  void _onDelete() {
    if (_cursorCell == null || _selectedClue == null) return;
    final cell = _cursorCell!;
    if (_answers.containsKey(cell)) {
      setState(() => _answers.remove(cell));
    } else {
      _retreatCursor();
    }
  }

  void _advanceCursor() {
    if (_selectedClue == null || _cursorCell == null) return;
    final cells = _selectedClue!.cells;
    final idx   = _selectedClue!.indexOfCell(_cursorCell!.$1, _cursorCell!.$2);
    // Find next empty cell
    for (int i = idx + 1; i < cells.length; i++) {
      if (_answers[cells[i]] == null) {
        setState(() => _cursorCell = cells[i]);
        return;
      }
    }
    // Wrap: find first empty
    for (int i = 0; i < cells.length; i++) {
      if (_answers[cells[i]] == null) {
        setState(() => _cursorCell = cells[i]);
        return;
      }
    }
  }

  void _retreatCursor() {
    if (_selectedClue == null || _cursorCell == null) return;
    final cells = _selectedClue!.cells;
    final idx   = _selectedClue!.indexOfCell(_cursorCell!.$1, _cursorCell!.$2);
    if (idx > 0) {
      setState(() => _cursorCell = cells[idx - 1]);
    }
  }

  // Toggle horizontal ↔ vertical for the current cell
  void _toggleDirection() {
    if (_cursorCell == null) return;
    final r = _cursorCell!.$1, c = _cursorCell!.$2;
    final clues = puzzle.cluesContaining(r, c);
    if (clues.length < 2) return;
    final other = clues.firstWhere((cl) => cl != _selectedClue,
        orElse: () => clues.first);
    setState(() {
      _selectedClue = other;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _TopBar(
              puzzle: puzzle,
              onBack: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            // Grid
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: CrosswordGrid(
                    puzzle: puzzle,
                    playerAnswers: _answers,
                    selectedClue: _selectedClue,
                    cursorCell: _cursorCell,
                    onCellTap: _onCellTap,
                  ),
                ),
              ),
            ),
            // Clue panel
            _CluePanel(
              clue: _selectedClue,
              onToggle: _toggleDirection,
            ),
            // Arabic keyboard
            ArabicKeyboard(
              onLetter: _onLetter,
              onDelete: _onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final CrosswordPuzzle puzzle;
  final VoidCallback onBack;
  const _TopBar({required this.puzzle, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.btnMain,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              puzzle.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _CluePanel extends StatelessWidget {
  final CrosswordClue? clue;
  final VoidCallback onToggle;
  const _CluePanel({required this.clue, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final dir = clue?.direction == ClueDir.across ? 'أفقي' : 'رأسي';
    final num = clue?.number ?? '';

    return Container(
      color: AppColors.cluePanel,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Direction toggle
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.btnIcon,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$num $dir',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Clue text
          Expanded(
            child: Text(
              clue?.clue ?? 'اختر خلية',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
