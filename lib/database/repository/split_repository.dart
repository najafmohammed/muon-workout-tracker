import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';

class SplitRepository {
  SplitRepository(this._isar);

  final Isar _isar;

  Future<List<Split>> getAllSplits() async {
    return _isar.splits.where().findAll();
  }

  Stream<List<Split>> getAllSplitsStream() {
    return _isar.splits.filter().nameContains("").watch(fireImmediately: true);
  }

  Stream<List<Split>> getAllSplitsFiltered({
    required String nameFilter,
    required String sortBy,
  }) {
    // Apply filtering and sorting
    QueryBuilder<Split, Split, QSortBy> query = _isar.splits
        .where()
        .filter()
        .nameContains(nameFilter, caseSensitive: false);
    switch (sortBy) {
      case 'name_asc':
        return query.sortByName().watch(fireImmediately: true);
      case 'name_desc':
        return query.sortByNameDesc().watch(fireImmediately: true);
    }

    return query.sortByName().watch(fireImmediately: true);
  }

  Future<bool> addSplit(Split split, List<Routine> routines) async {
    try {
      await _isar.writeTxn(() async {
        // First, add the routine to the database
        await _isar.splits.put(split);
        // Reset the link, no ideal but it just works
        await split.routines.reset();
        // Replace the exercises again
        for (int i = 0; i < routines.length; i++) {
          split.routines.add(routines[i]);
          split.orderedRoutineIds.add(routines[i].id);
        }
        split.routines.addAll(routines);
        // Save the updated routines
        await split.routines.save();

        // Update the routine with linked exercises
        await _isar.splits.put(split);
      });
      return true;
    } catch (e) {
      // Handle error (you might want to log it or show a message to the user)
      print('Error adding routine: $e');
      return false;
    }
  }

  Stream<String?> getWorkoutNameStream({
    required int currentRoutineIndex,
  }) async* {
    // Listen for changes in the split
    await for (final split in getAllSplitsStream()) {
      final orderedRoutines = await getOrderedRoutinesFromSplit(split[0]);

      // Emit the name of the routine based on the fixed current index
      if (currentRoutineIndex >= 0 &&
          currentRoutineIndex < orderedRoutines.length) {
        yield orderedRoutines[currentRoutineIndex].name;
      } else {
        // If the index is invalid, emit null
        yield null;
      }
    }
  }

  Future<List<Routine>> getOrderedRoutinesFromSplit(Split split) async {
    // Ensure that the routines are loaded
    await split.routines.load();

    // Create a map to quickly access routines by their id
    final routineMap = {
      for (var routine in split.routines) routine.id: routine
    };

    // Create an empty list to hold the routines in the correct order
    List<Routine> orderedRoutines = [];

    // Sort the routines by using the order of ids in `orderedRoutineIds`
    for (int routineId in split.orderedRoutineIds) {
      // If the routine with this id exists in the map, add it to the ordered list
      if (routineMap.containsKey(routineId)) {
        orderedRoutines.add(routineMap[routineId]!);
      }
    }

    // Return the routines sorted by the `orderedRoutineIds`
    return orderedRoutines;
  }

  Future<bool> updateSplit(Split split) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.splits.put(split);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSplit(Id id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.splits.delete(id);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
