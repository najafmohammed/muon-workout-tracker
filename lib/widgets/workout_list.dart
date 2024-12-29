import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

class WorkoutList extends StatelessWidget {
  final SessionEntry sessionEntry;

  const WorkoutList({
    Key? key,
    required this.sessionEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the loaded routines directly from the session entry
    final routines = sessionEntry.routines.toList();
    final exerciseHistory = sessionEntry.workouts.toList();
    if (routines.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final routine = routines[index];
            return _buildRoutineTile(routine, exerciseHistory);
          },
          childCount: routines.length,
        ),
      );
    } else {
      return const SliverFillRemaining(
          child: Center(child: Text('No routines found for this session')));
    }
  }

  Widget _buildRoutineTile(
      Routine routine, List<ExerciseHistory> exerciseHistory) {
    // Access the exercises directly from the routine
    final exercises = routine.exercises.toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const CircleAvatar(child: Icon(Icons.fitness_center)),
              const SizedBox(
                width: 20,
              ),
              Text(
                routine.name, // Display routine name
                style: AppTextStyle.large,
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (exercises.isNotEmpty)
              ...exercises
                  .map((exercise) =>
                      _buildExpandableExercise(exercise, exerciseHistory))
                  .toList()
            else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No exercises found'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableExercise(
      Exercise exercise, List<ExerciseHistory> exerciseHistory) {
    // Access only the workout history related to this exercise for the session entry

    return ExpansionTile(
      title: Text(exercise.name),
      leading: const Icon(Icons.play_arrow), // Icon for the exercise
      children: [
        // Display sets for this exercise
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: exerciseHistory.map((workout) {
              // Assuming each workout has a property that contains a list of sets
              final sets =
                  workout.sets; // Replace with the actual property if different

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(sets.length, (index) {
                  final set = sets[index];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1)
                          .toString()), // Display the index starting from 1
                    ),
                    title: Text(
                      'Reps: ${set.reps}, ', // Display the reps and weight
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      'Weight: ${set.weight} kg', // Display the reps and weight
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
