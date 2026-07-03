import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware semantic color palette.
///
/// Widgets read colors via `context.palette.<token>` so they automatically
/// adapt to the active [ThemeMode] (light / dark). The dark variant reuses the
/// existing GitHub-dark constants from [AppColors]; the light variant is a
/// clean, high-contrast counterpart.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color primary;
  final Color primaryDark;
  final Color success;
  final Color warning;
  final Color error;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  // Category accent colors (used on the home dashboard & list tiles).
  final Color accentDocuments;
  final Color accentNotes;
  final Color accentPasswords;
  final Color accentPages;

  // Card network colors.
  final Color cardVisa;
  final Color cardMastercard;
  final Color cardRupay;
  final Color cardAmex;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.primary,
    required this.primaryDark,
    required this.success,
    required this.warning,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accentDocuments,
    required this.accentNotes,
    required this.accentPasswords,
    required this.accentPages,
    required this.cardVisa,
    required this.cardMastercard,
    required this.cardRupay,
    required this.cardAmex,
  });

  static const AppPalette dark = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceLight: AppColors.surfaceLight,
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    border: AppColors.border,
    accentDocuments: Color(0xFF4CAF50),
    accentNotes: Color(0xFFFF9800),
    accentPasswords: AppColors.primary,
    accentPages: Color(0xFF9C27B0),
    cardVisa: AppColors.cardVisa,
    cardMastercard: AppColors.cardMastercard,
    cardRupay: AppColors.cardRupay,
    cardAmex: AppColors.cardAmex,
  );

  static const AppPalette light = AppPalette(
    background: Color(0xFFF6F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFEFF2F5),
    primary: Color(0xFF0969DA),
    primaryDark: Color(0xFF0550AE),
    success: Color(0xFF1A7F37),
    warning: Color(0xFF9A6700),
    error: Color(0xFFCF222E),
    textPrimary: Color(0xFF1F2328),
    textSecondary: Color(0xFF656D76),
    border: Color(0xFFD0D7DE),
    accentDocuments: Color(0xFF2E7D32),
    accentNotes: Color(0xFFE65100),
    accentPasswords: Color(0xFF0969DA),
    accentPages: Color(0xFF7B1FA2),
    cardVisa: AppColors.cardVisa,
    cardMastercard: AppColors.cardMastercard,
    cardRupay: AppColors.cardRupay,
    cardAmex: AppColors.cardAmex,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? primary,
    Color? primaryDark,
    Color? success,
    Color? warning,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? accentDocuments,
    Color? accentNotes,
    Color? accentPasswords,
    Color? accentPages,
    Color? cardVisa,
    Color? cardMastercard,
    Color? cardRupay,
    Color? cardAmex,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      accentDocuments: accentDocuments ?? this.accentDocuments,
      accentNotes: accentNotes ?? this.accentNotes,
      accentPasswords: accentPasswords ?? this.accentPasswords,
      accentPages: accentPages ?? this.accentPages,
      cardVisa: cardVisa ?? this.cardVisa,
      cardMastercard: cardMastercard ?? this.cardMastercard,
      cardRupay: cardRupay ?? this.cardRupay,
      cardAmex: cardAmex ?? this.cardAmex,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      accentDocuments: Color.lerp(accentDocuments, other.accentDocuments, t)!,
      accentNotes: Color.lerp(accentNotes, other.accentNotes, t)!,
      accentPasswords: Color.lerp(accentPasswords, other.accentPasswords, t)!,
      accentPages: Color.lerp(accentPages, other.accentPages, t)!,
      cardVisa: Color.lerp(cardVisa, other.cardVisa, t)!,
      cardMastercard: Color.lerp(cardMastercard, other.cardMastercard, t)!,
      cardRupay: Color.lerp(cardRupay, other.cardRupay, t)!,
      cardAmex: Color.lerp(cardAmex, other.cardAmex, t)!,
    );
  }
}

/// Convenient access: `context.palette.surface`.
extension PaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
