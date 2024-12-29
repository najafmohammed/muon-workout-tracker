// Function to fetch workout days and convert them to Set<DateTime>
import 'package:muon_workout_tracker/database/repository/session_entry_repository.dart';

Future<Set<DateTime>> getWorkoutDaysForRange(
    SessionEntryRepository sessionEntryRepository,
    DateTime startOfMonth,
    DateTime endOfMonth) async {
  // Fetch session entries for the month
  final sessionEntries =
      await sessionEntryRepository.getSessionEntryByDateRange(
    startOfMonth,
    endOfMonth,
  );

  // Create a set where each date indicates a workout was done
  final Set<DateTime> workoutDays =
      sessionEntries.map((entry) => entry.date).toSet();

  return workoutDays;
}
