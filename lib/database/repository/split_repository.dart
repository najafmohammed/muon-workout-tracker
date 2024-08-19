import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

class SplitRepository {
  SplitRepository(this._isar);

  final Isar _isar;

  Future<List<Exercise>> getAllSplits() async {
    return _isar.exercises.where().findAll();
  }

  Future<Exercise?> getSplitById(Id id) async {
    return _isar.exercises.get(id);
  }

  Future<bool> addSplit(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSplit(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSplit(Id id) async {
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
