import 'package:isar/isar.dart';
import 'exercise.dart'; // Import the exercise model

part 'body_part.g.dart';

@Collection()
class BodyPart {
  Id id = Isar.autoIncrement;
  @enumerated
  // The muscle group (body part) associated with this model
  late MuscleGroup muscleGroup;

  // Relationship with exercises targeting this body part
  final exercises = IsarLinks<Exercise>();

  // Number of exercises for this body part
  late int exerciseCount;

  // Total volume lifted for this body part
  late double totalVolume;

  // Total time spent on this body part's exercises
  late int duration; // Duration stored in seconds directly

  // Constructor
  BodyPart({
    required this.muscleGroup,
    this.exerciseCount = 0,
    this.totalVolume = 0,
    this.duration = 0,
  });
}
