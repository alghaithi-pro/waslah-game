import 'package:flutter/material.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../services/progress.dart';
import '../theme/colors.dart';
import 'levels_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
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
                stars: totalStars,
                coins: coins,
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: allGroups.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white24),
                  itemBuilder: (ctx, i) {
                    final g        = allGroups[i];
                    final unlocked = totalStars >= g.starsRequired;
                    final earned   = _groupStars(g);
                    return _GroupRow(
                      group: g,
                      unlocked: unlocked,
                      earnedStars: earned,
                      onTap: unlocked && g.levels.isNotEmpty
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LevelsScreen(group: g),
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

  int _groupStars(CrosswordGroup g) =>
      g.levels.fold(0, (sum, l) => sum + Progress.levelStars(l.id));
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int stars;
  final int coins;
  final VoidCallback onBack;
  const _TopBar(
      {required this.stars, required this.coins, required this.onBack});

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
          const Expanded(
            child: Text('المجموعات',
                textAlign: TextAlign.center,
                style: TextStyle(
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

// ─── Group Row ────────────────────────────────────────────────────────────────

class _GroupRow extends StatelessWidget {
  final CrosswordGroup group;
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
    final locked = !unlocked || group.levels.isEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        color: locked ? AppColors.navDark : AppColors.navBar,
        child: Row(
          children: [
            Container(
              width: 64,
              height: double.infinity,
              color: locked ? AppColors.cardDark : AppColors.gold,
              child: Icon(
                locked ? Icons.lock_outline : Icons.play_circle_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  group.levels.isEmpty
                      ? '${group.name}  (قريباً)'
                      : group.name,
                  style: TextStyle(
                    color: locked ? Colors.white60 : Colors.white,
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
                      color: locked ? Colors.white38 : AppColors.gold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    locked ? Icons.star_border : Icons.star,
                    color: locked ? Colors.white38 : AppColors.gold,
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
