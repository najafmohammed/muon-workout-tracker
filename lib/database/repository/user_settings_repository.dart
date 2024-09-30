import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/models/user_settings.dart';

class UserSettingsRepository extends StateNotifier<UserSettings?> {
  final Isar _isar;

  UserSettingsRepository(this._isar) : super(null) {
    _initializeUserSettings();
  }

  // Initializes user settings if they don't exist
  Future<void> _initializeUserSettings() async {
    state = await getUserSettings();

    if (state == null) {
      final newSettings = UserSettings()
        ..currentRoutineIndex = 0
        ..height = 0
        ..isSplitCompletedToday = false
        ..username = ""
        ..weight = 0
        ..notificationsEnabled = false // Default value
        ..darkMode = true // Default value
        ..themeColor = 0xFF00EEFF; // Default theme color

      await _isar.writeTxn(() async {
        await _isar.userSettings.put(newSettings);
      });

      state = newSettings;
    }
  }

  // Fetches the user settings
  Future<UserSettings?> getUserSettings() async {
    return await _isar.userSettings.where().findFirst();
  }

  // Updates the username
  Future<void> updateUsername(String username) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.username = username;
        await _isar.userSettings.put(state!);
      });

      state = await getUserSettings();
    }
  }

  // Updates the height
  Future<void> updateHeight(double height) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.height = height;
        await _isar.userSettings.put(state!);
      });

      state = await getUserSettings();
    }
  }

  // Updates the weight
  Future<void> updateWeight(double weight) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.weight = weight;
        await _isar.userSettings.put(state!);
      });

      state = await getUserSettings();
    }
  }

  // Toggles notifications
  Future<void> toggleNotifications(bool isEnabled) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.notificationsEnabled = isEnabled;
        await _isar.userSettings.put(state!);
      });

      state = await getUserSettings();
    }
  }

  // Toggles dark mode
  Future<void> toggleDarkMode(bool isDarkMode) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.darkMode = isDarkMode;
        await _isar.userSettings.put(state!);
      });

      state = await getUserSettings();
    }
  }

  // Updates the theme color
  Future<void> updateThemeColor(int color) async {
    if (state != null) {
      await _isar.writeTxn(() async {
        state!.themeColor = color;
        await _isar.userSettings.put(state!);
      });

      state = await getUserSettings();
    }
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
