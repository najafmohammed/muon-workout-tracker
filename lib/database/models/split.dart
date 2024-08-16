import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

part 'split.g.dart';

@Collection()
class Split {
  Id id = Isar.autoIncrement;
  late int nextIndex;

  // Relationship with Routine
  final routines = IsarLinks<Routine>();
}
