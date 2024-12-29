import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';

class ExerciseRepository {
  ExerciseRepository(this._isar);

  final Isar _isar;

  Future<List<Exercise>> getAllExercises() {
    return _isar.exercises.where().findAll();
  }

  Stream<List<Exercise>> getAllExercisesStream() {
    return _isar.exercises
        .filter()
        .nameContains("")
        .watch(fireImmediately: true);
  }

  Stream<List<Exercise>> getAllExercisesFiltered({
    required String nameFilter,
    required String sortBy,
  }) {
    // Apply filtering and sorting
    QueryBuilder<Exercise, Exercise, QSortBy> query = _isar.exercises
        .where()
        .filter()
        .nameContains(nameFilter, caseSensitive: false);
    switch (sortBy) {
      case 'name_asc':
        return query.sortByName().watch(fireImmediately: true);
      case 'name_desc':
        return query.sortByNameDesc().watch(fireImmediately: true);
      case 'date_asc':
        return query.sortByLastRun().watch(fireImmediately: true);
      case 'date_desc':
        return query.sortByLastRunDesc().watch(fireImmediately: true);
    }

    return query.sortByName().watch(fireImmediately: true);
  }

  Future<List<ExerciseSet>> getLatestSetsForExercise(Exercise exercise) async {
    // Load all the linked exercise histories for the exercise
    await exercise.exerciseHistory.load();

    if (exercise.exerciseHistory.isNotEmpty) {
      // Sort the exercise history by date (assuming ExerciseHistory has a 'date' field)
      final sortedHistories = exercise.exerciseHistory.toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Sort descending by date

      // Get the latest history
      final latestHistory = sortedHistories.first;

      // Load the sets linked to the latest history
      // await latestHistory.sets;

      // Return the list of sets for the latest history
      return latestHistory.sets.toList();
    } else {
      // If there is no exercise history, return an empty list
      return [];
    }
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

  Future<bool> updateExerciseNoHistory(Exercise exercise) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exercises.put(exercise);
      });

      return true;
    } catch (e) {
      print('Error updating exercise: $e');
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
