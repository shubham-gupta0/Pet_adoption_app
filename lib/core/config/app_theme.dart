import 'package:flutter/material.dart';
import 'package:pet_adoption_app/core/config/app_colors.dart';

class AppTheme {
  // Define the Inter font family with fallbacks for web compatibility
  static const String _fontFamily = 'Inter';

  // Fallback font family list for better web support
  static const List<String> _fontFamilyFallback = [
    'Inter',
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif'
  ];

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    useMaterial3: true,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textPrimary,
      tertiaryContainer: AppColors.accentLight,
      onTertiaryContainer: AppColors.textPrimary,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimary,
      surfaceVariant: AppColors.surfaceElevated,
      onSurfaceVariant: AppColors.textSecondary,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textPrimary,
      error: AppColors.warning,
      onError: AppColors.white,
      outline: AppColors.divider,
      shadow: AppColors.shadow,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.shadow,
      surfaceTintColor: AppColors.backgroundLight,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 3,
      shadowColor: AppColors.shadow,
      surfaceTintColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 3,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFamilyFallback,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        color: AppColors.textSecondary,
        fontSize: 16,
      ),
      labelStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        color: AppColors.textSecondary,
        fontSize: 16,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    useMaterial3: true,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.white,
      surfaceVariant: AppColors.surfaceElevated,
      onSurfaceVariant: AppColors.textSecondary,
      background: AppColors.backgroundDark,
      onBackground: AppColors.white,
      error: AppColors.warning,
      onError: AppColors.white,
      outline: AppColors.divider,
      shadow: AppColors.shadow,
    ),
  );
}
