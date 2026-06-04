import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Montserrat",
    scaffoldBackgroundColor: const Color(0xffF8F9FA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xff9F8383),
      secondary: Color(0xff574964),
      surface: Colors.white,
    ),
    cardColor: Colors.white,
    dividerColor: const Color(0xffEEEEEE),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF8F9FA),
      foregroundColor: Color(0xff574964),
      elevation: 0,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Montserrat",
    scaffoldBackgroundColor: const Color(0xff1A1A2E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff9F8383),
      secondary: Color(0xffC9A8A8),
      surface: Color(0xff2A2A3E),
    ),
    cardColor: const Color(0xff2A2A3E),
    dividerColor: const Color(0xff3A3A4E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1A1A2E),
      foregroundColor: Color(0xffF8F9FA),
      elevation: 0,
    ),
  );
}
