import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _soundOn = true;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final logoSize = sw * 0.78;

    return Scaffold(
      body: Container(
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
              // # logo with title overlaid
              _HashWithTitle(size: logoSize),
              const Spacer(flex: 2),
              // Buttons
              _GameButton(
                label: 'إبدأ',
                icon: Icons.send,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GroupsScreen())),
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
              // Sound toggle
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// # logo with text pills overlaid at the horizontal bar positions
class _HashWithTitle extends StatelessWidget {
  final double size;
  const _HashWithTitle({required this.size});

  @override
  Widget build(BuildContext context) {
    final barThick = size * 0.22;
    final barLen   = size * 0.85;
    final gap      = size * 0.24;
    final radius   = barThick / 2;
    final barColor = Colors.white.withOpacity(0.85);

    // Horizontal bar top positions (same formula as before)
    final h1Top = size / 2 - gap / 2 - barThick;
    final h2Top = size / 2 + gap / 2;
    final leftOff = (size - barLen) / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Left vertical bar
          Positioned(
            left: size / 2 - gap / 2 - barThick,
            top: (size - barLen) / 2,
            child: _Bar(w: barThick, h: barLen, r: radius, color: barColor),
          ),
          // Right vertical bar
          Positioned(
            left: size / 2 + gap / 2,
            top: (size - barLen) / 2,
            child: _Bar(w: barThick, h: barLen, r: radius, color: barColor),
          ),
          // Horizontal bar 1
          Positioned(
            left: leftOff,
            top: h1Top,
            child: _Bar(w: barLen, h: barThick, r: radius, color: barColor),
          ),
          // Horizontal bar 2
          Positioned(
            left: leftOff,
            top: h2Top,
            child: _Bar(w: barLen, h: barThick, r: radius, color: barColor),
          ),
          // Title pill 1 — overlaid on bar 1
          Positioned(
            top: h1Top,
            left: 0,
            right: 0,
            height: barThick,
            child: const Center(child: _TitlePill(text: 'كلمـات')),
          ),
          // Title pill 2 — overlaid on bar 2
          Positioned(
            top: h2Top,
            left: 0,
            right: 0,
            height: barThick,
            child: const Center(child: _TitlePill(text: 'متقاطعة')),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double w, h, r;
  final Color color;
  const _Bar({required this.w, required this.h, required this.r, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(r),
        ),
      );
}

class _TitlePill extends StatelessWidget {
  final String text;
  const _TitlePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Color(0xFF222222),
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GameButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF27B5AF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Icon panel — RIGHT side in RTL
            Container(
              width: 60,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.btnIcon,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Icon(icon, color: AppColors.iconClr, size: 26),
            ),
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
