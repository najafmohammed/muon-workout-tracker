import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';

class RoutineRepository {
  RoutineRepository(this._isar);

  final Isar _isar;

  Future<List<Routine>> getAllRoutines() async {
    return _isar.routines.where().findAll();
  }

  Stream<List<Routine>> getAllRoutinesFiltered({
    required String nameFilter,
  }) {
    return _isar.routines
        .filter()
        .nameContains(nameFilter)
        .watch(fireImmediately: true);
  }

  Future<Routine?> getRoutineById(Id id) async {
    return _isar.routines.get(id);
  }

  Future<List<Exercise>> getAllRoutineExercises(Id id) async {
    return _isar.routines.get(id).then((value) => value!.exercises.toList());
  }

  Future<List<Exercise>> getOrderedExercisesFromRoutine(Routine routine) async {
    // Ensure that the routines are loaded
    await routine.exercises.load();

    // Create a map to quickly access routines by their id
    final exerciseMap = {
      for (var exercises in routine.exercises) exercises.id: exercises
    };

    // Create an empty list to hold the routines in the correct order
    List<Exercise> orderedExercises = [];

    // Sort the routines by using the order of ids in `orderedRoutineIds`
    for (int exerciseId in routine.orderedExerciseIds) {
      // If the routine with this id exists in the map, add it to the ordered list
      if (exerciseMap.containsKey(exerciseId)) {
        orderedExercises.add(exerciseMap[exerciseId]!);
      }
    }

    // Return the routines sorted by the `orderedRoutineIds`
    return orderedExercises;
  }

  Future<bool> addRoutine(Routine routine, List<Exercise> exercises) async {
    try {
      await _isar.writeTxn(() async {
        // First, add the routine to the database (if new)
        await _isar.routines.put(routine);
        // Reset the link, no ideal but it just works
        await routine.exercises.reset();
        // replace the exercises again

        for (int i = 0; i < exercises.length; i++) {
          routine.exercises.add(exercises[i]);
          routine.orderedExerciseIds.add(exercises[i].id);
        }

        routine.exercises.addAll(exercises);
        // Save the updated exercises
        await routine.exercises.save();

        // Finally, update the routine with the new exercises
        await _isar.routines.put(routine);
      });

      return true;
    } catch (e) {
      print('Error adding routine: $e');
      return false;
    }
  }

  Future<bool> updateRoutine(Routine routine) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.routines.put(routine);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRoutine(Id id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.routines.delete(id);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
