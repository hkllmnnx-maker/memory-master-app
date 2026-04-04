import 'package:flutter/material.dart';

class AppTheme {
  // Islamic Premium Color Palette
  static const Color primaryGold = Color(0xFFD4A853);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color lightGold = Color(0xFFF5E6B8);
  static const Color deepTeal = Color(0xFF0D6E6E);
  static const Color teal = Color(0xFF148F8F);
  static const Color lightTeal = Color(0xFFE0F2F1);
  static const Color deepNavy = Color(0xFF1A2332);
  static const Color navy = Color(0xFF2C3E50);
  static const Color softNavy = Color(0xFF34495E);
  static const Color emerald = Color(0xFF2ECC71);
  static const Color softEmerald = Color(0xFF27AE60);
  static const Color burgundy = Color(0xFF8E3B3B);
  static const Color warmWhite = Color(0xFFFAF8F5);
  static const Color cream = Color(0xFFF5F0E8);
  static const Color parchment = Color(0xFFF8F4EC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF4A4A5A);
  static const Color textGrey = Color(0xFF7A7A8A);
  static const Color textLight = Color(0xFFB0B0C0);
  static const Color divider = Color(0xFFE8E0D8);
  static const Color coral = Color(0xFFE74C3C);
  static const Color mintGreen = Color(0xFF00B894);
  static const Color golden = Color(0xFFFFD93D);
  static const Color softPurple = Color(0xFF6C5CE7);
  static const Color warmOrange = Color(0xFFFF9F43);
  static const Color skyBlue = Color(0xFF74B9FF);
  static const Color pinkAccent = Color(0xFFE84393);

  // Gradients
  static const LinearGradient islamicGradient = LinearGradient(
    colors: [deepNavy, Color(0xFF1B3A4B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4A853), Color(0xFFE8C97A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [deepTeal, teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1A2332), Color(0xFF1B3A4B), Color(0xFF0D6E6E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient quranHeaderGradient = LinearGradient(
    colors: [Color(0xFF1A2332), Color(0xFF0D4E4E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGold, darkGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> categoryColors = [
    deepTeal,
    primaryGold,
    softPurple,
    emerald,
    burgundy,
    navy,
    coral,
    skyBlue,
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: deepTeal,
      scaffoldBackgroundColor: warmWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepTeal,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: deepTeal.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGold,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: deepTeal,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: deepTeal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
