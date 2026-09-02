import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);
  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final onPrimary = isDark ? const Color(0xFF141210) : Colors.white;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: onPrimary,
      primaryContainer: isDark ? p.surfaceLight : p.primary.withValues(alpha: 0.1),
      onPrimaryContainer: isDark ? p.primary : p.primaryDark,
      secondary: p.primary,
      onSecondary: onPrimary,
      secondaryContainer: p.surfaceLight,
      onSecondaryContainer: p.textPrimary,
      surface: p.surface,
      onSurface: p.textPrimary,
      surfaceContainerLowest: p.background,
      surfaceContainerLow: p.surface,
      surfaceContainer: p.surface,
      surfaceContainerHigh: p.surfaceLight,
      surfaceContainerHighest: p.surfaceLight,
      onSurfaceVariant: p.textSecondary,
      outline: p.border,
      outlineVariant: p.border.withValues(alpha: 0.6),
      error: p.error,
      onError: Colors.white,
    );

    final baseTextTheme = isDark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    // Refined type scale on the platform font (kept fully offline — no
    // network font fetching, preserving the zero-knowledge guarantee).
    final textTheme = baseTextTheme
        .apply(
          bodyColor: p.textPrimary,
          displayColor: p.textPrimary,
        )
        .copyWith(
          headlineMedium: baseTextTheme.headlineMedium?.copyWith(
            color: p.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            color: p.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleMedium: baseTextTheme.titleMedium?.copyWith(
            color: p.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(
            color: p.textPrimary,
            fontSize: 15,
            height: 1.45,
          ),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(
            color: p.textPrimary,
            fontSize: 14,
            height: 1.4,
          ),
          bodySmall: baseTextTheme.bodySmall?.copyWith(
            color: p.textSecondary,
            fontSize: 12,
          ),
          labelLarge: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          labelSmall: baseTextTheme.labelSmall?.copyWith(
            color: p.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      cardColor: p.surface,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[p],
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: p.textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: p.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: p.textSecondary),
        hintStyle: TextStyle(color: p.textSecondary.withValues(alpha: 0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: p.surfaceLight,
          foregroundColor: p.textSecondary,
          selectedBackgroundColor: isDark ? p.surface : Colors.white,
          selectedForegroundColor: isDark ? p.textPrimary : p.primary,
          elevation: isDark ? 1 : 1,
          side: BorderSide(color: p.border, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.border, width: 1),
        ),
        titleTextStyle: TextStyle(
          color: p.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(
          color: p.textSecondary,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      dividerColor: p.border,
      dividerTheme: DividerThemeData(color: p.border, thickness: 1),
      iconTheme: IconThemeData(color: p.textSecondary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.primary,
        foregroundColor: onPrimary,
        elevation: 3,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        textColor: p.textPrimary,
        iconColor: p.textSecondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceLight,
        selectedColor: p.primary.withValues(alpha: 0.16),
        labelStyle: TextStyle(color: p.textPrimary, fontSize: 13),
        side: BorderSide(color: p.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.surfaceLight,
        contentTextStyle: TextStyle(color: p.textPrimary, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: p.border),
        ),
      ),
    );
  }
}
