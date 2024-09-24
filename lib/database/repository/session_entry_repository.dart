import 'package:isar/isar.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';

class SessionEntryRepository {
  final Isar _isar;

  SessionEntryRepository(this._isar);

  // Add a new Routine session
  Future<void> addSessionEntry(SessionEntry sessionEntry) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntrys
          .put(sessionEntry); // Insert the routine into the database
      await sessionEntry.workouts.save();
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

  // Retrieve a specific Routine session by date
  Future<SessionEntry?> getSessionEntryByDate(DateTime date) async {
    return await _isar.sessionEntrys
        .filter()
        .dateEqualTo(date) // Filter routines by date
        .findFirst(); // Find the first matching routine
  }

  // Retrieve all Routine sessions within a date range
  Future<List<SessionEntry>> getSessionEntryByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _isar.sessionEntrys
        .filter()
        .dateBetween(startDate, endDate) // Filter by date range
        .sortByDateDesc() // Sort by date in descending order
        .findAll(); // Retrieve all routines within the range
  }
}
