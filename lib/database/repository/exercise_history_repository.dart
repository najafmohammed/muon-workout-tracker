import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';

class ExerciseHistoryRepository {
  ExerciseHistoryRepository(this._isar);

  final Isar _isar;

  Future<List<ExerciseHistory>> getAllExerciseHistory() async {
    return _isar.exerciseHistorys.where().findAll();
  }

  Future<ExerciseHistory?> getExerciseHistoryById(Id id) async {
    return _isar.exerciseHistorys.get(id);
  }

  Future<bool> addExerciseHistory(ExerciseHistory exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exerciseHistorys.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteExerciseHistory(Id id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exerciseHistorys.delete(id);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
