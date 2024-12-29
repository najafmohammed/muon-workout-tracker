import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

class MuscleGroupSplit extends StatelessWidget {
  final Routine routine;

  const MuscleGroupSplit({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Gather muscle group data for the routine
    Map<String, int> muscleGroupCount = {};
    routine.exercises.forEach((exercise) {
      final muscleGroup = exercise.muscleGroup.toString().split('.').last;
      muscleGroupCount[muscleGroup] = (muscleGroupCount[muscleGroup] ?? 0) + 1;
    });

    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Muscle Group Split',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...muscleGroupCount.entries.map((entry) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.fitness_center),
                  title: Text(entry.key),
                  trailing: Text('${entry.value} exercises'),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
