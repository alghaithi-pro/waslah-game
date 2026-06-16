import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/app_colors.dart';
import '../widgets/letter_grid.dart';
import '../widgets/word_chip.dart';
import 'win_screen.dart';

class GameScreen extends StatefulWidget {
  final Puzzle puzzle;
  final int categoryIndex;
  final int puzzleIndex;

  const GameScreen({
    super.key,
    required this.puzzle,
    required this.categoryIndex,
    required this.puzzleIndex,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _foundWords = {};
  late AnimationController _flashCtrl;
  late Animation<Color?> _flashColor;
  DateTime? _startTime;
  int _wrongAttempts = 0;

  Puzzle get puzzle => widget.puzzle;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flashColor = ColorTween(
      begin: Colors.transparent,
      end: Colors.green.withOpacity(0.2),
    ).animate(CurvedAnimation(parent: _flashCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _flashCtrl.dispose();
    super.dispose();
  }

  void _onWordFound(WordEntry entry) {
    setState(() => _foundWords.add(entry.word));
    _flashCtrl.forward().then((_) => _flashCtrl.reverse());

    if (_foundWords.length == puzzle.words.length) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        final elapsed = DateTime.now().difference(_startTime!);
        final stars = elapsed.inSeconds < 90
            ? 3
            : elapsed.inSeconds < 180
                ? 2
                : 1;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WinScreen(
              puzzle: puzzle,
              stars: stars,
              categoryIndex: widget.categoryIndex,
              puzzleIndex: widget.puzzleIndex,
            ),
          ),
        );
      });
    }
  }

  int get _starsPreview {
    if (_startTime == null) return 3;
    final elapsed = DateTime.now().difference(_startTime!);
    if (elapsed.inSeconds < 90) return 3;
    if (elapsed.inSeconds < 180) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final remaining = puzzle.words.length - _foundWords.length;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _flashColor,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.bgTop, AppColors.bgBottom],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _GameTopBar(
                    puzzleNumber: puzzle.number,
                    category: puzzle.category,
                    remaining: remaining,
                    total: puzzle.words.length,
                    stars: _starsPreview,
                  ),
                  // Topic pill
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      puzzle.topic,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // Grid
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: LetterGrid(
                          puzzle: puzzle,
                          foundWords: _foundWords,
                          onWordFound: _onWordFound,
                        ),
                      ),
                    ),
                  ),
                  // Word chips
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: puzzle.words
                                .map((e) => WordChip(
                                      word: e.word,
                                      found: _foundWords.contains(e.word),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GameTopBar extends StatelessWidget {
  final int puzzleNumber;
  final String category;
  final int remaining;
  final int total;
  final int stars;

  const _GameTopBar({
    required this.puzzleNumber,
    required this.category,
    required this.remaining,
    required this.total,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => _showExitDialog(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'لغز رقم $puzzleNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$remaining / $total كلمات متبقية',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(3, (i) {
              return Icon(
                Icons.star_rounded,
                color: i < stars ? AppColors.star : AppColors.starEmpty,
                size: 22,
              );
            }),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('مغادرة اللغز؟'),
          content: const Text('سيتم فقدان تقدمك في هذا اللغز.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('استمر'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('خروج', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
