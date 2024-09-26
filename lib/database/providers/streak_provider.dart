import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';
import 'package:muon_workout_tracker/database/providers/session_entry_provider.dart';
import 'package:muon_workout_tracker/utils/weekday.dart';

enum StreakState {
  missed,
  active,
  inactive,
}

final streakProvider = FutureProvider<List<StreakState>>((ref) async {
  // Get the session entries from the database
  final sessionEntryProv = ref.watch(sessionEntryProvider);

  List daysOfWeek = getDaysOfWeek(); // Adjusted to get DateTime list

  // List to hold the streak states for each day of the week
  List<StreakState> streaks =
      List.filled(7, StreakState.inactive); // Initially set all to inactive

  // Retrieve session entries for the current week
  List<SessionEntry> sessionEntries = await sessionEntryProv
      .getSessionEntryByDateRange(daysOfWeek.first, daysOfWeek.last);

  DateTime today = DateTime.now();

  for (int i = 0; i < daysOfWeek.length; i++) {
    DateTime currentDay = daysOfWeek[i];

    bool isToday = (currentDay).year == today.year &&
        (currentDay).month == today.month &&
        (currentDay).day == today.day;
    // Check if the current day is today
    if (isToday) {
      // Check if there's a session entry for today
      bool hasEntry = sessionEntries.any((element) {
        return DateFormat('yyyy-MM-dd').format(element.date) ==
            DateFormat('yyyy-MM-dd').format(currentDay);
      });

      streaks[i] = hasEntry
          ? StreakState.active
          : StreakState
              .inactive; // Set to active if there's an entry, otherwise missed
    } else if (currentDay.isAfter(today)) {
      streaks[i] = StreakState.inactive; // Future days are inactive
    } else {
      // For past days, check if there's a session entry
      bool hasEntry = sessionEntries.any((element) {
        return DateFormat('yyyy-MM-dd').format(element.date) ==
            DateFormat('yyyy-MM-dd').format(currentDay);
      });

      streaks[i] = hasEntry
          ? StreakState.active
          : StreakState
              .missed; // Set to active if there's an entry, otherwise missed
    }
  }

  return streaks;
});
