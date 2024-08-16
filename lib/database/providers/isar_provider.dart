// providers/isar_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:path_provider/path_provider.dart';
import '../models/exercise.dart';

// Define a provider for the Isar database
final isarProvider = FutureProvider<Isar>((ref) async {
  // Check if there are no existing Isar instances
  if (Isar.instanceNames.isEmpty) {
    // Get the application documents directory
    final dir = await getApplicationDocumentsDirectory();

    // Open the Isar database
    return await Isar.open(
      [
        ExerciseSchema,
        SplitSchema,
        RoutineSchema,
        ExerciseHistorySchema,
      ],
      directory: dir.path, // Set the directory for the database
      inspector: true, // Optional: Enable Isar Inspector
    );
  } else {
    // If an instance already exists, return it
    return Isar.getInstance()!;
  }
});
