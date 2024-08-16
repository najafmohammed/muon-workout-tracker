import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/widgets/home_workout_card.dart';
import 'package:muon_workout_tracker/widgets/streak_card.dart';
import 'package:muon_workout_tracker/widgets/workout_customisation_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Muon Workout Tracker'),
          centerTitle: true,
        ),
        body: const Column(
          children: [
            HomeWorkoutCard(),
            StreakCard(),
            WorkoutCustomisationCard()
          ],
        ));
  }
}
