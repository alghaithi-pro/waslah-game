import 'package:flutter/material.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';
import 'puzzles_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    final stars = Progress.totalStars;

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
                title: 'المجموعات',
                stars: stars,
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: allGroups.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white24),
                  itemBuilder: (ctx, i) {
                    final g = allGroups[i];
                    final unlocked = stars >= g.starsRequired;
                    final groupStars = _groupEarnedStars(g);
                    return _GroupRow(
                      group: g,
                      unlocked: unlocked,
                      earnedStars: groupStars,
                      onTap: unlocked
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PuzzlesScreen(group: g),
                                ),
                              ).then((_) => setState(() {}))
                          : null,
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

  int _groupEarnedStars(WordSearchGroup g) {
    return g.levels.fold(0, (sum, l) => sum + Progress.levelStars(l.id));
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

class _GroupRow extends StatelessWidget {
  final WordSearchGroup group;
  final bool unlocked;
  final int earnedStars;
  final VoidCallback? onTap;
  const _GroupRow({
    required this.group,
    required this.unlocked,
    required this.earnedStars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        color: unlocked ? AppColors.navBar : AppColors.navDark,
        child: Row(
          children: [
            Container(
              width: 64,
              height: double.infinity,
              color: unlocked ? AppColors.gold : AppColors.cardDark,
              child: Icon(
                unlocked ? Icons.play_circle_outline : Icons.lock_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  group.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text(
                    '${group.starsRequired}',
                    style: TextStyle(
                      color: unlocked ? AppColors.gold : Colors.white60,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    unlocked ? Icons.star : Icons.star_border,
                    color: unlocked ? AppColors.gold : Colors.white38,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
