import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';

class GameScreen extends StatefulWidget {
  final CrosswordLevel level;
  final int levelNumber;
  final String groupName;

  const GameScreen({
    super.key,
    required this.level,
    required this.levelNumber,
    required this.groupName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  CrosswordLevel get level => widget.level;

  late final Map<String, String> _solution;
  late Map<String, String> _userGrid;
  late Set<String> _revealed;
  final Set<String> _wrongCells = {};

  CrosswordWord? _selectedWord;
  int _cursorIndex = 0;

  bool get _isComplete => level.activeCells.every((key) {
        final entered = _userGrid[key] ?? '';
        return entered == _solution[key];
      });

  @override
  void initState() {
    super.initState();
    _solution = level.buildSolutionGrid();
    _userGrid = Map.from(Progress.getLevelState(level.id));
    _revealed = Progress.getRevealedCells(level.id);
  }

  // ── Word selection ─────────────────────────────────────────────────────────

  void _selectWord(CrosswordWord word) {
    setState(() {
      _selectedWord = word;
      _wrongCells.clear();
      _cursorIndex = 0;
      for (int i = 0; i < word.answer.length; i++) {
        final key = _cellKey(word, i);
        if ((_userGrid[key] ?? '').isEmpty) {
          _cursorIndex = i;
          break;
        }
        _cursorIndex = word.answer.length - 1;
      }
    });
  }

  void _onCellTap(int row, int col) {
    final key = '$row,$col';
    if (!level.activeCells.contains(key)) return;

    final candidates =
        level.words.where((w) => w.cells.contains((row, col))).toList();
    if (candidates.isEmpty) return;

    if (candidates.length == 1) {
      _selectWord(candidates[0]);
      _cursorIndex = candidates[0].cells.indexWhere((c) => c == (row, col));
      setState(() {});
      return;
    }

    if (_selectedWord != null && candidates.contains(_selectedWord!)) {
      final other = candidates.firstWhere((w) => w != _selectedWord!);
      _selectWord(other);
    } else {
      _selectWord(candidates[0]);
    }
    _cursorIndex =
        _selectedWord!.cells.indexWhere((c) => c == (row, col));
    setState(() {});
  }

  // ── Keyboard input ─────────────────────────────────────────────────────────

  void _onLetterTap(String letter) {
    if (_selectedWord == null) return;
    final word = _selectedWord!;
    if (_cursorIndex >= word.answer.length) return;

    final key = _cellKey(word, _cursorIndex);
    if (_revealed.contains(key)) {
      _moveCursor(1);
      return;
    }

    setState(() {
      _userGrid[key] = letter;
      _wrongCells.remove(key);
    });
    Progress.saveLevelState(level.id, _userGrid);

    if (_isComplete) {
      _onLevelComplete();
      return;
    }
    _moveCursor(1);
  }

  void _onDelete() {
    if (_selectedWord == null) return;
    final key = _cellKey(_selectedWord!, _cursorIndex);
    if (_revealed.contains(key)) {
      _moveCursor(-1);
      return;
    }
    if ((_userGrid[key] ?? '').isNotEmpty) {
      setState(() => _userGrid.remove(key));
      Progress.saveLevelState(level.id, _userGrid);
    } else {
      _moveCursor(-1);
    }
  }

  void _moveCursor(int delta) {
    if (_selectedWord == null) return;
    setState(() {
      _cursorIndex =
          (_cursorIndex + delta).clamp(0, _selectedWord!.answer.length - 1);
    });
  }

  String _cellKey(CrosswordWord word, int i) {
    final cell = word.cells[i];
    return '${cell.$1},${cell.$2}';
  }

  // ── Hints ──────────────────────────────────────────────────────────────────

  Future<void> _revealLetter() async {
    if (_selectedWord == null) return;
    final key = _cellKey(_selectedWord!, _cursorIndex);
    if (_revealed.contains(key)) return;

    final ok = await Progress.spendCoins(Progress.revealLetterCost);
    if (!ok) { _showSnack('رصيدك من العملات غير كافٍ'); return; }

    setState(() {
      _userGrid[key] = _solution[key]!;
      _revealed.add(key);
      _wrongCells.remove(key);
    });
    await Progress.addRevealedCell(level.id, key);
    await Progress.saveLevelState(level.id, _userGrid);
    if (_isComplete) _onLevelComplete();
  }

  Future<void> _checkErrors() async {
    final ok = await Progress.spendCoins(Progress.checkErrorsCost);
    if (!ok) { _showSnack('رصيدك من العملات غير كافٍ'); return; }
    setState(() {
      _wrongCells.clear();
      for (final key in _userGrid.keys) {
        final entered = _userGrid[key] ?? '';
        if (entered.isNotEmpty && entered != _solution[key]) {
          _wrongCells.add(key);
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _wrongCells.clear());
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  // ── Win ────────────────────────────────────────────────────────────────────

  void _onLevelComplete() {
    final stars = _revealed.isEmpty ? 3 : 2;
    Progress.completeLevel(level.id, stars: stars);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _showWinDialog(stars);
    });
  }

  void _showWinDialog(int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _WinDialog(
        stars: stars,
        coins: stars * 5,
        onNext: () { Navigator.pop(context); Navigator.pop(context); },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(
                groupName: widget.groupName,
                levelNumber: widget.levelNumber,
                coins: Progress.coins,
                onBack: () => Navigator.pop(context),
                onReveal: _revealLetter,
                onCheck: _checkErrors,
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _CrosswordGrid(
                    level: level,
                    userGrid: _userGrid,
                    solution: _solution,
                    revealed: _revealed,
                    wrongCells: _wrongCells,
                    selectedWord: _selectedWord,
                    cursorIndex: _cursorIndex,
                    onCellTap: _onCellTap,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              if (_selectedWord != null) _ClueDisplay(word: _selectedWord!),
              const SizedBox(height: 6),
              _ArabicKeyboard(
                letters: level.keyboardLetters(),
                onLetter: _onLetterTap,
                onDelete: _onDelete,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String groupName;
  final int levelNumber;
  final int coins;
  final VoidCallback onBack;
  final VoidCallback onReveal;
  final VoidCallback onCheck;

  const _TopBar({
    required this.groupName,
    required this.levelNumber,
    required this.coins,
    required this.onBack,
    required this.onReveal,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navBar,
      height: 52,
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            label: const Text('رجوع', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Expanded(
            child: Text(
              '$groupName — المستوى $levelNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text('$coins', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(width: 2),
              const Icon(Icons.monetization_on, color: AppColors.gold, size: 18),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 22),
            tooltip: 'كشف حرف (${Progress.revealLetterCost} عملة)',
            onPressed: onReveal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
            tooltip: 'تدقيق الأخطاء (${Progress.checkErrorsCost} عملات)',
            onPressed: onCheck,
            padding: const EdgeInsets.only(right: 8),
          ),
        ],
      ),
    );
  }
}

// ─── Crossword Grid ───────────────────────────────────────────────────────────

class _CrosswordGrid extends StatelessWidget {
  final CrosswordLevel level;
  final Map<String, String> userGrid;
  final Map<String, String> solution;
  final Set<String> revealed;
  final Set<String> wrongCells;
  final CrosswordWord? selectedWord;
  final int cursorIndex;
  final void Function(int, int) onCellTap;

  const _CrosswordGrid({
    required this.level,
    required this.userGrid,
    required this.solution,
    required this.revealed,
    required this.wrongCells,
    required this.selectedWord,
    required this.cursorIndex,
    required this.onCellTap,
  });

  bool _inSelectedWord(int r, int c) =>
      selectedWord?.cells.contains((r, c)) ?? false;

  bool _isCursor(int r, int c) {
    if (selectedWord == null) return false;
    final cells = selectedWord!.cells;
    if (cursorIndex >= cells.length) return false;
    return cells[cursorIndex] == (r, c);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: level.cols / level.rows,
      child: Column(
        children: List.generate(level.rows, (r) => Expanded(
          child: Row(
            children: List.generate(level.cols, (c) {
              final key    = '$r,$c';
              final active = level.activeCells.contains(key);
              if (!active) {
                return Expanded(child: Container(color: AppColors.navDark, margin: const EdgeInsets.all(1.5)));
              }
              return Expanded(
                child: GestureDetector(
                  onTap: () => onCellTap(r, c),
                  child: _GridCell(
                    letter: userGrid[key] ?? '',
                    isRevealed: revealed.contains(key),
                    isWrong: wrongCells.contains(key),
                    inSelectedWord: _inSelectedWord(r, c),
                    isCursor: _isCursor(r, c),
                  ),
                ),
              );
            }),
          ),
        )),
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final String letter;
  final bool isRevealed;
  final bool isWrong;
  final bool inSelectedWord;
  final bool isCursor;

  const _GridCell({
    required this.letter,
    required this.isRevealed,
    required this.isWrong,
    required this.inSelectedWord,
    required this.isCursor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor = AppColors.navDark;

    if (isWrong) {
      bg = AppColors.cellWrong; textColor = Colors.white;
    } else if (isRevealed) {
      bg = AppColors.cellCorrect; textColor = Colors.white;
    } else if (isCursor) {
      bg = AppColors.gold; textColor = Colors.white;
    } else if (inSelectedWord) {
      bg = AppColors.cellActive;
    } else if (letter.isNotEmpty) {
      bg = AppColors.cellFilled;
    } else {
      bg = AppColors.cellEmpty;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        border: isCursor ? Border.all(color: AppColors.goldDark, width: 2) : null,
      ),
      child: Center(
        child: FittedBox(
          child: Text(letter,
              style: TextStyle(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ─── Clue Display ─────────────────────────────────────────────────────────────

class _ClueDisplay extends StatelessWidget {
  final CrosswordWord word;
  const _ClueDisplay({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            word.direction == WordDirection.horizontal ? Icons.swap_horiz : Icons.swap_vert,
            color: AppColors.gold, size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(word.clueText,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.navDark, borderRadius: BorderRadius.circular(8)),
            child: Text('${word.answer.length} أحرف',
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

// ─── Arabic Keyboard ──────────────────────────────────────────────────────────

class _ArabicKeyboard extends StatelessWidget {
  final List<String> letters;
  final void Function(String) onLetter;
  final VoidCallback onDelete;

  const _ArabicKeyboard({
    required this.letters,
    required this.onLetter,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final perRow = (letters.length / 3).ceil();
    final rows   = <List<String>>[];
    for (int i = 0; i < letters.length; i += perRow) {
      rows.add(letters.sublist(i, (i + perRow).clamp(0, letters.length)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...rows.map((row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((ch) => _KeyButton(letter: ch, onTap: () => onLetter(ch))).toList(),
              )),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 80, height: 40,
              decoration: BoxDecoration(color: AppColors.navDark, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Icon(Icons.backspace_outlined, color: Colors.white, size: 22)),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;
  const _KeyButton({required this.letter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppColors.keyBg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2))],
        ),
        child: Center(
          child: Text(letter,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// ─── Win Dialog ───────────────────────────────────────────────────────────────

class _WinDialog extends StatelessWidget {
  final int stars;
  final int coins;
  final VoidCallback onNext;
  const _WinDialog({required this.stars, required this.coins, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أحسنت!',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(i < stars ? Icons.star : Icons.star_border,
                    color: AppColors.gold, size: 42),
              )),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('+$coins', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                const Icon(Icons.monetization_on, color: AppColors.gold, size: 26),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onNext,
                child: const Text('التالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
