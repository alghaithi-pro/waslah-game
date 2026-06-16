import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';

class GameScreen extends StatefulWidget {
  final Puzzle puzzle;
  final int puzzleNumber;
  const GameScreen({super.key, required this.puzzle, required this.puzzleNumber});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Puzzle get puzzle => widget.puzzle;

  late List<String> _pool;           // all letter choices (answer + extras shuffled)
  late List<bool>   _poolUsed;       // whether each pool letter is used
  late List<String?> _placed;        // letters placed by user
  int  _cursor = 0;                  // next empty slot index
  int  _hintsUsed = 0;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _pool     = puzzle.generatePool();
    _poolUsed = List.filled(_pool.length, false);
    _placed   = List.filled(puzzle.answer.length, null);
  }

  void _tapPoolLetter(int poolIdx) {
    if (_poolUsed[poolIdx] || _cursor >= puzzle.answer.length || _won) return;
    setState(() {
      _placed[_cursor] = _pool[poolIdx];
      _poolUsed[poolIdx] = true;
      _cursor++;
    });
    if (_cursor == puzzle.answer.length) _checkWin();
  }

  void _deleteLetter() {
    if (_cursor == 0 || _won) return;
    setState(() {
      _cursor--;
      final letter = _placed[_cursor];
      _placed[_cursor] = null;
      // restore letter to pool
      final idx = _poolUsed.indexWhere(
          (used, [i = 0]) => false); // find first used slot with that letter
      // search manually
      for (int i = 0; i < _pool.length; i++) {
        if (_poolUsed[i] && _pool[i] == letter) {
          _poolUsed[i] = false;
          break;
        }
      }
    });
  }

  void _revealLetter() {
    if (_cursor >= puzzle.answer.length || _won) return;
    final correct = puzzle.answer[_cursor];
    // find an unused pool letter that matches
    for (int i = 0; i < _pool.length; i++) {
      if (!_poolUsed[i] && _pool[i] == correct) {
        setState(() => _hintsUsed++);
        _tapPoolLetter(i);
        return;
      }
    }
  }

  void _checkWin() {
    final typed = _placed.join('');
    if (typed == puzzle.answer) {
      final stars = _hintsUsed == 0 ? 3 : (_hintsUsed == 1 ? 2 : 1);
      setState(() => _won = true);
      Progress.completePuzzle(puzzle.id, stars).then((_) {
        if (!mounted) return;
        _showWinDialog(stars);
      });
    } else {
      // wrong — reset
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() {
          _placed   = List.filled(puzzle.answer.length, null);
          _poolUsed = List.filled(_pool.length, false);
          _cursor   = 0;
        });
      });
    }
  }

  void _showWinDialog(int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _WinDialog(
        stars: stars,
        onNext: () {
          Navigator.pop(context);  // close dialog
          Navigator.pop(context);  // go back to puzzle list
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalStars = Progress.totalStars;

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
              // Top bar
              _TopBar(
                title: 'لغز رقم ${widget.puzzleNumber}',
                stars: totalStars,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              // Clue card
              Expanded(
                flex: 5,
                child: _ClueCard(
                  sentence: puzzle.sentence,
                  onReveal: _revealLetter,
                  onDelete: _deleteLetter,
                ),
              ),
              const SizedBox(height: 16),
              // Answer boxes
              _AnswerBoxes(
                answer: puzzle.answer,
                placed: _placed,
                cursor: _cursor,
                won: _won,
              ),
              const SizedBox(height: 20),
              // Letter pool
              Expanded(
                flex: 4,
                child: _LetterPool(
                  pool: _pool,
                  used: _poolUsed,
                  onTap: _tapPoolLetter,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final int stars;
  final VoidCallback onBack;
  const _TopBar({required this.title, required this.stars, required this.onBack});

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
            label: const Text('رجوع',
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ),
          Expanded(
            child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Text('$stars',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                const Icon(Icons.add_circle_outline,
                    color: Colors.white70, size: 22),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClueCard extends StatelessWidget {
  final String sentence;
  final VoidCallback onReveal;
  final VoidCallback onDelete;
  const _ClueCard({
    required this.sentence,
    required this.onReveal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.midTeal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('أكمل ...',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 14)),
          ),
          // Body — sentence
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.cardDark,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: Text(
                  sentence,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
          // Footer buttons
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                  label: const Text('إحذف حرف',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white30),
              Expanded(
                child: TextButton.icon(
                  onPressed: onReveal,
                  icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 18),
                  label: const Text('إكشف حرف',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerBoxes extends StatelessWidget {
  final String answer;
  final List<String?> placed;
  final int cursor;
  final bool won;
  const _AnswerBoxes({
    required this.answer,
    required this.placed,
    required this.cursor,
    required this.won,
  });

  @override
  Widget build(BuildContext context) {
    final n = answer.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // RTL: index 0 on the right (first Arabic letter)
      textDirection: TextDirection.rtl,
      children: List.generate(n, (i) {
        final isActive = i == cursor && !won;
        final letter   = placed[i];
        return Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: won
                ? AppColors.gold
                : (isActive ? AppColors.gold : AppColors.cardDark),
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              letter ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _LetterPool extends StatelessWidget {
  final List<String> pool;
  final List<bool> used;
  final void Function(int) onTap;
  const _LetterPool({required this.pool, required this.used, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final half = (pool.length / 2).ceil();
    final row1 = pool.sublist(0, half);
    final row2 = pool.sublist(half);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRow(row1, 0),
        const SizedBox(height: 8),
        _buildRow(row2, half),
      ],
    );
  }

  Widget _buildRow(List<String> letters, int offset) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(letters.length, (i) {
        final idx    = offset + i;
        final isUsed = used[idx];
        return GestureDetector(
          onTap: isUsed ? null : () => onTap(idx),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42,
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isUsed ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isUsed
                  ? null
                  : [
                      const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: Offset(0, 2)),
                    ],
            ),
            child: Center(
              child: Text(
                isUsed ? '' : letters[i],
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _WinDialog extends StatelessWidget {
  final int stars;
  final VoidCallback onNext;
  const _WinDialog({required this.stars, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أحسنت!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 40,
                ),
              )),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
