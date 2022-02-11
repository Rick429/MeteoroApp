import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeteoroStyle {
  // Colors
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blueColor = Color(0xFF4E6CD9);
  static const Color blueLightColor = Color(0xFF75B7F4);
  static const Color brownColor = Color(0xFF782A1D);
  static const Color orangeColor = Color(0xFFBE7437);
  static const Color greyColor = Color(0xFFC4C4C4);


  // Margins, Paddins, CardProperties
  static const double bodyPadding = 11.0;
  static const double cardElevation = 1.0;
  static const double cardBorderRadius = 40;
  static const double normalPadding = 14.0;
  

  // Font sizes, TextStyles

  static const double textSizeSmall = 16.0;
  static const double textSizeMedium = 24.0;
  static const double textSizeWeather = 36.0;
  static const double textSizetitle = 40.0;
  static const double textSizeLarge = 100.0;

  static TextStyle textDefault(double fSize) => GoogleFonts.getFont(
    'Roboto',
    color: whiteColor,
    fontWeight: FontWeight.w600,
    fontSize: fSize,
  );
  
}