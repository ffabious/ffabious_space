import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static const double primaryHue = 187;
  static const double complementaryHue = 26;

  static Color backgroundColor = HSLColor.fromAHSL(
    1.0,
    primaryHue,
    0.8,
    0.98,
  ).toColor();

  static Color cardColor = HSLColor.fromAHSL(
    1.0,
    primaryHue,
    0.8,
    0.95,
  ).toColor();

  static Color textColor = HSLColor.fromAHSL(
    1.0,
    primaryHue,
    0.88,
    0.03,
  ).toColor();

  static Color headerColor = HSLColor.fromAHSL(
    1.0,
    primaryHue,
    0.8,
    0.92,
  ).toColor();

  static Color accentColor = HSLColor.fromAHSL(
    1.0,
    complementaryHue,
    1.0,
    0.65,
  ).toColor();

  static TextTheme textTheme = TextTheme(
    displaySmall: TextStyle(
      color: textColor,
      fontSize: 42,
      fontWeight: FontWeight.w200,
      fontFamily: GoogleFonts.nunito().fontFamily,
      height: 1,
    ),
    displayMedium: TextStyle(
      color: textColor,
      fontSize: 48,
      fontWeight: FontWeight.w400,
      letterSpacing: 1,
      fontFamily: GoogleFonts.nunito().fontFamily,
      height: 1.2,
    ),
    displayLarge: TextStyle(
      color: textColor,
      fontSize: 72,
      fontWeight: FontWeight.w600,
      letterSpacing: 2,
      fontFamily: GoogleFonts.caveat().fontFamily,
      height: 1,
    ),
    bodyMedium: TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: GoogleFonts.nunito().fontFamily,
    ),
  );
}
