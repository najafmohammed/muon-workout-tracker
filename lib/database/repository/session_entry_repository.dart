import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';

class SessionEntryRepository {
  final Isar _isar;

  SessionEntryRepository(this._isar);

  // Add a new Routine session
  Future<void> addSessionEntry(SessionEntry sessionEntry) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntrys
          .put(sessionEntry); // Insert the session into the database
      await sessionEntry.workouts.save(); // Save the workouts link
      await sessionEntry.routines.save(); // Save routines link
    });
  }

  // Delete a Routine session by id
  Future<void> deleteSessionEntry(int id) async {
    await _isar.writeTxn(() async {
      bool success = await _isar.sessionEntrys.delete(id); // Delete the session
      if (!success) {
        print('Error: Session with id $id not found.');
      }
    });
  }

  // Retrieve all Routine sessions, sorted by date
  Future<List<SessionEntry>> getAllSessionEntry() async {
    return await _isar.sessionEntrys
        .where()
        .sortByDateDesc() // Sort sessions by date in descending order
        .findAll(); // Retrieve all routine sessions
  }

// Retrieve a specific Routine session by date, looking at the range for the entire day
  Future<SessionEntry?> getSessionEntryByDate(DateTime date) async {
    // First moment of the day (00:00:00.000)
    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);

    // Last moment of the day (23:59:59.999)
    DateTime endOfDay =
        DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // Search for session entries between the start and end of the selected day
    return await _isar.sessionEntrys
        .filter()
        .dateBetween(startOfDay, endOfDay) // Search within the full day range
        .findFirst(); // Return the first matching session entry
  }

  // Retrieve all Routine sessions within a date range
  Future<List<SessionEntry>> getSessionEntryByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _isar.sessionEntrys
        .filter()
        .dateBetween(startDate, endDate) // Filter by date range
        .sortByDate() // Sort by date
        .findAll(); // Retrieve all sessions within the range
  }

  // Retrieve the latest Routine session (most recent)
  Future<SessionEntry?> getLatestSessionEntry() async {
    return await _isar.sessionEntrys
        .where()
        .sortByDateDesc() // Sort by date in descending order (latest first)
        .findFirst(); // Return the first entry (the latest session)
  }
}
