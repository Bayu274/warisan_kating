import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// Warisan Kating — Global Design System (AppTheme)
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Palette  : Indigo/Teal primary, Amber accent, Light Grey scaffold background
/// Typography: GoogleFonts.poppinsTextTheme() with Inter body styling
/// Shapes    : CardTheme (elev: 2, r: 12), ElevatedButtonTheme (h: 48, r: 12),
///             InputDecorationTheme (filled: true, OutlineInputBorder r: 12)
/// ═══════════════════════════════════════════════════════════════════════════
class AppTheme {
  AppTheme._();

  // ──────────────────────────── Color Palette ────────────────────────────
  // Primary (Indigo / Teal)
  static const Color primary = Color(0xFF3F51B5); // Indigo
  static const Color primaryDark = Color(0xFF303F9F);
  static const Color primaryLight = Color(0xFFC5CAE9);
  static const Color tealAccent = Color(0xFF009688); // Modern Teal accent

  // Secondary / Accent (Amber)
  static const Color secondary = Color(0xFFFFC107); // Amber
  static const Color secondaryDark = Color(0xFFFFA000);

  // Backgrounds & Surfaces (Light Grey)
  static const Color scaffoldBg = Color(0xFFF5F5F5); // Light grey background
  static const Color surfaceColor = Colors.white;

  // Neutrals & Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color disabledColor = Color(0xFFBDBDBD);

  // Semantic
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  // ──────────────────────────── Shapes & Radii ───────────────────────────
  static const double borderRadiusValue = 12.0;
  static final BorderRadius borderRadius12 = BorderRadius.circular(borderRadiusValue);

  // ──────────────────────────── Color Scheme ────────────────────────────
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: textPrimary,
    tertiary: tealAccent,
    error: error,
    surface: surfaceColor,
    onSurface: textPrimary,
    brightness: Brightness.light,
  );

  // ──────────────────────────── ThemeData ────────────────────────────────
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      brightness: Brightness.light,
    );

    // Poppins text theme with customized text styles
    final poppinsTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
    final textTheme = poppinsTheme.copyWith(
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBg,

      // ── AppBarTheme ──
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // ── CardTheme (elevation: 2, borderRadius: 12) ──
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: borderRadius12),
        surfaceTintColor: Colors.transparent,
        color: surfaceColor,
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButtonTheme (borderRadius: 12, min height: 48) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: borderRadius12),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── FilledButtonTheme ──
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: borderRadius12),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── OutlinedButtonTheme ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: borderRadius12),
          side: const BorderSide(color: primary, width: 1.5),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── InputDecorationTheme (filled: true, border: OutlineInputBorder r: 12) ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: disabledColor, fontSize: 14),
      ),

      // ── BottomNavigationBarTheme ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        backgroundColor: surfaceColor,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // ── DialogTheme ──
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    );
  }
}
