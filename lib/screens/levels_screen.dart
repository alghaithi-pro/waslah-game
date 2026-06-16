import 'package:flutter/material.dart';
import '../data/puzzles_data.dart';
import '../theme/app_colors.dart';
import 'game_screen.dart';

class LevelsScreen extends StatelessWidget {
  final int categoryIndex;
  const LevelsScreen({super.key, required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    final cat = allCategories[categoryIndex];
    final color = AppColors.categoryColors[cat.colorIndex % AppColors.categoryColors.length];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color, Color.lerp(color, Colors.black, 0.4)!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(
                title: cat.name,
                emoji: cat.emoji,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: cat.puzzles.length,
                    itemBuilder: (context, i) {
                      final puzzle = cat.puzzles[i];
                      return _LevelCard(
                        number: i + 1,
                        topic: puzzle.topic,
                        color: color,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameScreen(
                              puzzle: puzzle,
                              categoryIndex: categoryIndex,
                              puzzleIndex: i,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
  final String emoji;
  const _TopBar({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int number;
  final String topic;
  final Color color;
  final VoidCallback onTap;

  const _LevelCard({
    required this.number,
    required this.topic,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.star,
                    size: 14,
                    color: AppColors.accent.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                topic,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
