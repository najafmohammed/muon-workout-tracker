import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/models/routine_session.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';

class RoutineSessionNotifier extends StateNotifier<RoutineSession?> {
  final Ref ref;
  Timer? _timer; // Timer instance to update elapsed time

  RoutineSessionNotifier(this.ref) : super(null);

  // Start a new session with a given routine and exercises
  Future<void> start() async {
    final userSettings = ref.read(userSettingsProvider);
    if (userSettings == null) {
      print('No current split found');
      return;
    }

    final currentSplit = await userSettings.currentSplit;
    final split = ref.read(splitProvider);
    final routineProv = ref.read(routineProvider);
    final exerciseProv = ref.read(exerciseProvider);

    final routine = await split
        .getOrderedRoutinesFromSplit(currentSplit.value as Split)
        .then((value) => value[userSettings.currentRoutineIndex]);
    final exercises = await routineProv.getOrderedExercisesFromRoutine(routine);

    // Load all exercises for the routine
    // final latestSets = await exerciseProv
    //     .getLatestSetsForExercise(exercises[state?.currentExerciseIndex ?? 0]);

    final Map<Exercise, List<Map<String, dynamic>>> exerciseSetsMap = {};

    for (Exercise exercise in exercises) {
      final List<Map<String, dynamic>> setsWithCompletion = [];

      // Assuming the exercise contains sets, we iterate over them
      for (ExerciseSet set
          in await exerciseProv.getLatestSetsForExercise(exercise)) {
        setsWithCompletion.add({
          'set': set,
          'completed': false,
        });
      }

      // Add the exercise and its sets with completion status to the map
      exerciseSetsMap[exercise] = setsWithCompletion;
    }
    state = RoutineSession(
      routine: routine,
      startTime: DateTime.now(),
      isRunning: true,
      isActive: true,
      exercises: exercises,
      exerciseSets: exerciseSetsMap,
      currentExerciseIndex: 0, // Start with the first exercise
    );

    // Start the timer to update the elapsed time
    _startTimer();
  }

  // Start the timer to update the state every second
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Update the state every second to keep track of elapsed time
      if (state?.isRunning == true) {
        state = state!.copyWith();
      }
    });
  }

  // Stop the timer when the session is paused or ends
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Toggle between pause and resume states
  void togglePause() {
    if (state != null) {
      if (state!.isRunning) {
        // Pausing the session
        state = state!.copyWith(
          isRunning: false,
          pausedTime: DateTime.now(),
        );
        print('Session paused');
        _stopTimer(); // Stop the timer when paused
      } else {
        // Resuming the session
        state = state!.copyWith(
          isRunning: true,
          startTime: state!.startTime
              .add(DateTime.now().difference(state!.pausedTime!)),
          pausedTime: null,
        );
        print('Session resumed');
        _startTimer(); // Restart the timer when resumed
      }
    }
  }

  // Move to the next exercise
  Future<void> nextExercise() async {
    if (state != null &&
        state!.currentExerciseIndex < state!.exercises.length - 1) {
      final newIndex = state!.currentExerciseIndex + 1;

      // Update state with the new exercise and its sets
      state = state!.copyWith(
        currentExerciseIndex: newIndex,
      );
    }
  }

  // Move to the previous exercise
  Future<void> previousExercise() async {
    if (state != null && state!.currentExerciseIndex > 0) {
      final newIndex = state!.currentExerciseIndex - 1;

      // Update state with the new exercise and its sets
      state = state!.copyWith(
        currentExerciseIndex: newIndex,
      );

      print('Moved to exercise $newIndex');
    }
  }

  void updateSetCompletion(int setIndex, bool isCompleted) {
    if (state == null) return;

    final exercise = state!.exercises[state!.currentExerciseIndex];

    // Get the current list of sets for the exercise
    final List<Map<String, dynamic>> exerciseSets =
        state!.exerciseSets[exercise]!;

    // Update the specific set's completion status
    exerciseSets[setIndex]['completed'] = isCompleted;

    // Update the state with the modified sets
    state = state!.copyWith(
      exerciseSets: {
        ...state!.exerciseSets,
        exercise: exerciseSets,
      },
    );
  }

  // Mark the session as finished
  bool finishSession() {
    if (state != null) {
      bool areAllSetsCompleted() {
        if (state == null) {
          return false;
        }
        // Iterate through each exercise and its sets
        for (var exerciseSets in state!.exerciseSets.values) {
          // Check if any set in the current exercise is not completed
          bool allCompletedForExercise =
              exerciseSets.every((setMap) => setMap['completed'] == true);

          if (!allCompletedForExercise) {
            return false; // If any exercise has an incomplete set, return false
          }
        }
        // If we reach here, all sets for all exercises are completed
        return true;
      }

      if (areAllSetsCompleted()) {
        state = state!.copyWith(isActive: false, isRunning: false);
        _stopTimer(); // Stop the timer when session finishes
        state = null; // Clear the session after finishing
        return true;
      }
    }
    return false;
  }

  // Discard the session
  void discardSession() {
    print('Session discarded');
    _stopTimer(); // Stop the timer when session is discarded
    state = null; // Clear the session
  }

  // Helper to get the current exercise
  Exercise? get currentExercise {
    if (state != null &&
        state!.currentExerciseIndex < state!.exercises.length) {
      return state!.exercises[state!.currentExerciseIndex];
    }
    return null;
  }

  Map<Exercise, List<Map<String, dynamic>>> get exerciseSets {
    if (state != null) {
      return state!.exerciseSets;
    }
    return <Exercise, List<Map<String, dynamic>>>{}; // Return an empty map
  }

  // Get elapsed time
  Duration get elapsedTime {
    if (state == null) return Duration.zero;
    if (!state!.isRunning && state!.pausedTime != null) {
      return state!.pausedTime!.difference(state!.startTime);
    }
    return DateTime.now().difference(state!.startTime);
  }

  @override
  void dispose() {
    _stopTimer(); // Ensure timer is stopped when the notifier is disposed
    super.dispose();
  }
}

// Provider for RoutineSessionNotifier
final routineSessionProvider =
    StateNotifierProvider<RoutineSessionNotifier, RoutineSession?>((ref) {
  return RoutineSessionNotifier(ref);
});
