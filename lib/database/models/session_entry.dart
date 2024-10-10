import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

part 'session_entry.g.dart';

@Collection()
class SessionEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date; // Store the date when the routine was done

  // Relationship with ExerciseHistory
  final workouts = IsarLinks<ExerciseHistory>();
  // Relationship with routines
  final routines = IsarLinks<Routine>();

  late double volume; // Total volume (kg) for the session

  late int duration; // Duration stored in seconds directly
}
