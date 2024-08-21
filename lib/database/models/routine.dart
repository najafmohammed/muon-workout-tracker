import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

part 'routine.g.dart';

@Collection()
class Routine {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime? lastRun;

  // Relationship with Exercise
  final exercises = IsarLinks<Exercise>();
}
