import 'package:flutter/material.dart';

/// App color palette - defines all colors used in the app theme.
/// Colors updated based on palette selections:
/// Light: https://colorhunt.co/palette/ff8f8ffff1cbc2e2fab7a3e3
/// Dark: https://colorhunt.co/palette/1b3c53234c6a456882d2c1b6
class AppColors {
  AppColors._();

  // Light Theme Colors
  static const Color lightPrimary = Color(0xFFB7A3E3); // Soft Purple
  static const Color lightPrimaryVariant = Color(0xFFA58FD1);
  static const Color lightSecondary = Color(0xFFC2E2FA); // Soft Blue
  static const Color lightSecondaryVariant = Color(0xFFAED4F2);
  static const Color lightBackground = Color(0xFFFFF1CB); // Cream/Beige
  static const Color lightSurface = Color(0xFFFFF8E1);
  static const Color lightError = Color(0xFFFF8F8F); // Salmon/Pink
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFF2C3E50);
  static const Color lightOnBackground = Color(0xFF1C1C1E);
  static const Color lightOnSurface = Color(0xFF1C1C1E);
  static const Color lightOnError = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFD2C1B6); // Soft Tan
  static const Color darkPrimaryVariant = Color(0xFFB5A196);
  static const Color darkSecondary = Color(0xFF456882); // Muted Blue
  static const Color darkSecondaryVariant = Color(0xFF344E61);
  static const Color darkBackground = Color(0xFF1B3C53); // Navy Blue
  static const Color darkSurface = Color(0xFF234C6A); // Deep Blue
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Color(0xFF1B3C53);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFD2C1B6);
  static const Color darkOnSurface = Color(0xFFD2C1B6);
  static const Color darkOnError = Color(0xFF000000);
}
