import 'package:isar/isar.dart';

part 'total_stats.g.dart';

@Collection()
class TotalStats {
  Id id = Isar.autoIncrement;

  // Total stats
  late int totalTime; // Store total time in minutes
  late int totalWorkouts;
  late double totalVolume; // Total volume in kg

  // Stats for this week
  late int currentWeekTime;
  late int currentWeekWorkouts;
  late double currentWeekVolume;

  // Stats for last week
  late int lastWeekTime;
  late int lastWeekWorkouts;
  late double lastWeekVolume;
}
