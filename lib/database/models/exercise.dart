import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';

part 'exercise.g.dart';

@Collection()
class Exercise {
  Id id = Isar.autoIncrement;
  late String name;
  @enumerated
  late MuscleGroup muscleGroup;
  late String tag = "Same";
  DateTime? lastRun;
  final exerciseHistory = IsarLinks<ExerciseHistory>();
}

enum MuscleGroup {
  abs,
  biceps,
  calves,
  cardio,
  chest,
  forearms,
  fullBody,
  glutes,
  hamstrings,
  lats,
  legs,
  lowerBack,
  neck,
  shoulders,
  traps,
  triceps,
  upperBack,
  other
}
