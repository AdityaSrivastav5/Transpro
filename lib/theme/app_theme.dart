// THEME LOCK: light — source: prompt (enterprise logistics, navy/blue brief)
// Scaffold background = AppTheme.background — all screens
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Brand
  static const Color primary = Color(0xFF0F2A4A);
  static const Color accent = Color(0xFF2563EB);
  static const Color background = Color(0xFFF6F8FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // Text and icon tokens (light)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color iconInactive = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnPrimarySecondary = Color(0xFFD6E2F5);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // Semantic status: foreground text, tinted surface, solid accent
  static const Color successText = Color(0xFF14532D);
  static const Color successSurface = Color(0xFFE7F6EC);
  static const Color successSolid = Color(0xFF16A34A);

  static const Color warningText = Color(0xFF7A4B00);
  static const Color warningSurface = Color(0xFFFFF4DB);
  static const Color warningSolid = Color(0xFFF59E0B);

  static const Color dangerText = Color(0xFF991B1B);
  static const Color dangerSurface = Color(0xFFFDE8E8);
  static const Color dangerSolid = Color(0xFFDC2626);

  static const Color infoText = Color(0xFF1E3A8A);
  static const Color infoSurface = Color(0xFFE5EEFF);
  static const Color infoSolid = Color(0xFF2563EB);

  static const Color neutralText = Color(0xFF334155);
  static const Color neutralSurface = Color(0xFFEEF1F6);
  static const Color neutralSolid = Color(0xFF94A3B8);

  // Dark surfaces
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF131C2E);
  static const Color darkBorder = Color(0xFF243049);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFA9B4C6);
  static const Color darkIconInactive = Color(0xFF8C99AE);
  static const Color darkAccent = Color(0xFF7FA8FF);
  static const Color darkOnAccent = Color(0xFF0B1220);

  static const double radius = 12;
  static const double screenPadding = 16;

  static TextTheme _textTheme(Brightness b) {
    final primary = b == Brightness.light ? textPrimary : darkTextPrimary;
    final secondary = b == Brightness.light ? textSecondary : darkTextSecondary;
    final base = GoogleFonts.interTextTheme(
      b == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme,
    );
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
    );
  }

  static ThemeData get lightTheme {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: textOnPrimary,
      secondary: accent,
      onSecondary: textOnAccent,
      error: dangerSolid,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      surfaceContainerHighest: neutralSurface,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: border,
      secondaryContainer: infoSurface,
      onSecondaryContainer: infoText,
      inverseSurface: primary,
      onInverseSurface: textOnPrimary,
    );
    return _build(scheme, background, border, textPrimary, iconInactive);
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: darkAccent,
      onPrimary: darkOnAccent,
      secondary: darkAccent,
      onSecondary: darkOnAccent,
      error: Color(0xFFFF8A8A),
      onError: Color(0xFF0B1220),
      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: Color(0xFF1B2640),
      onSurfaceVariant: darkTextSecondary,
      outline: darkBorder,
      outlineVariant: darkBorder,
      secondaryContainer: Color(0xFF1E3A8A),
      onSecondaryContainer: Color(0xFFE5EEFF),
      inverseSurface: darkTextPrimary,
      onInverseSurface: darkBackground,
    );
    return _build(
      scheme,
      darkBackground,
      darkBorder,
      darkTextPrimary,
      darkIconInactive,
    );
  }

  static ThemeData _build(
    ColorScheme scheme,
    Color bg,
    Color borderColor,
    Color text,
    Color inactiveIcon,
  ) {
    final isLight = scheme.brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: _textTheme(scheme.brightness),
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        iconTheme: IconThemeData(color: text),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: inactiveIcon),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: scheme.secondary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isLight ? accent : darkAccent,
          foregroundColor: isLight ? textOnAccent : darkOnAccent,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          minimumSize: const Size(48, 48),
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? accent : darkAccent,
          minimumSize: const Size(48, 48),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: isLight ? infoSurface : const Color(0xFF1E3A8A),
        side: BorderSide(color: borderColor),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isLight ? accent : darkAccent,
        foregroundColor: isLight ? textOnAccent : darkOnAccent,
        elevation: 2,
        extendedTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? (isLight ? Colors.white : darkOnAccent)
              : inactiveIcon,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? (isLight ? accent : darkAccent)
              : borderColor,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondaryContainer,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => GoogleFonts.inter(
            fontSize: 12,
            fontWeight: s.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: s.contains(WidgetState.selected)
                ? (isLight ? primary : darkTextPrimary)
                : inactiveIcon,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight ? primary : darkTextPrimary,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: isLight ? textOnPrimary : darkBackground,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}