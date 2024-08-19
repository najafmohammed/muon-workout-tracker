import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

class ExerciseRepository {
  ExerciseRepository(this._isar);

  final Isar _isar;

  Future<List<Exercise>> getAllExercises() async {
    return _isar.exercises.where().findAll();
  }

  Future<Exercise?> getExerciseById(Id id) async {
    return _isar.exercises.get(id);
  }

  Future<bool> addExercise(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateExercise(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteExercise(Id id) async {
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
