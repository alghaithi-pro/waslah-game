import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';
import 'game_screen.dart';

class LevelsScreen extends StatefulWidget {
  final CrosswordGroup group;
  const LevelsScreen({super.key, required this.group});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  CrosswordGroup get group => widget.group;

  bool _isUnlocked(int index) {
    if (index == 0) return true;
    return Progress.isLevelDone(group.levels[index - 1].id);
  }

  @override
  Widget build(BuildContext context) {
    final totalStars = Progress.totalStars;
    final coins      = Progress.coins;

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
                title: group.name,
                stars: totalStars,
                coins: coins,
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: group.levels.length,
                  itemBuilder: (ctx, i) {
                    final level    = group.levels[i];
                    final unlocked = _isUnlocked(i);
                    final done     = Progress.isLevelDone(level.id);
                    final stars    = Progress.levelStars(level.id);

                    return GestureDetector(
                      onTap: unlocked
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameScreen(
                                    level: level,
                                    levelNumber: i + 1,
                                    groupName: group.name,
                                  ),
                                ),
                              ).then((_) => setState(() {}))
                          : null,
                      child: _LevelCard(
                        number: i + 1,
                        unlocked: unlocked,
                        done: done,
                        stars: stars,
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

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final int stars;
  final int coins;
  final VoidCallback onBack;

  const _TopBar({
    required this.title,
    required this.stars,
    required this.coins,
    required this.onBack,
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
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
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
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Text('$coins',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 2),
                const Icon(Icons.monetization_on,
                    color: AppColors.gold, size: 18),
                const SizedBox(width: 10),
                Text('$stars',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 2),
                const Icon(Icons.star, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Level Card ───────────────────────────────────────────────────────────────

class _LevelCard extends StatelessWidget {
  final int number;
  final bool unlocked;
  final bool done;
  final int stars;

  const _LevelCard({
    required this.number,
    required this.unlocked,
    required this.done,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final bg = unlocked
        ? (done ? AppColors.gold : AppColors.navBar)
        : AppColors.navDark;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: unlocked
                  ? Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  : const Icon(Icons.lock_outline,
                      color: Colors.white54, size: 30),
            ),
          ),
          Container(
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
