import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/dimensions.dart';

class AppTextStyle {
  static const TextStyle large =
      TextStyle(fontSize: Dimensions.fontLarge, fontWeight: FontWeight.w700);
  static const TextStyle medium = TextStyle(fontSize: Dimensions.fontMedium);
  static const TextStyle small = TextStyle(fontSize: Dimensions.fontSmall);
  static const TextStyle info = TextStyle(fontSize: Dimensions.info);
}

class AppButtonTextStyle {
  static const TextStyle medium = TextStyle(fontSize: Dimensions.buttonText);
}
