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

  Future<bool> addRoutine(Routine routine, List<Exercise> exercises) async {
    try {
      await _isar.writeTxn(() async {
        // First, add the routine to the database
        await _isar.routines.put(routine);

        // Link exercises to the routine
        for (var exercise in exercises) {
          // Link each exercise to the routine
          routine.exercises.add(exercise);
        }
        routine.exercises.save();

        // Update the routine with linked exercises
        await _isar.routines.put(routine);
      });
      return true;
    } catch (e) {
      // Handle error (you might want to log it or show a message to the user)
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
