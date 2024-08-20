import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class WorkoutInfoCard extends StatelessWidget {
  const WorkoutInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardWrapper(children: [
      Row(
        children: [
          Text(
            'Current Split',
            style: AppTextStyle.large,
          ),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        'Push Pull Leg',
        style: AppTextStyle.medium,
      )
    ]);
  }
}
