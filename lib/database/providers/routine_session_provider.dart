import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/models/routine_session.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/models/user_settings.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/database/providers/session_entry_provider.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/timer_provider.dart';
import 'package:muon_workout_tracker/database/providers/total_stats_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';

class RoutineSessionNotifier extends StateNotifier<RoutineSession?> {
  final Ref ref;

  RoutineSessionNotifier(this.ref) : super(null);
  int currentSetIndex = 0;

  // Start a new session with a given routine and exercises
// Start a new session with a given routine and exercises
  Future<void> start() async {
    final userSettings = ref.read(userSettingsProvider);
    if (userSettings == null) {
      print('No current split found');
      return;
    }
    // Reset index
    currentSetIndex = 0;
    final currentSplit = userSettings.currentSplit;
    final split = ref.read(splitProvider);
    final routineProv = ref.read(routineProvider);
    final exerciseProv = ref.read(exerciseProvider);

    final routine = await split
        .getOrderedRoutinesFromSplit(currentSplit.value as Split)
        .then((value) => value[userSettings.currentRoutineIndex]);
    final exercises = await routineProv.getOrderedExercisesFromRoutine(routine);

    final Map<Exercise, List<Map<String, dynamic>>> exerciseSetsMap = {};

    for (Exercise exercise in exercises) {
      final List<Map<String, dynamic>> setsWithCompletion = [];

      for (ExerciseSet set
          in await exerciseProv.getLatestSetsForExercise(exercise)) {
        setsWithCompletion.add({
          'set': set,
          'completed': false,
        });
      }

      exerciseSetsMap[exercise] = setsWithCompletion;
    }

    state = RoutineSession(
      routine: routine,
      startTime: DateTime.now(),
      isRunning: true,
      isActive: true,
      exercises: exercises,
      exerciseSets: exerciseSetsMap,
      currentExerciseIndex: 0,
    );

    // Start the timer using the TimerProvider
    ref.read(timerProvider.notifier).start();
  }

  // Toggle between pause and resume states
  void togglePause() {
    if (state != null) {
      if (state!.isRunning) {
        state = state!.copyWith(
          isRunning: false,
          pausedTime: DateTime.now(),
        );
        ref.read(timerProvider.notifier).pause();
      } else {
        state = state!.copyWith(
          isRunning: true,
          startTime: state!.startTime
              .add(DateTime.now().difference(state!.pausedTime!)),
          pausedTime: null,
        );
        ref.read(timerProvider.notifier).resume();
      }
    }
  }

  // Move to the next exercise
  Future<void> nextExercise() async {
    if (state != null &&
        state!.currentExerciseIndex < state!.exercises.length - 1) {
      final newIndex = state!.currentExerciseIndex + 1;
      //reset index for next set
      currentSetIndex = 0;

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
      //reset index for next set
      currentSetIndex = 0;

      // Update state with the new exercise and its sets
      state = state!.copyWith(
        currentExerciseIndex: newIndex,
      );

      print('Moved to exercise $newIndex');
    }
  }

  void updateSetCompletion(
      int setIndex, bool isCompleted, ExerciseSet exerciseSet) {
    if (state == null) return;

    final exercise = state!.exercises[state!.currentExerciseIndex];
    currentSetIndex++;

    // Get the current list of sets for the exercise
    final List<Map<String, dynamic>> exerciseSets =
        state!.exerciseSets[exercise]!;

    // Update the specific set's completion status
    exerciseSets[setIndex]['completed'] = isCompleted;
    exerciseSets[setIndex]['set'] = exerciseSet;

    // Recalculate progress
    double newProgress = _calculateProgress();

    // Update the state with the modified sets and new progress
    state = state!.copyWith(
      exerciseSets: {
        ...state!.exerciseSets,
        exercise: exerciseSets,
      },
      progress: newProgress, // Set the new progress
    );
  }

  double _calculateProgress() {
    if (state == null) return 0.0;

    int totalSets = 0;
    int completedSets = 0;

    // Iterate through all exercises and their sets
    state!.exerciseSets.forEach((exercise, sets) {
      totalSets += sets.length; // Count total sets
      completedSets += sets
          .where((setMap) => setMap['completed'] == true)
          .length; // Count completed sets
    });

    if (totalSets == 0) return 0.0; // Avoid division by zero
    return completedSets / totalSets; // Return the progress as a ratio
  }

