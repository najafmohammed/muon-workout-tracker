import 'package:muon_workout_tracker/database/models/routine.dart';

class RoutineSession {
  DateTime startTime;
  DateTime? pausedTime;
  bool isRunning;
  bool isActive;

  RoutineSession(
      {required this.startTime,
      this.pausedTime,
      this.isRunning = false,
      this.isActive = false});

  // CopyWith method to create a copy with modified values
  RoutineSession copyWith(
      {Routine? routine,
      DateTime? startTime,
      DateTime? pausedTime,
      bool? isRunning,
      bool? isActive}) {
    return RoutineSession(
      startTime: startTime ?? this.startTime,
      pausedTime: pausedTime ?? this.pausedTime,
      isRunning: isRunning ?? this.isRunning,
      isActive: isActive ?? this.isActive,
    );
  }

  // Calculating elapsed time based on session state
  Duration get elapsedTime {
    if (isRunning) {
      return DateTime.now().difference(startTime);
    } else if (pausedTime != null) {
      return pausedTime!.difference(startTime);
    }
    return Duration.zero;
  }
}
