import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

Widget buildStatColumn(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 12.0, vertical: 8.0), // Add padding around the column
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Center content vertically
      children: [
        // Icon with value aligned centrally
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green[300], size: 30),
            const SizedBox(width: 10), // Spacing between icon and text
            Text(value, style: AppTextStyle.medium),
          ],
        ),
        const SizedBox(height: 8), // Spacing between value and title
        // Title centered below
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.info.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
