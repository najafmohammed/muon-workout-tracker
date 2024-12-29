import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';

part 'exercise_history.g.dart';

@Collection()
class ExerciseHistory {
  Id id = Isar.autoIncrement;
  late DateTime date;

  // Relationship with Sets
  late List<ExerciseSet> sets;
}
