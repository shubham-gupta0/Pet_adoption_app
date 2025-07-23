import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Warm and trustworthy orange/coral
  static const Color primary = Color(0xFFFF6B35);      // Vibrant coral-orange
  static const Color primaryLight = Color(0xFFFF8A65);  // Lighter coral
  static const Color primaryDark = Color(0xFFE64A19);   // Deeper orange
  
  // Secondary Palette - Calming teal for balance
  static const Color secondary = Color(0xFF26A69A);     // Friendly teal
  static const Color secondaryLight = Color(0xFF80CBC4); // Light teal
  static const Color secondaryDark = Color(0xFF00695C); // Deep teal

  // Accent Palette - Playful and warm
  static const Color accent = Color(0xFFFFC107);        // Warm golden yellow
  static const Color accentLight = Color(0xFFFFE082);   // Light yellow
  static const Color accentDark = Color(0xFFFFA000);    // Amber

  // Success & Love colors
  static const Color success = Color(0xFF4CAF50);       // Heart/love green
  static const Color love = Color(0xFFE91E63);          // Pink for favorites
  static const Color warning = Color(0xFFFF9800);       // Orange warning

  // Background Palette - Clean and welcoming
  static const Color backgroundLight = Color(0xFFFFFBF7); // Warm white
  static const Color backgroundDark = Color(0xFF1A1A1A);  // Deep charcoal
  
  // Surface Palette - Clean cards and containers
  static const Color surfaceLight = Color(0xFFFFFFFF);    // Pure white
  static const Color surfaceDark = Color(0xFF2D2D2D);     // Dark grey
  static const Color surfaceElevated = Color(0xFFF5F5F5); // Subtle elevation

  // Text & Icon Palette - Clear and readable
  static const Color textPrimary = Color(0xFF2C2C2C);     // Almost black
  static const Color textSecondary = Color(0xFF757575);   // Medium grey
  static const Color textSubtle = Color(0xFF9E9E9E);      // Light grey
  static const Color textOnDark = Color(0xFFFFFFFF);      // White text
  static const Color textOnPrimary = Color(0xFFFFFFFF);   // White on primary

  // Dark theme text colors
  static const Color textDarkPrimary = Color(0xFFFFFFFF);   // White
  static const Color textDarkSecondary = Color(0xFFE0E0E0); // Light grey
  static const Color textDarkSubtle = Color(0xFFBDBDBD);    // Medium grey

  // Utility colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Pet category colors (optional for UI elements)
  static const Color dogColor = Color(0xFF8BC34A);        // Green
  static const Color catColor = Color(0xFF9C27B0);        // Purple
  static const Color birdColor = Color(0xFF03A9F4);       // Blue
  static const Color otherPetColor = Color(0xFFFF5722);   // Deep orange

  // Gradient colors for beautiful UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}