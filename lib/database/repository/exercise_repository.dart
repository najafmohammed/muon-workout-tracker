import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';

class ExerciseRepository {
  ExerciseRepository(this._isar);

  final Isar _isar;

  Stream<List<Exercise>> getAllExercises() {
    return _isar.exercises.where().watch(fireImmediately: true);
  }

  Stream<List<Exercise>> getAllExercisesFiltered({
    required String nameFilter,
  }) {
    return _isar.exercises
        .filter()
        .nameContains(nameFilter)
        .watch(fireImmediately: true);
  }

  Future<Exercise?> getExerciseById(Id id) async {
    return _isar.exercises.get(id);
  }

  Future<bool> addExercise(Exercise exercise, ExerciseHistory history) async {
    try {
      // Use a single transaction to put exercise and exercise history separately
      await _isar.writeTxn(() async {
        // First, save the exercise to get an ID
        await _isar.exercises.put(exercise);

        // Now save the histories individually to assign them IDs
        await _isar.exerciseHistorys.put(history);

        // Link the saved histories to the exercise
        exercise.exerciseHistory.add(history);

        // After linking histories, save the exercise with the links
        await exercise.exerciseHistory.save();
      });

      return true;
    } catch (e) {
      print('Error adding exercise: $e');
      return false;
    }
  }

  Future<bool> updateExercise(
      Exercise exercise, ExerciseHistory history) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
        await _isar.exerciseHistorys.put(history);
        exercise.exerciseHistory.add(history);
        await exercise.exerciseHistory.save();
      });

      return true;
    } catch (e) {
      print('Error updating exercise: $e');
      return false;
    }
  }

  Future<bool> deleteExercise(Id id) async {
    try {
      await _isar.writeTxn(() async {
        //  delete the associated histories
        var exercise = await _isar.exercises.get(id);
        if (exercise != null) {
          await exercise.exerciseHistory.load();
          for (var history in exercise.exerciseHistory) {
            await _isar.exerciseHistorys.delete(history.id);
          }
        }

        await _isar.exercises.delete(id);
      });
      return true;
    } catch (e) {
      print('Error deleting exercise: $e');
      return false;
    }
  }
}