  bool finishSession() {
    if (state != null) {
      // Function to check if all sets are completed
      bool areAllSetsCompleted() {
        if (state == null) {
          return false;
        }
        for (var exerciseSets in state!.exerciseSets.values) {
          bool allCompletedForExercise =
              exerciseSets.every((setMap) => setMap['completed'] == true);
          if (!allCompletedForExercise) {
            return false; // Incomplete set found
          }
        }
        return true; // All sets completed
      }

      if (areAllSetsCompleted()) {
        state = state!.copyWith(isActive: false, isRunning: false);

        final sessionEntryProv = ref.read(sessionEntryProvider);
        final userSettingsNotifier = ref.read(userSettingsProvider.notifier);
        final userSettingsProv = ref.read(userSettingsProvider);
        final exerciseProv = ref.read(exerciseProvider);

        // Get the elapsed time from the session
        Duration sessionDuration = ref.read(timerProvider);

        // Convert duration to seconds
        int durationSeconds = sessionDuration.inSeconds;
        ref.read(timerProvider.notifier).stop(); // Stop the session timer

        // Create a new routine session to save
        SessionEntry sessionEntry = SessionEntry()
          ..date = DateTime.now()
          ..volume =
              _calculateTotalVolume() // Implement this function to sum total volume
          ..duration = durationSeconds;

        // Add exercise histories to the session
        for (var exercise in state!.exerciseSets.keys) {
          ExerciseHistory exerciseHistory = ExerciseHistory()
            ..date = DateTime.now()
            ..sets = _convertToExerciseHistorySets(state!.exerciseSets[
                exercise]!); // Convert current sets to ExerciseSet

          sessionEntry.workouts.add(exerciseHistory); // Link to routine
          exerciseProv.addExercise(exercise, exerciseHistory);
        }

        final UserSettings userSettings = UserSettings();

        // Save the routine session using the repository
        sessionEntryProv.addSessionEntry(sessionEntry);

        // Call the new function to update total stats
        _updateTotalStats(sessionEntry);

        // Update User Settings - Update routine index and check split completion
        int routineCount =
            userSettingsProv!.currentSplit.value?.routines.length ?? 0;
        // Mark split as completed for the day
        userSettings.isSplitCompletedToday = true;
        userSettingsNotifier.markSplitAsCompleted();
        userSettingsNotifier.updateCurrentRoutineIndex(
            (userSettingsProv.currentRoutineIndex + 1) % routineCount);

        return true;
      }
    }
    return false;
  }

  Future<void> _updateTotalStats(SessionEntry sessionEntry) async {
    final totalStatsRepo = ref.read(totalStatsRepositoryProvider.notifier);
    if (state != null) {
      int totalSets = 0;
      state!.exerciseSets.forEach((exercise, sets) {
        totalSets += sets.length; // Count total sets
      });
      await totalStatsRepo.addSessionStats(
          sessionEntry.duration, totalSets, sessionEntry.volume);
    }
  }

  double _calculateTotalVolume() {
    double totalVolume = 0;
    if (state != null) {
      for (var exerciseSets in state!.exerciseSets.values) {
        var set = exerciseSets[0]["set"] as ExerciseSet;
        totalVolume += (set.weight) * (set.reps);
      }
    }
    return totalVolume;
  }

// Helper function to convert current sets to ExerciseHistory sets
  List<ExerciseSet> _convertToExerciseHistorySets(
      List<Map<String, dynamic>> sets) {
    return sets.map((setMap) {
      ExerciseSet exerciseSet = setMap['set'] as ExerciseSet;
      return ExerciseSet()
        ..setNumber = exerciseSet.setNumber
        ..weight = exerciseSet.weight
        ..reps = exerciseSet.reps;
    }).toList();
  }

  // Discard the session
  void discardSession() {
    print('Session discarded');
    ref
        .read(timerProvider.notifier)
        .stop(); // Stop the timer when session is discarded
    state = null; // Clear the session
  }

  @override
  void dispose() {
    ref.read(timerProvider.notifier).stop(); // Ensure timer is stopped
    super.dispose();
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

//get the next set
  Map<String, dynamic>? get currentSet {
    if (state == null) return null;

    final exercise = state!.exercises[state!.currentExerciseIndex];
    final sets = state!.exerciseSets[exercise]!;

    if (currentSetIndex < sets.length) {
      return sets[currentSetIndex]; // Return the current set
    }

    return null; // No more sets available
  }
}

// Provider for RoutineSessionNotifier
final routineSessionProvider =
    StateNotifierProvider<RoutineSessionNotifier, RoutineSession?>((ref) {
  return RoutineSessionNotifier(ref);
});
