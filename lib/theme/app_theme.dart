import 'package:flutter/material.dart';

class AppColors {
  // Primary colors matching the screenshot design
  static const Color primary = Color(0xFF2D6A5A);
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color primaryLight = Color(0xFF40916C);
  static const Color accent = Color(0xFFD4A373);
  static const Color accentLight = Color(0xFFE9C46A);
  static const Color gold = Color(0xFFD4A373);
  static const Color goldLight = Color(0xFFF2D49B);

  // Background
  static const Color bgLight = Color(0xFFF5F0E8);
  static const Color bgCard = Color(0xFFFAF6F0);
  static const Color bgDark = Color(0xFF1B4332);
  static const Color bgHeader = Color(0xFF2D6A5A);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textMuted = Color(0xFF8C8C8C);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textQuran = Color(0xFF1A1A1A);

  // Status
  static const Color success = Color(0xFF2D6A5A);
  static const Color error = Color(0xFFE76F51);
  static const Color warning = Color(0xFFE9C46A);

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1B4332), Color(0xFF2D6A5A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4A373), Color(0xFFF2D49B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.bgCard,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgHeader,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgDark,
        selectedItemColor: AppColors.accentLight,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.accent,
        surface: const Color(0xFF1E3A2F),
      ),
      scaffoldBackgroundColor: const Color(0xFF0D1F17),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D1F17),
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E3A2F),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
