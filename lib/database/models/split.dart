import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

part 'split.g.dart';

@Collection()
class Split {
  Id id = Isar.autoIncrement;
  late String name;
  int nextIndex = 0;
  bool isCompletedToday = false;

  // Relationship with Routine
  final routines = IsarLinks<Routine>(); // Links to Routines

  // Store the order of routine ids
  late List<int> orderedRoutineIds;
}
