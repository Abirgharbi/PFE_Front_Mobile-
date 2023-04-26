import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

import './colors.dart';

class TTtextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayMedium: GoogleFonts.montserrat(
        color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.montserrat(
        color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
    displaySmall: GoogleFonts.abrilFatface(color: Colors.black, fontSize: 26),
    titleSmall: GoogleFonts.poppins(
      color: Colors.black54,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      fontSize: 14.5,
      letterSpacing: 0.15,
      color: MyColors.heading6,
    ),
    bodyLarge: TextStyle(
      color: MyColors.textColor1,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      fontSize: 11,
      color: MyColors.captionColor,
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
      displayMedium: GoogleFonts.montserrat(color: Colors.white70),
      titleSmall: GoogleFonts.poppins(
        color: Colors.white60,
        fontSize: 24,
      ));
}
