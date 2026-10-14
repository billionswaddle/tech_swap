import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // ─── DARK ─────────────────────────────────────
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.pageBackground,
    primaryColor: AppColors.primaryBlue,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary:    AppColors.primaryBlue,
      surface:    AppColors.cardSurface,
      onSurface:  AppColors.textWhite,
      onPrimary:  AppColors.textWhite,
    ),
    cardColor:      AppColors.cardSurface,
    dividerColor:   AppColors.border,
    iconTheme:      const IconThemeData(color: AppColors.textMuted),
    textTheme: const TextTheme(
      bodyLarge:   TextStyle(color: AppColors.textWhite),
      bodyMedium:  TextStyle(color: AppColors.textLight),
      bodySmall:   TextStyle(color: AppColors.textMuted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textWhite),
      titleTextStyle: TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.w600),
    ),
  );

  // ─── LIGHT ────────────────────────────────────
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightPageBackground,
    primaryColor: AppColors.primaryBlue,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary:    AppColors.primaryBlue,
      surface:    AppColors.lightCardSurface,
      onSurface:  AppColors.lightTextPrimary,
      onPrimary:  AppColors.textWhite,
    ),
    cardColor:      AppColors.lightCardSurface,
    dividerColor:   AppColors.lightBorder,
    iconTheme:      const IconThemeData(color: AppColors.lightTextMuted),
    textTheme: const TextTheme(
      bodyLarge:   TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium:  TextStyle(color: AppColors.lightTextSecondary),
      bodySmall:   TextStyle(color: AppColors.lightTextMuted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightPageBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(color: AppColors.lightTextPrimary, fontSize: 18, fontWeight: FontWeight.w600),
    ),
  );
}