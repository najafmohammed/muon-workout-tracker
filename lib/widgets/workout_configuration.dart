import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/screens/exercise_form.dart';
import 'package:muon_workout_tracker/screens/routine_form.dart';
import 'package:muon_workout_tracker/screens/select_current_split.dart';
import 'package:muon_workout_tracker/screens/split_form.dart';

class WorkoutConfiguration extends ConsumerWidget {
  final String? error;

  WorkoutConfiguration({super.key, this.error});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExerciseStep(ref, context),
          _buildRoutineStep(ref, context),
          _buildSplitStep(ref, context),
        ],
      ),
    );
  }

  // Step 1: Exercise Step
  Widget _buildExerciseStep(WidgetRef ref, BuildContext context) {
    return StreamBuilder(
      stream: ref
          .watch(exerciseProvider)
          .getAllExercisesFiltered(nameFilter: ""), // Fetch all exercises
      builder: (context, snapshot) {
        return _buildStepFromSnapshot(
          title: 'Exercise',
          snapshot: snapshot,
          onCreatePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExerciseForm()),
            );
          },
        );
      },
    );
  }

  // Step 2: Routine Step
  Widget _buildRoutineStep(WidgetRef ref, BuildContext context) {
    return StreamBuilder(
      stream: ref
          .watch(routineProvider)
          .getAllRoutinesFiltered(nameFilter: ""), // Fetch all routines
      builder: (context, snapshot) {
        return _buildStepFromSnapshot(
          title: 'Routine',
          snapshot: snapshot,
          onCreatePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RoutineForm()),
            );
          },
        );
      },
    );
  }

  // Step 3: Split Step
  Widget _buildSplitStep(WidgetRef ref, BuildContext context) {
    return StreamBuilder(
      stream: ref
          .watch(splitProvider)
          .getAllSplitsFiltered(nameFilter: ""), // Fetch all splits
      builder: (context, snapshot) {
        print(error);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStepFromSnapshot(
              title: 'Split',
              snapshot: snapshot,
              onCreatePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SplitForm()),
                );
              },
            ),
            if (error != null)
              ListTile(
                title: const Text(
                  " Current split has no routines",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectCurrentSplit()));
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper function to build steps based on snapshot
  Widget _buildStepFromSnapshot({
    required String title,
    required AsyncSnapshot snapshot,
    required VoidCallback onCreatePressed,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return _buildStep(
        title: title,
        count: 0,
        onCreatePressed: onCreatePressed,
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildStep(
        title: title,
        count: 0,
        onCreatePressed: onCreatePressed,
      );
    } else {
      return _buildStep(
        title: title,
        count: snapshot.data!.length,
        onCreatePressed: onCreatePressed,
      );
    }
  }
}

Widget _buildStep({
  required String title,
  required int count,
  required VoidCallback onCreatePressed,
}) {
  bool isConfigured = count >= 1;
  return ListTile(
    title: Text(
      isConfigured ? '$count $title(s) found!' : 'No $title(s) found!',
      style: TextStyle(
        color: isConfigured ? Colors.green : Colors.red,
        fontSize: 16,
      ),
    ),
    leading: Icon(
      isConfigured ? Icons.check_circle : Icons.cancel,
      color: isConfigured ? Colors.green : Colors.red,
    ),
    trailing: IconButton(
      icon: const Icon(Icons.add),
      onPressed: onCreatePressed,
    ),
  );
}
