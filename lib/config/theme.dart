import 'package:flutter/material.dart';

class AppTheme {
  // Define your colors
  static const Color backgroundColor = Colors.black; // Black background
  static const Color primaryColor = Color(0xFF00E6E6); // Provided primary color
  static const Color foregroundColor = Colors.white; // White text

  static ThemeData darkTheme(Color seedColor, bool dark) {
    return ThemeData(
      // Using ColorScheme generated from the seed color
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: dark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor:
          dark ? backgroundColor : foregroundColor, // Set the background color
      textTheme: TextTheme(
        bodyMedium: TextStyle(
            color: dark
                ? foregroundColor
                : backgroundColor), // White text for body
      ),
    );
  }
}
