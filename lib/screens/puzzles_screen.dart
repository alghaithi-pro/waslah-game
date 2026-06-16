import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';
import 'game_screen.dart';

class PuzzlesScreen extends StatefulWidget {
  final Group group;
  const PuzzlesScreen({super.key, required this.group});

  @override
  State<PuzzlesScreen> createState() => _PuzzlesScreenState();
}

class _PuzzlesScreenState extends State<PuzzlesScreen> {
  Group get group => widget.group;

  bool _isPuzzleUnlocked(int index) {
    if (index == 0) return true;
    return Progress.isPuzzleDone(group.puzzles[index - 1].id);
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
                title: group.name,
                stars: totalStars,
                onBack: () => Navigator.pop(context),
              ),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: group.puzzles.length,
                  itemBuilder: (ctx, i) {
                    final puzzle  = group.puzzles[i];
                    final unlocked = _isPuzzleUnlocked(i);
                    final done    = Progress.isPuzzleDone(puzzle.id);
                    final pStars  = Progress.puzzleStars(puzzle.id);

                    return GestureDetector(
                      onTap: unlocked
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameScreen(
                                    puzzle: puzzle,
                                    puzzleNumber: i + 1,
                                  ),
                                ),
                              ).then((_) => setState(() {}))
                          : null,
                      child: _PuzzleCard(
                        number: i + 1,
                        unlocked: unlocked,
                        done: done,
                        stars: pStars,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('$stars',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: AppColors.gold, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleCard extends StatelessWidget {
  final int number;
  final bool unlocked;
  final bool done;
  final int stars;
  const _PuzzleCard({
    required this.number,
    required this.unlocked,
    required this.done,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = unlocked
        ? (done ? AppColors.gold.withOpacity(0.85) : AppColors.gold)
        : AppColors.cardDark;

    return Container(
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main area
          Expanded(
            child: Center(
              child: unlocked
                  ? Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  : const Icon(Icons.lock_outline, color: Color(0xFF27B5AF), size: 32),
            ),
          ),
          // Stars strip
          Container(
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 16,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
