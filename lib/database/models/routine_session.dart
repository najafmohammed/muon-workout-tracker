import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

class RoutineSession {
  DateTime startTime;
  DateTime? pausedTime;
  bool isRunning;
  bool isActive;
  double progress;
  List<Exercise> exercises; // List of exercises in the routine
  Routine routine;
  int currentExerciseIndex;
  final Map<Exercise, List<Map<String, dynamic>>> exerciseSets;
  final Map<int, bool>
      exerciseCompletionStatus; // Store completed status of each exercise

  RoutineSession(
      {required this.startTime,
      this.pausedTime,
      this.isRunning = false,
      this.isActive = false,
      required this.exercises, // Initialize with the list of exercises
      this.currentExerciseIndex = 0,
      this.progress = 0.0,
      required this.exerciseSets,
      this.exerciseCompletionStatus = const {},
      required this.routine});

  // CopyWith method to create a copy with modified values
  RoutineSession copyWith(
      {DateTime? startTime,
      DateTime? pausedTime,
      bool? isRunning,
      bool? isActive,
      double? progress,
      List<Exercise>? exercises, // Update exercises if needed
      int? currentExerciseIndex, // Update current exercise index
      Map<Exercise, List<Map<String, dynamic>>>? exerciseSets,
      Map<int, bool>? exerciseCompletionStatus,
      Routine? routine}) {
    return RoutineSession(
      routine: routine ?? this.routine,
      startTime: startTime ?? this.startTime,
      pausedTime: pausedTime ?? this.pausedTime,
      isRunning: isRunning ?? this.isRunning,
      isActive: isActive ?? this.isActive,
      exercises: exercises ?? this.exercises, // Preserve or update exercises
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      exerciseSets: exerciseSets ?? this.exerciseSets,
      progress: progress ?? this.progress,
      exerciseCompletionStatus:
          exerciseCompletionStatus ?? this.exerciseCompletionStatus,
    );
  }
}
