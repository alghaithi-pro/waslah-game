import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WordChip extends StatelessWidget {
  final String word;
  final bool found;

  const WordChip({super.key, required this.word, required this.found});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: found ? AppColors.tileFound : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (found) ...[
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 5),
          ],
          Text(
            word,
            style: TextStyle(
              color: found ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: found ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
