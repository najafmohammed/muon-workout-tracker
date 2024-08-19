import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/routine_session.dart';

final routineSessionProvider =
    StateNotifierProvider<RoutineSessionNotifier, RoutineSession?>((ref) {
  return RoutineSessionNotifier();
});

class RoutineSessionNotifier extends StateNotifier<RoutineSession?> {
  RoutineSessionNotifier() : super(null);

  void startSession(Routine routine) {
    state = RoutineSession(routine: routine, startTime: DateTime.now())
      ..start();
  }

  void togglePause() {
    state?.togglePause();
  }

  void completeExercise() {
    state?.finish();
  }

  void finishSession() {
    state?.finish();
    state = null; // Clear the session after finishing
  }

  void discardSession() {
    state?.discard();
    state = null;
  }
}
