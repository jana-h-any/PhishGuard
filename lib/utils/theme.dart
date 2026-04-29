import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppConstants.primaryPurple,
      scaffoldBackgroundColor: AppConstants.backgroundDark,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.primaryPurple,
        secondary: AppConstants.deepPurple,
        surface: AppConstants.surfaceDark,
        error: AppConstants.phishingRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppConstants.textPrimary),
      ),
      cardTheme: CardTheme(
        color: AppConstants.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppConstants.borderColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.surfaceDark,
        selectedItemColor: AppConstants.primaryPurple,
        unselectedItemColor: AppConstants.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
