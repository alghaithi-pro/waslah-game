import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';

class GameScreen extends StatefulWidget {
  final WordSearchLevel level;
  final int levelNumber;
  const GameScreen({super.key, required this.level, required this.levelNumber});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  WordSearchLevel get level => widget.level;

  late List<List<String>> _grid;
  late List<bool>         _found;
  final Set<int>          _foundCells    = {};
  Set<int>                _selectedCells = {};

  // ── gesture state ──────────────────────────────────────────────────────────
  final _gridKey = GlobalKey();
  int? _startRow, _startCol;
  int? _curRow,   _curCol;
  bool _wrongFlash = false;

  @override
  void initState() {
    super.initState();
    _grid  = level.buildGrid();
    _found = List.filled(level.words.length, false);
  }

  int  get _foundCount => _found.where((f) => f).length;
  bool get _allFound   => _foundCount == level.words.length;

  // ── coordinate helper ──────────────────────────────────────────────────────

  /// Maps a global screen offset → (row, logicalCol) inside the grid.
  /// Returns null if the offset is outside the grid.
  (int, int)? _cellAt(Offset global) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final local = box.globalToLocal(global);
    final cols  = level.cols;
    final rows  = level.rows;
    final cw    = box.size.width  / cols;
    final ch    = box.size.height / rows;
    final vCol  = (local.dx / cw).floor();   // visual index (RTL: 0 = leftmost)
    final lCol  = cols - 1 - vCol;           // logical col (RTL flip)
    final row   = (local.dy / ch).floor();
    if (row < 0 || row >= rows || lCol < 0 || lCol >= cols) return null;
    return (row, lCol);
  }

  // ── selection computation ──────────────────────────────────────────────────

  Set<int> _computeSelection(int sr, int sc, int cr, int cc) {
    final cells = <int>{};
    final dr = cr - sr;
    final dc = cc - sc;

    if (dr == 0 && dc == 0) {
      cells.add(sr * 100 + sc);
      return cells;
    }

    if (dr.abs() >= dc.abs()) {
      // vertical
      final step = dr > 0 ? 1 : -1;
      for (int r = sr; r != cr + step; r += step) { cells.add(r * 100 + sc); }
    } else {
      // horizontal
      final step = dc > 0 ? 1 : -1;
      for (int c = sc; c != cc + step; c += step) { cells.add(sr * 100 + c); }
    }
    return cells;
  }

  // ── gesture handlers ───────────────────────────────────────────────────────

  void _onPanStart(DragStartDetails d) {
    final cell = _cellAt(d.globalPosition);
    if (cell == null) return;
    setState(() {
      _startRow = _curRow = cell.$1;
      _startCol = _curCol = cell.$2;
      _selectedCells = {cell.$1 * 100 + cell.$2};
      _wrongFlash = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_startRow == null) return;
    final cell = _cellAt(d.globalPosition);
    if (cell == null) return;
    if (cell.$1 == _curRow && cell.$2 == _curCol) return;
    setState(() {
      _curRow = cell.$1;
      _curCol = cell.$2;
      _selectedCells =
          _computeSelection(_startRow!, _startCol!, _curRow!, _curCol!);
    });
  }

  void _onPanEnd(DragEndDetails _) => _validateSelection();

  // ── validation ─────────────────────────────────────────────────────────────

  void _validateSelection() {
    if (_startRow == null || _startCol == null ||
        _curRow   == null || _curCol   == null) {
      _clearSelection();
      return;
    }

    final dr = _curRow! - _startRow!;
    final dc = _curCol! - _startCol!;

    // Build the selected string (ordered from start → current)
    final buf = StringBuffer();
    if (dr.abs() >= dc.abs()) {
      final step = dr == 0 ? 1 : (dr > 0 ? 1 : -1);
      for (int r = _startRow!; r != _curRow! + step; r += step) {
        buf.write(_grid[r][_startCol!]);
      }
    } else {
      final step = dc > 0 ? 1 : -1;
      for (int c = _startCol!; c != _curCol! + step; c += step) {
        buf.write(_grid[_startRow!][c]);
      }
    }

    final selected = buf.toString();
    final reversed = selected.split('').reversed.join();

    for (int i = 0; i < level.words.length; i++) {
      if (_found[i]) continue;
      final word = level.words[i].word;
      if (selected == word || reversed == word) {
        setState(() {
          _markWordFound(i);
          _clearSelection();
        });
        return;
      }
    }

    // Wrong selection — flash red then clear
    setState(() => _wrongFlash = true);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(_clearSelection);
    });
  }

  void _markWordFound(int idx) {
    final wp = level.words[idx];
    for (int i = 0; i < wp.word.length; i++) {
      final r = wp.horizontal ? wp.row : wp.row + i;
      final c = wp.horizontal ? wp.col + i : wp.col;
      _foundCells.add(r * 100 + c);
    }
    _found[idx] = true;
    if (_allFound) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _showWinDialog();
      });
    }
  }

  void _clearSelection() {
    _selectedCells = {};
    _startRow = _startCol = _curRow = _curCol = null;
    _wrongFlash = false;
  }

  void _showWinDialog() {
    Progress.completeLevel(level.id, 3).then((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _WinDialog(
          onNext: () {
            Navigator.pop(context); // dialog
            Navigator.pop(context); // game screen
          },
        ),
      );
    });
  }

  // ── build ──────────────────────────────────────────────────────────────────

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
                levelNumber: widget.levelNumber,
                levelName: level.name,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              // ── grid with gesture detector ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onPanStart:  _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd:    _onPanEnd,
                  child: _WordGrid(
                    key: _gridKey,
                    grid:          _grid,
                    foundCells:    _foundCells,
                    selectedCells: _selectedCells,
                    wrongFlash:    _wrongFlash,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _ProgressBar(found: _foundCount, total: level.words.length),
              const SizedBox(height: 8),
              Expanded(
                child: _CluesPanel(words: level.words, found: _found),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int levelNumber;
  final String levelName;
  final VoidCallback onBack;
  const _TopBar(
      {required this.levelNumber,
      required this.levelName,
      required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navBar,
      height: 52,
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
            label: const Text('رجوع',
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ),
          Expanded(
            child: Text(
              'مستوى $levelNumber — $levelName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 52),
        ],
      ),
    );
  }
}

// ─── Word Grid ────────────────────────────────────────────────────────────────

class _WordGrid extends StatelessWidget {
  final List<List<String>> grid;
  final Set<int> foundCells;
  final Set<int> selectedCells;
  final bool wrongFlash;

  const _WordGrid({
    super.key,
    required this.grid,
    required this.foundCells,
    required this.selectedCells,
    required this.wrongFlash,
  });

  @override
  Widget build(BuildContext context) {
    final rows = grid.length;
    final cols = grid[0].length;

    return AspectRatio(
      aspectRatio: cols / rows,
      child: Column(
        children: List.generate(
          rows,
          (r) => Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              children: List.generate(cols, (c) {
                final key = r * 100 + c;
                return Expanded(
                  child: _GridCell(
                    letter:     grid[r][c],
                    isFound:    foundCells.contains(key),
                    isSelected: selectedCells.contains(key),
                    wrongFlash: wrongFlash && selectedCells.contains(key),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final String letter;
  final bool isFound;
  final bool isSelected;
  final bool wrongFlash;

  const _GridCell({
    required this.letter,
    required this.isFound,
    required this.isSelected,
    required this.wrongFlash,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color textColor;

    if (isFound) {
      bg        = AppColors.gold;
      textColor = Colors.white;
    } else if (wrongFlash) {
      bg        = Colors.redAccent;
      textColor = Colors.white;
    } else if (isSelected) {
      bg        = AppColors.midTeal;
      textColor = const Color(0xFF333333);
    } else {
      bg        = Colors.white;
      textColor = const Color(0xFF222222);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: (!isFound && !isSelected && !wrongFlash)
            ? [const BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]
            : null,
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            letter,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final int found;
  final int total;
  const _ProgressBar({required this.found, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Text(
            'الكلمات  $found / $total',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? found / total : 0,
                backgroundColor: Colors.white30,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.gold),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Clues Panel ─────────────────────────────────────────────────────────────

class _CluesPanel extends StatelessWidget {
  final List<WordPlacement> words;
  final List<bool> found;
  const _CluesPanel({required this.words, required this.found});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: words.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 52, color: Colors.white24),
        itemBuilder: (ctx, i) => _ClueItem(
          placement: words[i],
          isFound:   found[i],
          index:     i + 1,
        ),
      ),
    );
  }
}

class _ClueItem extends StatelessWidget {
  final WordPlacement placement;
  final bool isFound;
  final int index;
  const _ClueItem(
      {required this.placement, required this.isFound, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isFound ? AppColors.gold : AppColors.navDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isFound
                  ? const Icon(Icons.check, color: Colors.white, size: 17)
                  : Text('$index',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              placement.clue,
              style: TextStyle(
                color:      isFound ? Colors.white54 : Colors.white,
                fontSize:   14,
                fontWeight: FontWeight.w500,
                decoration: isFound ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white54,
              ),
            ),
          ),
          if (!isFound)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color:        AppColors.navDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${placement.word.length} أحرف',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Win Dialog ───────────────────────────────────────────────────────────────

class _WinDialog extends StatelessWidget {
  final VoidCallback onNext;
  const _WinDialog({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color:        AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أحسنت!',
                style: TextStyle(
                    color:      Colors.white,
                    fontSize:   28,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.star, color: AppColors.gold, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onNext,
                child: const Text('التالي',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
