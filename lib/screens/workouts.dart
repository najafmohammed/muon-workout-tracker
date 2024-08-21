import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/screens/exercise_manager.dart';
import 'package:muon_workout_tracker/screens/routine_manager.dart';
import 'package:muon_workout_tracker/widgets/add_workout_card.dart';
import 'package:muon_workout_tracker/widgets/workouts_info_card.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkoutInfoCard(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Customise your Workouts',
                style: AppTextStyle.large,
              ),
            ),
            AddWorkoutCard(
              label: 'Exercises',
              widget: ExerciseManager(),
            ),
            AddWorkoutCard(
              label: 'Routines',
              widget: RoutineManager(),
            ),
            AddWorkoutCard(label: 'Splits', widget: RoutineManager()),
          ],
        ));
  }
}
