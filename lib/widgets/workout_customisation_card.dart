import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class WorkoutCustomisationCard extends StatefulWidget {
  const WorkoutCustomisationCard({super.key});

  @override
  State<WorkoutCustomisationCard> createState() =>
      _WorkoutCustomisationCardState();
}

class _WorkoutCustomisationCardState extends State<WorkoutCustomisationCard> {
  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text(
            "Customise Workouts",
            style: AppTextStyle.large,
          ),
        ),
      ],
    );
  }
}
