import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';

class RoutineSession {
  RoutineSession({
    required this.routine,
  }) {
    _currentExerciseIndex = 0;
    _exerciseHistory = [];
  }

  final Routine routine;
  late List<ExerciseHistory>
      _exerciseHistory; // To store the history for each exercise in the session
  int _currentExerciseIndex = 0; // To track which exercise is being performed
  DateTime? startTime;
  DateTime? pausedTime;
  bool isRunning = false;

  // Getters to access private fields
  Exercise get currentExercise =>
      routine.exercises.toList()[_currentExerciseIndex];
  List<ExerciseHistory> get exerciseHistory => _exerciseHistory;
  int get remainingExercises =>
      routine.exercises.length - _currentExerciseIndex;

  // Start the session
  void start() {
    startTime = DateTime.now();
    isRunning = true;
  }

  // Pause the session
  void pause() {
    isRunning = false;
    pausedTime = DateTime.now();
  }

  // Resume the session
  void resume() {
    if (!isRunning && pausedTime != null) {
      startTime = startTime!.add(DateTime.now().difference(pausedTime!));
      pausedTime = null;
      isRunning = true;
    }
  }

  // Complete the current exercise
  void completeExercise(List<ExerciseSet> sets) {
    final history = ExerciseHistory()
      ..date = DateTime.now()
      ..sets.addAll(sets);

    _exerciseHistory.add(history);

    if (_currentExerciseIndex < routine.exercises.length - 1) {
      _currentExerciseIndex++;
    } else {
      finish();
    }
  }

  // Discard the session
  void discard() {
    isRunning = false;
    startTime = null;
    pausedTime = null;
    _exerciseHistory.clear();
    _currentExerciseIndex = 0;
  }

  // Finish the session
  void finish() {
    isRunning = false;
    // Save the session data to the database (Handled by a repository or provider)
    _saveSessionToHistory();
  }

  // Private method to save session data to history
  void _saveSessionToHistory() {
    // Here, you'd use a repository or provider to save _exerciseHistory to the database
    // Example: exerciseRepository.saveExerciseHistory(_exerciseHistory);
  }
}
