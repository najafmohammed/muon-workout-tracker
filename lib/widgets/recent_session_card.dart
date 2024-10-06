import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

class RecentSessionCard extends ConsumerWidget {
  const RecentSessionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CardWrapper(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text('Recent Session', style: AppTextStyle.large),

            SizedBox(height: 10), // Space between title and content

            // Content row with icons and text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Routine Info
                Row(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.purple, size: 30),
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(
                      'Legs',
                      style: AppTextStyle.medium,
                    ),
                  ],
                ),

                // Date Info
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue, size: 30),
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(
                      'Oct 2, 2024',
                      style: AppTextStyle.medium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
