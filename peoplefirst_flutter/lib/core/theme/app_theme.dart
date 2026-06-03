import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.relianceBase,
        primary: AppColors.relianceBase,
        surface: AppColors.surfaceMinimal,
        background: AppColors.surfaceSubtle,
      ),
      scaffoldBackgroundColor: AppColors.surfaceSubtle,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.contentHeavy),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceMinimal,
        selectedItemColor: AppColors.relianceBase,
        unselectedItemColor: AppColors.contentMinimal,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceMinimal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.strokeMinimal,
        thickness: 1,
        space: 1,
      ),
      fontFamily: 'Roboto',
    );
  }
}
