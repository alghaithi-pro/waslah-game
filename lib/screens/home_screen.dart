import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'levels_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _soundOn = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            children: [
              const Spacer(flex: 2),
              // Hash logo
              _HashLogo(size: size.width * 0.62),
              const SizedBox(height: 20),
              // Title
              _buildTitle(),
              const Spacer(flex: 2),
              // Buttons
              _GameButton(
                label: 'إبدأ',
                icon: Icons.send,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LevelsScreen())),
              ),
              const SizedBox(height: 10),
              _GameButton(
                label: 'أرسل اللعبة',
                icon: Icons.email_outlined,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _GameButton(
                label: 'متجر ألعابنا',
                icon: Icons.apps,
                onTap: () {},
              ),
              const Spacer(flex: 2),
              // Sound button
              GestureDetector(
                onTap: () => setState(() => _soundOn = !_soundOn),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.soundBtn,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _soundOn ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        _TitleLine(text: 'كلمـات'),
        const SizedBox(height: 6),
        _TitleLine(text: 'متقاطعة'),
      ],
    );
  }
}

class _TitleLine extends StatelessWidget {
  final String text;
  const _TitleLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: Color(0xFF222222),
          letterSpacing: 4,
        ),
      ),
    );
  }
}

class _HashLogo extends StatelessWidget {
  final double size;
  const _HashLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    final barThick = size * 0.22;
    final barLen   = size * 0.85;
    final gap      = size * 0.24;
    final radius   = barThick / 2;
    final color    = Colors.white.withOpacity(0.88);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical bar LEFT
          Positioned(
            left: size / 2 - gap / 2 - barThick,
            top: (size - barLen) / 2,
            child: Container(
              width: barThick,
              height: barLen,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
          // Vertical bar RIGHT
          Positioned(
            left: size / 2 + gap / 2,
            top: (size - barLen) / 2,
            child: Container(
              width: barThick,
              height: barLen,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
          // Horizontal bar TOP
          Positioned(
            left: (size - barLen) / 2,
            top: size / 2 - gap / 2 - barThick,
            child: Container(
              width: barLen,
              height: barThick,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
          // Horizontal bar BOTTOM
          Positioned(
            left: (size - barLen) / 2,
            top: size / 2 + gap / 2,
            child: Container(
              width: barLen,
              height: barThick,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GameButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.btnMain,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Icon section (left side - darker)
            Container(
              width: 60,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.btnIcon,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Icon(icon, color: AppColors.iconClr, size: 26),
            ),
            // Label
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
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
