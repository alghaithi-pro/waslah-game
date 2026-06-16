import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/colors.dart';
import 'levels_screen.dart';

class WinScreen extends StatelessWidget {
  final CrosswordPuzzle puzzle;
  const WinScreen({super.key, required this.puzzle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bgTop, AppColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Trophy icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events, size: 70, color: Color(0xFFFFD700)),
              ),
              const SizedBox(height: 28),
              // Congratulations text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  'أحسنت!',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF222222),
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'حللت: ${puzzle.title}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Buttons
              _WinButton(
                label: 'ألغاز أخرى',
                icon: Icons.grid_view_rounded,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LevelsScreen()),
                    (route) => route.isFirst,
                  );
                },
              ),
              const SizedBox(height: 14),
              _WinButton(
                label: 'القائمة الرئيسية',
                icon: Icons.home_outlined,
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WinButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _WinButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.btnMain,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.btnIcon,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Icon(icon, color: AppColors.iconClr, size: 24),
            ),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
