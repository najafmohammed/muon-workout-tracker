import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';

class ExercisePlaylist extends ConsumerWidget {
  const ExercisePlaylist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineSession = ref.watch(routineSessionProvider);
    final exercises = routineSession?.exercises ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise List'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text(exercise.name), // Assuming Exercise has a name field
            subtitle: Text('group: ${exercise.muscleGroup}'),
            onTap: () {
              // Optionally handle tap, e.g., show exercise details or start this exercise
            },
          );
        },
      ),
    );
  }
}
