import 'package:flutter/material.dart';

class AppColors {
  // Background gradient (teal → light cyan)
  static const bgTop    = Color(0xFF2EC4BE);
  static const bgBottom = Color(0xFF93DDD9);

  // Buttons
  static const btnMain  = Color(0xFF27B5AF);
  static const btnIcon  = Color(0xFF1A8A86);
  static const btnText  = Colors.white;
  static const iconClr  = Color(0xFFFFB800);

  // Sound button
  static const soundBtn = Color(0xFF1A7A76);

  // Crossword grid
  static const cellActive    = Colors.white;
  static const cellInactive  = Color(0xFF2B2B2B);
  static const cellSelected  = Color(0xFF27B5AF);   // selected word
  static const cellCursor    = Color(0xFF1A8A86);   // cursor cell
  static const cellCorrect   = Color(0xFFDFF6F5);   // solved word
  static const cellText      = Color(0xFF1A237E);
  static const cellNumber    = Color(0xFF888888);
  static const gridBorder    = Color(0xFFCCCCCC);

  // Clue panel
  static const cluePanel    = Color(0xFF27B5AF);
  static const clueText     = Colors.white;

  // Keyboard
  static const kbKey        = Color(0xFFFFFFFF);
  static const kbKeyText    = Color(0xFF333333);
  static const kbDelete     = Color(0xFFE57373);
  static const kbBg         = Color(0xFF1A8A86);
}
