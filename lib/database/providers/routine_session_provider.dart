import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine_session.dart';

// StateNotifier to manage RoutineSession state and behavior
class RoutineSessionNotifier extends StateNotifier<RoutineSession?> {
  RoutineSessionNotifier() : super(null);

  // Start a new session with a given routine
  void start() {
    state = RoutineSession(
        startTime: DateTime.now(), isRunning: true, isActive: true);
  }

  // Toggle between pause and resume states by only updating necessary fields

  void togglePause() {
    if (state != null) {
      if (state!.isRunning) {
        state = state!.copyWith(
          isRunning: false,
          pausedTime: DateTime.now(),
        );
      } else {
        state = state!.copyWith(
          isRunning: true,
          startTime: state!.startTime
              .add(DateTime.now().difference(state!.pausedTime!)),
          pausedTime: null,
        );
      }
    }
  }

  // Mark the session as finished and clear it
  void finish() {
    state = state!.copyWith(isActive: false, isRunning: false);
    state = null; // Clear the session
  }

  // Discard the session and clear the state
  void discard() {
    state = null; // Clear the session
  }

  // Helper to get the elapsed time
  Duration get elapsedTime => state?.elapsedTime ?? Duration.zero;
}

// Provider for RoutineSessionNotifier
final routineSessionProvider =
    StateNotifierProvider<RoutineSessionNotifier, RoutineSession?>((ref) {
  return RoutineSessionNotifier();
});
