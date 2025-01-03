import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/split.dart';

part 'user_settings.g.dart';

@Collection()
class UserSettings {
  Id id = Isar.autoIncrement;
  late String username;
  late double height;
  late double weight;
  final currentSplit = IsarLink<Split>();
  int currentRoutineIndex = 0; // Index of the current routine within the split
  bool isSplitCompletedToday = false;

  // Additional settings
  bool notificationsEnabled = false; // For notifications
  bool darkMode = true; // Dark/light mode setting
  int themeColor = 0xFF00EEFF; // Default theme color (purple)
}
