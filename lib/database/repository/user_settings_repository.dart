import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/models/user_settings.dart';

class UserSettingsRepository extends StateNotifier<UserSettings?> {
  final Isar _isar;

  UserSettingsRepository(this._isar) : super(null) {
    // Initialize the user settings when the repository is created
    _initializeUserSettings();
  }

  // Initializes user settings if they don't exist
  Future<void> _initializeUserSettings() async {
    state = await getUserSettings();

    // If no settings are found, initialize and save them
    if (state == null) {
      final newSettings = UserSettings()
        ..currentRoutineIndex = 0
        ..height = 0
        ..isSplitCompletedToday = false
        ..username = ""
        ..weight = 0;

      await _isar.writeTxn(() async {
        await _isar.userSettings.put(newSettings);
      });

      state = newSettings; // Update the state with the new settings
    }
  }

  // Fetches the user settings
  Future<UserSettings?> getUserSettings() async {
    var settings = await _isar.userSettings.where().findFirst();
    return settings;
  }

  // Updates the current split
  Future<void> updateCurrentSplit(Split split) async {
    if (state == null) {
      await _initializeUserSettings();
    }

    // Now that settings are initialized, retrieve them and update the current split
    if (state != null) {
      await _isar.writeTxn(() async {
        await state!.currentSplit.reset();
        state!.currentSplit.value = split;
        await state!.currentSplit.save();
        await _isar.userSettings.put(state!);
      });

      state =
          await getUserSettings(); // Update the state after changing the split
    }
  }

  // Updates the current routine index
  Future<void> updateCurrentRoutineIndex(int index) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.currentRoutineIndex = index;
        await _isar.userSettings.put(state!);
      });

      state =
          await getUserSettings(); // Update the state after updating the routine index
    }
  }

  // Marks the split as completed
  Future<void> markSplitAsCompleted() async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.isSplitCompletedToday = true;
        await _isar.userSettings.put(state!);
      });

      state =
          await getUserSettings(); // Update the state after marking the split as completed
    }
  }

  // Resets the daily status of the split
  Future<void> resetDailyStatus() async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.isSplitCompletedToday = false;
        await _isar.userSettings.put(state!);
      });

      state =
          await getUserSettings(); // Update the state after resetting the daily status
    }
  }
}
