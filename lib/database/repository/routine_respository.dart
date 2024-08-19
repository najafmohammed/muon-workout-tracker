import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

class RoutineRepository {
  RoutineRepository(this._isar);

  final Isar _isar;

  Future<List<Exercise>> getAllRoutines() async {
    return _isar.exercises.where().findAll();
  }

  Future<Exercise?> getRoutineById(Id id) async {
    return _isar.exercises.get(id);
  }

  Future<bool> addRoutine(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRoutine(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRoutine(Id id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.delete(id);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
