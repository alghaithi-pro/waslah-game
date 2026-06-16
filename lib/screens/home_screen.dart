import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFF1A237E)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative dots
            ..._buildDots(size),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'و',
                                style: TextStyle(
                                  fontSize: 62,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, AppColors.accent],
                            ).createShader(bounds),
                            child: const Text(
                              'وصلة',
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'لعبة الكلمات العربية',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Play button
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          _PlayButton(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CategoriesScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoRow(),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDots(Size size) {
    final positions = [
      (0.1, 0.08), (0.85, 0.12), (0.25, 0.25), (0.72, 0.18),
      (0.05, 0.45), (0.92, 0.38), (0.15, 0.72), (0.88, 0.65),
      (0.35, 0.88), (0.65, 0.82), (0.5, 0.05), (0.45, 0.95),
    ];
    return positions.map((p) {
      final s = (p.$1 * 8 + p.$2 * 5).clamp(3.0, 8.0);
      return Positioned(
        left: p.$1 * size.width,
        top: p.$2 * size.height,
        child: Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}

class _PlayButton extends StatefulWidget {
  final VoidCallback onTap;
  const _PlayButton({required this.onTap});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
            ),
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFB300).withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'العب الآن',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _InfoChip(icon: Icons.grid_view_rounded, label: '5 تصنيفات'),
        const SizedBox(width: 12),
        _InfoChip(icon: Icons.extension, label: '30 لغز'),
        const SizedBox(width: 12),
        _InfoChip(icon: Icons.star, label: 'مجاني'),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
