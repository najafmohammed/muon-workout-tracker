import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';

part 'session_entry.g.dart';

@Collection()
class SessionEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date; // Store the date when the routine was done

  // Relationship with ExerciseHistory
  final workouts = IsarLinks<ExerciseHistory>();

  late double volume; // Total volume (kg) for the session

  late int duration; // Duration stored in seconds directly
}
