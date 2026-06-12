import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌸 Renk Paleti
  static const Color primary = Color(0xFF874C67);
  static const Color primaryContainer = Color(0xFFE8A0BF);
  static const Color secondary = Color(0xFF7D5070);
  static const Color secondaryContainer = Color(0xFFFDC4E9);
  static const Color background = Color(0xFFFFF8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF7EBED);
  static const Color onSurface = Color(0xFF201A1C);
  static const Color onSurfaceVariant = Color(0xFF514348);
  static const Color outline = Color(0xFFD5C2C7);
  static const Color error = Color(0xFFBA1A1A);

  // Eski ekranlarla uyumluluk için
  static const Color textDark = Color(0xFF201A1C);
  static const Color textLight = Color(0xFF514348);
  static const Color accent = Color(0xFFEBE0E2);

  // Dark mode
  static const Color darkBackground = Color(0xFF201A1C);
  static const Color darkSurface = Color(0xFF352F31);
  static const Color darkSurfaceContainer = Color(0xFF3D3538);

  // Text stilleri
  static TextStyle get headlineXL => GoogleFonts.plusJakartaSans(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: onSurface,
  );

  static TextStyle get headlineLG => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: onSurface,
  );

  static TextStyle get headlineMD => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: onSurface,
  );

  static TextStyle get bodyLG => GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static TextStyle get bodyMD => GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static TextStyle get labelMD => GoogleFonts.quicksand(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: onSurface,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF6B344F),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF7A4D6D),
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      error: error,
    ),
    scaffoldBackgroundColor: background,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 40, fontWeight: FontWeight.w800, color: onSurface),
      headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32, fontWeight: FontWeight.w700, color: onSurface),
      headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24, fontWeight: FontWeight.w700, color: onSurface),
      headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.w700, color: onSurface),
      titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18, fontWeight: FontWeight.w700, color: onSurface),
      titleMedium: GoogleFonts.quicksand(
          fontSize: 16, fontWeight: FontWeight.w700, color: onSurface),
      titleSmall: GoogleFonts.quicksand(
          fontSize: 14, fontWeight: FontWeight.w700, color: onSurface),
      bodyLarge: GoogleFonts.quicksand(
          fontSize: 18, fontWeight: FontWeight.w500, color: onSurface),
      bodyMedium: GoogleFonts.quicksand(
          fontSize: 16, fontWeight: FontWeight.w500, color: onSurface),
      bodySmall: GoogleFonts.quicksand(
          fontSize: 14, fontWeight: FontWeight.w500,
          color: onSurfaceVariant),
      labelLarge: GoogleFonts.quicksand(
          fontSize: 14, fontWeight: FontWeight.w700, color: onSurface),
      labelMedium: GoogleFonts.quicksand(
          fontSize: 12, fontWeight: FontWeight.w700,
          color: onSurfaceVariant),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: background,
      foregroundColor: onSurface,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFEBE0E2), width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFDF1F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFD5C2C7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFD5C2C7), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      labelStyle: GoogleFonts.quicksand(color: onSurfaceVariant),
      hintStyle: GoogleFonts.quicksand(
          color: onSurfaceVariant.withOpacity(0.7)),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary,
      thumbColor: primary,
      inactiveTrackColor: const Color(0xFFEBE0E2),
      overlayColor: primary.withOpacity(0.2),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return const Color(0xFFD5C2C7);
      }),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: onSurfaceVariant,
      selectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12, fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12, fontWeight: FontWeight.w500),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
        color: Color(0xFFEBE0E2), thickness: 1),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF7EBED),
      labelStyle: GoogleFonts.quicksand(
          fontSize: 12, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: const BorderSide(color: Color(0xFFD5C2C7)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
  );

  // 🌙 Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFBB1D1),
      onPrimary: Color(0xFF370923),
      primaryContainer: Color(0xFF6C354F),
      onPrimaryContainer: Color(0xFFFFD8E6),
      secondary: Color(0xFFEEB6DB),
      onSecondary: Color(0xFF310D2A),
      secondaryContainer: Color(0xFF633958),
      onSecondaryContainer: Color(0xFFFFD7F0),
      surface: darkSurface,
      onSurface: Color(0xFFF5EFF1),
      onSurfaceVariant: Color(0xFFD5C2C7),
      outline: Color(0xFF9E8C91),
      error: Color(0xFFFFB4AB),
    ),
    scaffoldBackgroundColor: darkBackground,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 40, fontWeight: FontWeight.w800,
          color: const Color(0xFFF5EFF1)),
      headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32, fontWeight: FontWeight.w700,
          color: const Color(0xFFF5EFF1)),
      headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24, fontWeight: FontWeight.w700,
          color: const Color(0xFFF5EFF1)),
      headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: const Color(0xFFF5EFF1)),
      titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: const Color(0xFFF5EFF1)),
      titleMedium: GoogleFonts.quicksand(
          fontSize: 16, fontWeight: FontWeight.w700,
          color: const Color(0xFFF5EFF1)),
      bodyLarge: GoogleFonts.quicksand(
          fontSize: 18, fontWeight: FontWeight.w500,
          color: const Color(0xFFF5EFF1)),
      bodyMedium: GoogleFonts.quicksand(
          fontSize: 16, fontWeight: FontWeight.w500,
          color: const Color(0xFFF5EFF1)),
      bodySmall: GoogleFonts.quicksand(
          fontSize: 14, fontWeight: FontWeight.w500,
          color: const Color(0xFFD5C2C7)),
      labelLarge: GoogleFonts.quicksand(
          fontSize: 14, fontWeight: FontWeight.w700,
          color: const Color(0xFFF5EFF1)),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: darkBackground,
      foregroundColor: const Color(0xFFF5EFF1),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF5EFF1),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
            color: Color(0xFF4D4044), width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFBB1D1),
        foregroundColor: const Color(0xFF370923),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 14),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: const Color(0xFFFBB1D1),
      unselectedItemColor: const Color(0xFFD5C2C7),
      selectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12, fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12, fontWeight: FontWeight.w500),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFF4D4044)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide:
        const BorderSide(color: Color(0xFF4D4044), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(
            color: Color(0xFFFBB1D1), width: 2),
      ),
    ),
  );
}