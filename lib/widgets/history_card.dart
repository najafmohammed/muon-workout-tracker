import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

class HistoryCard extends ConsumerWidget {
  const HistoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardWrapper(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('History', style: AppTextStyle.large),
            Icon(Icons.arrow_forward, size: 30, color: Colors.blue),
          ],
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {
            // Navigate to monthly streak detailed screen
          },
          child: const Text('View Workouts of the Month'),
        ),
      ],
    );
  }
}
