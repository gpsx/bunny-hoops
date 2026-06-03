import 'package:flutter/material.dart';

class AppColors {
  // --- DEPRECATED STATIC COLORS ---
  // These should be replaced with Theme.of(context).colorScheme references
  @deprecated
  static const primary = Color(0xFFFFB7CE);
  @deprecated
  static const secondary = Color(0xFFFF8C42);
  @deprecated
  static const background = Color(0xFFFFFDF5);
  @deprecated
  static const neutral = Color(0xFF8D7B7B);
  @deprecated
  static const white = Color(0xFFFFFFFF);
  @deprecated
  static const textDark = Color(0xFF4A4A4A);

  // --- LIGHT THEME (Bunny Core Romantic) ---
  static const lightPrimary = Color(0xFFFFB7CE);
  static const lightOnPrimary = Color(0xFF7B4458);
  static const lightSecondary = Color(0xFFFF8C42);
  static const lightBackground = Color(0xFFFFF8F7);
  static const lightSurface = Color(0xFFFFF8F7);
  static const lightSurfaceContainer = Color(0xFFFFE9E8);
  static const lightOnSurface = Color(0xFF241919);
  static const lightOnSurfaceVariant = Color(0xFF8D7B7B); // Mapped for neutral
  static const lightError = Color(0xFFBA1A1A);

  // --- DARK THEME (Midnight Rose Tracker) ---
  static const darkPrimary = Color(0xFFFFDFE7);
  static const darkOnPrimary = Color(0xFF502033);
  static const darkPrimaryContainer = Color(0xFFFFB7CE);
  static const darkSecondary = Color(0xFFD7C1C5);
  static const darkBackground = Color(0xFF161213);
  static const darkSurface = Color(0xFF161213);
  static const darkSurfaceContainer = Color(0xFF231F20);
  static const darkOnSurface = Color(0xFFE9E0E1);
  static const darkOnSurfaceVariant = Color(0xFFD5C2C6);
  static const darkError = Color(0xFFFFB4AB);
}
