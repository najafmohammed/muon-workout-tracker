import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

class RoutineSession {
  RoutineSession({
    required this.routine,
    required this.startTime,
  }) {
    // Initialize the history map for each exercise in the routine
    for (final exercise in routine.exercises) {
      exerciseHistories[exercise] = ExerciseHistory()
        ..date = startTime
        ..sets = [];
    }
  }

  final Routine routine;
  final DateTime startTime;
  DateTime? pausedTime;
  bool isRunning = false;

  // Map to track exercise history during the session
  final Map<Exercise, ExerciseHistory> exerciseHistories = {};

  Duration get elapsedTime {
    if (isRunning) {
      return DateTime.now().difference(startTime);
    } else if (pausedTime != null) {
      return pausedTime!.difference(startTime);
    }
    return Duration.zero;
  }

  void start() {
    isRunning = true;
    if (pausedTime != null) {
      startTime.add(DateTime.now().difference(pausedTime!));
    }
  }

  void pause() {
    isRunning = false;
    pausedTime = DateTime.now();
  }

  void discard() {
    // Reset the session
    isRunning = false;
    pausedTime = null;
    exerciseHistories.clear(); // Clear the history
  }

  void finish() {
    isRunning = false;
    // This method will save the collected history into the database
    // Logic for this will be handled in the provider/repository
  }

  void addSet(Exercise exercise, ExerciseSet set) {
    // Add the set to the history of the specified exercise
    exerciseHistories[exercise]?.sets.add(set);
  }

  ExerciseHistory? getHistoryForExercise(Exercise exercise) {
    return exerciseHistories[exercise];
  }
}
