import 'package:flutter/material.dart';

class AppTheme {
  // Define your colors
  static const Color backgroundColor = Colors.black; // Black background
  static const Color primaryColor = Color(0xFF00E6E6); // Provided primary color
  static const Color foregroundColor = Colors.white; // White text

  static ThemeData get darkTheme {
    return ThemeData(
      // brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 120, 231, 216),
        brightness: Brightness.dark,
      ),
    );
  }
}
