import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/total_stats.dart';
import 'package:intl/intl.dart';

class TotalStatsRepository extends StateNotifier<TotalStats?> {
  final Isar _isar;

  TotalStatsRepository(this._isar) : super(null) {
    _initializeTotalStats();
  }

  // Initializes total stats if they don't exist
  Future<void> _initializeTotalStats() async {
    state = await getTotalStats();

    if (state == null) {
      final newStats = TotalStats()
        ..totalTime = 0
        ..totalWorkouts = 0
        ..totalVolume = 0.0
        ..currentWeekTime = 0
        ..currentWeekWorkouts = 0
        ..currentWeekVolume = 0.0
        ..lastWeekTime = 0
        ..lastWeekWorkouts = 0
        ..lastWeekVolume = 0.0;

      await _isar.writeTxn(() async {
        await _isar.totalStats.put(newStats);
      });

      state = newStats;
    }
  }

  // Fetches the total stats
  Future<TotalStats?> getTotalStats() async {
    return await _isar.totalStats.where().findFirst();
  }

  // Adds session stats and checks if the week has changed
  Future<void> addSessionStats(int time, int workouts, double volume) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        _checkForNewWeek();

        // Add session stats to the current week and total
        state!.currentWeekTime += time;
        state!.currentWeekWorkouts += workouts;
        state!.currentWeekVolume += volume;

        state!.totalTime += time;
        state!.totalWorkouts += workouts;
        state!.totalVolume += volume;

        await _isar.totalStats.put(state!);
      });

      state = await getTotalStats();
    }
  }

  // Checks if a new week has started, and if so, shifts the current week stats to last week
  void _checkForNewWeek() {
    final DateTime now = DateTime.now();
    final DateTime previousSunday = _getPreviousSunday(now);

    // If the current week started on a different day, shift stats to last week
    if (!_isSameWeek(previousSunday, now)) {
      // Move current week's stats to last week's stats
      state!.lastWeekTime = state!.currentWeekTime;
      state!.lastWeekWorkouts = state!.currentWeekWorkouts;
      state!.lastWeekVolume = state!.currentWeekVolume;

      // Reset current week's stats
      state!.currentWeekTime = 0;
      state!.currentWeekWorkouts = 0;
      state!.currentWeekVolume = 0;
    }
  }

  // Helper function to check if two dates are in the same week
  bool _isSameWeek(DateTime startOfWeek, DateTime now) {
    return startOfWeek.year == now.year && startOfWeek.isBefore(now);
  }

  // Get the most recent Sunday
  DateTime _getPreviousSunday(DateTime now) {
    return now.subtract(Duration(days: now.weekday % 7));
  }

  // Calculate the percentage increase or decrease in stats compared to last week
  Map<String, double> getPercentageChange() {
    if (state != null) {
      double timeChange = _calculatePercentChange(
          state!.lastWeekTime.toDouble(), state!.currentWeekTime.toDouble());
      double workoutChange = _calculatePercentChange(
          state!.lastWeekWorkouts.toDouble(),
          state!.currentWeekWorkouts.toDouble());
      double volumeChange = _calculatePercentChange(
          state!.lastWeekVolume, state!.currentWeekVolume);

      return {
        "timeChange": timeChange,
        "workoutChange": workoutChange,
        "volumeChange": volumeChange,
      };
    }
    return {"timeChange": 0.0, "workoutChange": 0.0, "volumeChange": 0.0};
  }

  // Helper function to calculate percentage change
  double _calculatePercentChange(double lastWeek, double currentWeek) {
    if (lastWeek == 0) {
      return currentWeek == 0 ? 0 : 100;
    }
    return ((currentWeek - lastWeek) / lastWeek) * 100;
  }

  // Clear all stats
  Future<void> clearAllStats() async {
    await _isar.writeTxn(() async {
      await _isar.totalStats.clear();
    });

    await _initializeTotalStats(); // Reinitialize with default values
  }
}
