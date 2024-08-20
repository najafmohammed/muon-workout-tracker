import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/routine_session.dart';

final routineSessionProvider =
    StateNotifierProvider<RoutineSessionNotifier, RoutineSession?>((ref) {
  return RoutineSessionNotifier();
});

class RoutineSessionNotifier extends StateNotifier<RoutineSession?> {
  RoutineSessionNotifier() : super(null);

  bool get isRunning => state?.isRunning ?? false;

  void start(Routine routine) {
    state = RoutineSession(routine: routine, startTime: DateTime.now())
      ..start();
  }

  void togglePause() {
    state?.togglePause();
  }

  void completeExercise() {
    state?.finish();
  }

  void finish() {
    state?.finish();
    state = null; // Clear the session after finishing
  }

  void discard() {
    state?.discard();
    state = null;
  }
}
