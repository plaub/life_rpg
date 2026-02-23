import 'package:flutter/material.dart';

/// App color palette – modern, harmonious, RPG-themed.
///
/// Light: Clean white/slate with indigo/violet accents
/// Dark: Deep slate/charcoal with cyan/teal accents
class AppColors {
  AppColors._();

  // ─── Light Theme Colors ────────────────────────────────────────────

  static const Color lightPrimary = Color(0xFF4F46E5); // Indigo-600
  static const Color lightPrimaryVariant = Color(0xFF3730A3); // Indigo-800
  static const Color lightSecondary = Color(0xFF8B5CF6); // Violet-500
  static const Color lightSecondaryVariant = Color(0xFF7C3AED); // Violet-600
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate-50
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9); // Slate-100
  static const Color lightError = Color(0xFFEF4444); // Red-500
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF0F172A); // Slate-900
  static const Color lightOnSurface = Color(0xFF1E293B); // Slate-800
  static const Color lightOnSurfaceVariant = Color(0xFF64748B); // Slate-500
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOutline = Color(0xFFCBD5E1); // Slate-300
  static const Color lightOutlineVariant = Color(0xFFE2E8F0); // Slate-200

  // ─── Dark Theme Colors ─────────────────────────────────────────────

  static const Color darkPrimary = Color(0xFF22D3EE); // Cyan-400
  static const Color darkPrimaryVariant = Color(0xFF06B6D4); // Cyan-500
  static const Color darkSecondary = Color(0xFF2DD4BF); // Teal-400
  static const Color darkSecondaryVariant = Color(0xFF14B8A6); // Teal-500
  static const Color darkBackground = Color(0xFF0F172A); // Slate-900
  static const Color darkSurface = Color(0xFF1E293B); // Slate-800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate-700
  static const Color darkError = Color(0xFFFCA5A5); // Red-300
  static const Color darkOnPrimary = Color(0xFF0F172A); // Slate-900
  static const Color darkOnSecondary = Color(0xFF0F172A);
  static const Color darkOnBackground = Color(0xFFF1F5F9); // Slate-100
  static const Color darkOnSurface = Color(0xFFE2E8F0); // Slate-200
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8); // Slate-400
  static const Color darkOnError = Color(0xFF0F172A);
  static const Color darkOutline = Color(0xFF475569); // Slate-600
  static const Color darkOutlineVariant = Color(0xFF334155); // Slate-700

  // ─── Semantic / RPG Colors (shared across themes) ──────────────────

  static const Color xpGold = Color(0xFFF59E0B); // Amber-500
  static const Color xpGoldLight = Color(0xFFFBBF24); // Amber-400
  static const Color levelPurple = Color(0xFFA855F7); // Purple-500
  static const Color levelPurpleLight = Color(0xFFC084FC); // Purple-400
  static const Color successGreen = Color(0xFF10B981); // Emerald-500
  static const Color successGreenLight = Color(0xFF34D399); // Emerald-400

  // Progress bar gradients
  static const Color progressStart = Color(0xFF6366F1); // Indigo-500
  static const Color progressEnd = Color(0xFFA855F7); // Purple-500
  static const Color progressStartDark = Color(0xFF22D3EE); // Cyan-400
  static const Color progressEndDark = Color(0xFF2DD4BF); // Teal-400

  // Header gradients
  static const Color headerGradientStart = Color(0xFF4F46E5); // Indigo-600
  static const Color headerGradientEnd = Color(0xFF7C3AED); // Violet-600
  static const Color headerGradientStartDark = Color(0xFF0F172A); // Slate-900
  static const Color headerGradientEndDark = Color(0xFF1E293B); // Slate-800
}
