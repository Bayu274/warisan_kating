import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// Warisan Kating — Global Design System
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Color palette  : Indigo/Teal primary · Amber accent · Light grey surface
/// Typography     : Poppins (headings) · Inter (body)
/// Shape language : 12 px border-radius everywhere (cards, buttons, inputs)
/// ═══════════════════════════════════════════════════════════════════════════
class AppTheme {
  AppTheme._();

  // ──────────────────────────── Color Tokens ────────────────────────────

  // Primary – Indigo → Teal gradient feel
  static const Color primary       = Color(0xFF3F51B5); // Indigo 500
  static const Color primaryDark   = Color(0xFF303F9F); // Indigo 700
  static const Color primaryLight  = Color(0xFFC5CAE9); // Indigo 100

  // Secondary / Accent – warm Amber
  static const Color secondary     = Color(0xFFFFC107); // Amber 500
  static const Color secondaryDark = Color(0xFFFFA000); // Amber 700

  // Teal highlight (used sparingly for accents & chips)
  static const Color teal          = Color(0xFF009688); // Teal 500

  // Neutrals
  static const Color scaffoldBg    = Color(0xFFF5F5F5); // Grey 100
  static const Color surfaceColor  = Colors.white;
  static const Color textPrimary   = Color(0xFF212121); // Grey 900
  static const Color textSecondary = Color(0xFF757575); // Grey 600
  static const Color dividerColor  = Color(0xFFE0E0E0); // Grey 300
  static const Color disabledColor = Color(0xFFBDBDBD); // Grey 400

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // ──────────────────────────── Shape Tokens ────────────────────────────

  static const double radiusSm  = 8;
  static const double radiusMd  = 12;
  static const double radiusLg  = 16;
  static const double radiusXl  = 24;

  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);

  // ──────────────────────────── Spacing Tokens ──────────────────────────

  static const double spacingXs  = 4;
  static const double spacingSm  = 8;
  static const double spacingMd  = 16;
  static const double spacingLg  = 24;
  static const double spacingXl  = 32;

  // ──────────────────────────── Typography ──────────────────────────────

  /// Poppins for headings, Inter for body/labels.
  static TextTheme _buildTextTheme(TextTheme base) {
    final headingStyle = GoogleFonts.poppins(color: textPrimary);
    final bodyStyle    = GoogleFonts.inter(color: textPrimary);

    return base.copyWith(
      // ── Display ──
      displayLarge:  headingStyle.copyWith(fontSize: 57, fontWeight: FontWeight.w400),
      displayMedium: headingStyle.copyWith(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall:  headingStyle.copyWith(fontSize: 36, fontWeight: FontWeight.w400),

      // ── Headline ──
      headlineLarge:  headingStyle.copyWith(fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: headingStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall:  headingStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600),

      // ── Title ──
      titleLarge:  headingStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: headingStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall:  headingStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),

      // ── Body ──
      bodyLarge:  bodyStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: bodyStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall:  bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary),

      // ── Label ──
      labelLarge:  bodyStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall:  bodyStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary),
    );
  }

  // ──────────────────────────── Color Scheme ────────────────────────────

  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: textPrimary,
    tertiary: teal,
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

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      scaffoldBackgroundColor: scaffoldBg,

      // ── AppBar ──
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

      // ── Bottom Navigation Bar ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        backgroundColor: surfaceColor,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
        surfaceTintColor: Colors.transparent,
        color: surfaceColor,
        margin: EdgeInsets.zero,
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Filled Button ──
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
          side: const BorderSide(color: primary, width: 1.5),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input Decoration (TextFields) ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: disabledColor, fontSize: 14),
        errorStyle: GoogleFonts.inter(color: error, fontSize: 12),
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
        ),
        showDragHandle: true,
      ),

      // ── Snack Bar ──
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: primaryLight,
        labelStyle: GoogleFonts.inter(fontSize: 12, color: primaryDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        side: BorderSide.none,
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: textPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // ── ListTile ──
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
      ),
    );
  }
}
