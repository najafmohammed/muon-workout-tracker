import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/widgets/home_workout_card.dart';
import 'package:muon_workout_tracker/widgets/streak_card.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Muon Workout Tracker'),
          centerTitle: true,
        ),
        body: const Column(children: [
          StreakCard(),
          HomeWorkoutCard(),
        ]));
  }
}
