import 'package:flutter/material.dart';

class AppColors {
  // Base / structural
  static const pageBackground = Color(0xFF0A1929);
  static const cardSurface = Color(0xFF152238);
  static const innerCard = Color(0xFF0A1929);
  static const border = Color(0xFF1E3A5F);

  // Brand
  static const primaryBlue = Color(0xFF2196F3);

  // Text
  static const textWhite = Color(0xFFFFFFFF);
  static const textLight = Color(0xFFCBD5E1);
  static const textMuted = Color(0xFF94A3B8);
  static const textPlaceholder = Color(0xFF5F7A9C);

  // Status
  static const success = Color(0xFF4ADE80);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFF87171);
  static const info = Color(0xFF2196F3);

  // Avatar colors
  static const avatarPurple = Color(0xFF8B5CF6);
  static const avatarOrange = Color(0xFFF59E0B);
  static const avatarPink = Color(0xFFEC4899);
  static const avatarCyan = Color(0xFF06B6D4);
  static const avatarGreen = Color(0xFF10B981);

  // Status with alpha (for tinted backgrounds)
  static Color get successTint => success.withOpacity(0.15);
  static Color get warningTint => warning.withOpacity(0.15);
  static Color get dangerTint => danger.withOpacity(0.15);
  static Color get infoTint => primaryBlue.withOpacity(0.06);
}