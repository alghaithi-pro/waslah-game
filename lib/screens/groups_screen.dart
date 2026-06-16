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
      backgroundColor: AppColors.bgTop,
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
                title: 'المجموعات',
                stars: stars,
                onBack: () => Navigator.pop(context),
              ),
              // Groups list
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

  int _groupEarnedStars(Group g) {
    return g.puzzles.fold(0, (sum, p) => sum + Progress.puzzleStars(p.id));
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
          // Back button (RTL: left side = right visually)
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
  final Group group;
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
        color: unlocked
            ? const Color(0xFF1D9E98)
            : const Color(0xFF178581),
        child: Row(
          children: [
            // Left icon cell
            Container(
              width: 64,
              height: double.infinity,
              color: unlocked ? AppColors.gold : AppColors.cardDark,
              child: Icon(
                unlocked ? Icons.play_circle_outline : Icons.lock_outline,
                color: unlocked ? Colors.white : AppColors.midTeal,
                size: 28,
              ),
            ),
            // Group name
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
            // Stars
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
