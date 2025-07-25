import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingTheme {
  // Primary Colors - Islamic Green palette
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF8BC34A);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  static const Color black = Color(0xFF000000);

  // Semantic Colors
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color successGreen = Color(0xFF388E3C);

  // Text Styles with Google Fonts
  static TextStyle get headlineLarge => GoogleFonts.amiri(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkGreen,
    height: 1.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: darkGreen,
    height: 1.3,
  );

  static TextStyle get headlineSmall => GoogleFonts.amiri(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: darkGray,
    height: 1.4,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: darkGray,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: darkGray,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: mediumGray,
    height: 1.4,
  );

  static TextStyle get labelLarge => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: white,
  );

  static TextStyle get labelMedium => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: darkGray,
  );

  // Islamic Text Style - Using Amiri for Arabic text
  static TextStyle get islamicText => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: primaryGreen,
    height: 1.8,
  );

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [white, lightGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Theme Data with Google Fonts
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: lightGreen,
        surface: white,
        error: errorRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: darkGray,
        onError: white,
      ),
      textTheme: TextTheme(
        displayLarge: headlineLarge,
        displayMedium: headlineMedium,
        displaySmall: headlineSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkGreen),
        titleTextStyle: headlineMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
          textStyle: labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
          textStyle: labelMedium.copyWith(color: primaryGreen),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: bodyMedium.copyWith(
            color: primaryGreen,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        labelStyle: bodyMedium,
        hintStyle: bodyMedium.copyWith(color: mediumGray),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
      ),
    );
  }
}
