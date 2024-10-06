import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

class TotalStatsCard extends ConsumerWidget {
  const TotalStatsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CardWrapper(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.timer, size: 40, color: Colors.blue),
                Text(
                  '2h 30m',
                  style: AppTextStyle.large,
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                    Text('5%', style: TextStyle(color: Colors.green)),
                  ],
                ),
                SizedBox(height: 4),
                Text('Time', style: AppTextStyle.small),
              ],
            ),
            Column(
              children: [
                Icon(Icons.fitness_center, size: 40, color: Colors.red),
                Text(
                  '5',
                  style: AppTextStyle.large,
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                    Text('2%', style: TextStyle(color: Colors.red)),
                  ],
                ),
                SizedBox(height: 4),
                Text('Workouts', style: AppTextStyle.small),
              ],
            ),
            Column(
              children: [
                Icon(Icons.scale, size: 40, color: Colors.orange),
                Text(
                  '10 kg',
                  style: AppTextStyle.large,
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                    Text('10%', style: TextStyle(color: Colors.green)),
                  ],
                ),
                SizedBox(height: 4),
                Text('Volume', style: AppTextStyle.small),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
