import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ArabicKeyboard extends StatelessWidget {
  final void Function(String letter) onLetter;
  final VoidCallback onDelete;

  const ArabicKeyboard({
    super.key,
    required this.onLetter,
    required this.onDelete,
  });

  static const _rows = [
    ['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح', 'ج', 'د'],
    ['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك', 'ط'],
    ['ئ', 'ء', 'ؤ', 'ر', 'ى', 'ة', 'و', 'ز', 'ظ', 'أ', 'إ'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kbBg,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._rows.map((row) => _buildRow(row)),
          const SizedBox(height: 4),
          _buildDeleteRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> letters) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((l) => _KeyButton(
          label: l,
          onTap: () => onLetter(l),
        )).toList(),
      ),
    );
  }

  Widget _buildDeleteRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onDelete,
          child: Container(
            width: 80,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: AppColors.kbDelete,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.backspace_outlined, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.kbKey,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.kbKeyText,
            ),
          ),
        ),
      ),
    );
  }
}
