import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
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

  // Enhanced Text Styles with Google Fonts - Larger and Bolder
  static TextStyle get headlineLarge => GoogleFonts.pacifico(
    fontSize: 40, // Increased from 32
    fontWeight: FontWeight.bold,
    color: darkGreen,
    height: 1.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.grandifloraOne(
    fontSize: 28, // Increased from 24
    fontWeight: FontWeight.bold, // Changed from w600 to bold
    color: darkGreen,
    height: 1.3,
  );

  static TextStyle get headlineSmall => GoogleFonts.grandifloraOne(
    fontSize: 22, // Increased from 20
    fontWeight: FontWeight.bold, // Changed from w500 to bold
    color: darkGray,
    height: 1.4,
  );

  static TextStyle get bodyLarge => GoogleFonts.aBeeZee(
    fontSize: 18, // Increased from 16
    fontWeight: FontWeight.w500, // Changed from normal to w500
    color: darkGray,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.aBeeZee(
    fontSize: 16, // Increased from 14
    fontWeight: FontWeight.w500, // Changed from normal to w500
    color: darkGray,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.aBeeZee(
    fontSize: 14, // Increased from 12
    fontWeight: FontWeight.normal,
    color: primaryGreen,
    height: 1.4,
  );

  static TextStyle get labelLarge => GoogleFonts.robotoMono(
    fontSize: 16, // Increased from 14
    fontWeight: FontWeight.bold, // Changed from w500 to bold
    color: primaryGreen,
  );

  static TextStyle get labelMedium => GoogleFonts.robotoMono(
    fontSize: 14, // Increased from 12
    fontWeight: FontWeight.w600, // Changed from w500 to w600
    color: primaryGreen,
  );

  static TextStyle get labelSmall => GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: primaryGreen,
  );

  // Dark mode text styles
  static TextStyle get darkHeadlineLarge => GoogleFonts.pacifico(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: white,
    height: 1.2,
  );

  static TextStyle get darkHeadlineMedium => GoogleFonts.grandifloraOne(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: white,
    height: 1.3,
  );

  static TextStyle get darkHeadlineSmall => GoogleFonts.grandifloraOne(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: white,
    height: 1.4,
  );

  static TextStyle get darkBodyLarge => GoogleFonts.aBeeZee(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    height: 1.5,
  );

  static TextStyle get darkBodyMedium => GoogleFonts.aBeeZee(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    height: 1.5,
  );

  static TextStyle get darkBodySmall => GoogleFonts.aBeeZee(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white60,
    height: 1.4,
  );

  static TextStyle get darkLabelLarge => GoogleFonts.robotoMono(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static TextStyle get darkLabelMedium => GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
  );

  static TextStyle get darkLabelSmall => GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white60,
  );

  // Islamic Text Style - Using Amiri for Arabic text (keeping Amiri for Arabic support)
  static TextStyle get islamicText => GoogleFonts.amiri(
    fontSize: 28, // Increased from 24
    fontWeight: FontWeight.bold, // Changed from w600 to bold
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

  // Shadows - Cleaner, modern styling
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(color: Color(0x26000000), blurRadius: 6, offset: Offset(0, 2)),
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
  static ThemeData get lightTheme {
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
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
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
          elevation: 4, // Increased elevation for better visibility
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
          side: const BorderSide(color: primaryGreen, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
          textStyle: labelMedium.copyWith(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: bodyMedium.copyWith(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
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

  // Dark Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: lightGreen,
        surface: Color(0xFF1E1E1E),
        error: errorRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: Color(0xFFE0E0E0),
        onError: white,
      ),
      textTheme: TextTheme(
        displayLarge: darkHeadlineLarge,
        displayMedium: darkHeadlineMedium,
        displaySmall: darkHeadlineSmall,
        headlineLarge: darkHeadlineLarge,
        headlineMedium: darkHeadlineMedium,
        headlineSmall: darkHeadlineSmall,
        bodyLarge: darkBodyLarge,
        bodyMedium: darkBodyMedium,
        bodySmall: darkBodySmall,
        labelLarge: darkLabelLarge,
        labelMedium: darkLabelMedium,
        labelSmall: darkLabelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 4,
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
          foregroundColor: Colors.white,
          side: const BorderSide(color: primaryGreen, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryGreen),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
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
        labelStyle: bodyMedium.copyWith(color: Colors.white70),
        hintStyle: bodyMedium.copyWith(color: Colors.white60),
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
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
      ),
    );
  }
}
