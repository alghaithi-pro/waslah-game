import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Background gradient ───────────────────────────────────────────────────
  static const bgTop    = Color(0xFF26C6DA); // Cyan 300
  static const bgBottom = Color(0xFF0097A7); // Cyan 700

  // ── Navigation / bars ─────────────────────────────────────────────────────
  static const navBar   = Color(0xFF00ACC1); // Cyan 600
  static const navDark  = Color(0xFF006064); // Cyan 900

  // ── Gold / stars ──────────────────────────────────────────────────────────
  static const gold     = Color(0xFFFFB300); // Amber 600
  static const goldDark = Color(0xFFFFA000); // Amber 700

  // ── Cards / rows ──────────────────────────────────────────────────────────
  static const cardDark = Color(0xFF00838F); // Cyan 800

  // ── Grid cells ────────────────────────────────────────────────────────────
  static const cellEmpty   = Color(0xFFE0F7FA); // Cyan 50  — empty active cell
  static const cellFilled  = Color(0xFFFFFFFF); // White     — user-entered letter
  static const cellCorrect = Color(0xFF66BB6A); // Green 400 — revealed/locked
  static const cellWrong   = Color(0xFFEF5350); // Red 400   — error highlight
  static const cellActive  = Color(0xFFFFE082); // Amber 200 — selected word highlight

  // ── Keyboard ──────────────────────────────────────────────────────────────
  static const keyBg      = Color(0xFF00838F); // Cyan 800
  static const keyPressed = Color(0xFF006064); // Cyan 900

  // ── Misc ──────────────────────────────────────────────────────────────────
  static const btnIcon  = Color(0xFF00838F);
  static const iconClr  = Color(0xFFFFFFFF);
  static const soundBtn = Color(0xFF00ACC1);
  static const midTeal  = Color(0xFF80DEEA); // Cyan 200
}
