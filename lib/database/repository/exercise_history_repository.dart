import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

class ExerciseHistoryRepository {
  ExerciseHistoryRepository(this._isar);

  final Isar _isar;

  Future<List<Exercise>> getAllExerciseHistory() async {
    return _isar.exercises.where().findAll();
  }

  Future<Exercise?> getExerciseHistoryById(Id id) async {
    return _isar.exercises.get(id);
  }

  Future<bool> addExerciseHistory(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteExerciseHistory(Id id) async {
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
