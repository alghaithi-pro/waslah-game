import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../theme/app_colors.dart';
import '../data/puzzles_data.dart';
import 'game_screen.dart';

class WinScreen extends StatefulWidget {
  final Puzzle puzzle;
  final int stars;
  final int categoryIndex;
  final int puzzleIndex;

  const WinScreen({
    super.key,
    required this.puzzle,
    required this.stars,
    required this.categoryIndex,
    required this.puzzleIndex,
  });

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _hasNext {
    final cat = allCategories[widget.categoryIndex];
    return widget.puzzleIndex < cat.puzzles.length - 1;
  }

  void _nextPuzzle() {
    final nextPuzzle = allCategories[widget.categoryIndex]
        .puzzles[widget.puzzleIndex + 1];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          puzzle: nextPuzzle,
          categoryIndex: widget.categoryIndex,
          puzzleIndex: widget.puzzleIndex + 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              ..._buildParticles(MediaQuery.of(context).size),
              Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Trophy emoji
                          const Text('🏆', style: TextStyle(fontSize: 72)),
                          const SizedBox(height: 12),
                          const Text(
                            'أحسنت!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'لغز رقم ${widget.puzzle.number} — ${widget.puzzle.topic}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (i) {
                              final lit = i < widget.stars;
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: lit ? 1 : 0.3),
                                duration: Duration(milliseconds: 300 + i * 150),
                                builder: (_, v, __) => Opacity(
                                  opacity: v,
                                  child: Icon(
                                    Icons.star_rounded,
                                    size: 56,
                                    color: lit
                                        ? AppColors.star
                                        : Colors.grey[300],
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 28),
                          // Words found
                          Text(
                            'وجدت ${widget.puzzle.words.length} كلمات',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Buttons
                          if (_hasNext)
                            _WinButton(
                              label: 'اللغز التالي ←',
                              onTap: _nextPuzzle,
                              isPrimary: true,
                            ),
                          const SizedBox(height: 12),
                          _WinButton(
                            label: 'قائمة الألغاز',
                            onTap: () =>
                                Navigator.popUntil(context, (r) => r.isFirst || r.settings.name == '/levels'),
                            isPrimary: !_hasNext,
                          ),
                          const SizedBox(height: 8),
                          _WinButton(
                            label: 'الصفحة الرئيسية',
                            onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                            isPrimary: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildParticles(Size size) {
    final colors = [
      AppColors.accent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.lightBlueAccent,
    ];
    return List.generate(20, (i) {
      final x = (i * 73 % 100) / 100.0;
      final y = (i * 37 % 100) / 100.0;
      final s = 8.0 + (i * 17 % 12);
      return Positioned(
        left: x * size.width,
        top: y * size.height,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 600 + i * 80),
          builder: (_, v, __) => Opacity(
            opacity: v * 0.6,
            child: Transform.rotate(
              angle: i * 0.5,
              child: Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _WinButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _WinButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                )
              : null,
          color: isPrimary ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(26),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB300).withOpacity(0.4),
                    blurRadius: 12,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: isPrimary ? const Color(0xFF1A237E) : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
