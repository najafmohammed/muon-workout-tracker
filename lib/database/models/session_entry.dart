import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';

part 'session_entry.g.dart';

@Collection()
class SessionEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date; // Store date when the routine was done

  // Relationship with ExerciseHistory
  final workouts = IsarLinks<ExerciseHistory>();

  late double volume; // Total volume (kg) for the session

  @ignore
  Duration duration = Duration.zero; // Store duration as Duration

  @Name("duration_seconds") // Store duration as total seconds in the database
  int get durationSeconds =>
      duration.inSeconds; // Convert to seconds for storage
  set durationSeconds(int seconds) {
    duration = Duration(seconds: seconds); // Convert seconds to Duration
  }

  // Helper method to format duration as hh:mm:ss
  String get formattedDuration {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  // Helper function to ensure two-digit formatting
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
