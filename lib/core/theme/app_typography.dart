import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography system – modern, premium feel.
///
/// Headings: Outfit (geometric, clean, great for gaming UI)
/// Body/Labels: Inter (highly readable, optimized for UI)
class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    final headingFont = GoogleFonts.outfit;
    final bodyFont = GoogleFonts.inter;

    return TextTheme(
      displayLarge: headingFont(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: headingFont(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: headingFont(fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: headingFont(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: headingFont(fontSize: 28, fontWeight: FontWeight.w700),
      headlineSmall: headingFont(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: headingFont(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: bodyFont(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: bodyFont(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: bodyFont(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      bodyMedium: bodyFont(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: bodyFont(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: bodyFont(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: bodyFont(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: bodyFont(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
