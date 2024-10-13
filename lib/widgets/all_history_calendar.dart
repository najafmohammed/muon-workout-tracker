import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/session_entry_provider.dart';
import 'package:muon_workout_tracker/shared/wrappers/workout_calendar.dart';
import 'package:muon_workout_tracker/utils/workout_days_range.dart';
import 'package:table_calendar/table_calendar.dart';

class AllHistoryPage extends ConsumerStatefulWidget {
  AllHistoryPage({super.key});

  @override
  _AllHistoryPageState createState() => _AllHistoryPageState();
}

class _AllHistoryPageState extends ConsumerState<AllHistoryPage> {
  @override
  Widget build(BuildContext context) {
    // Access the SessionEntryRepository using Riverpod
    final sessionEntryRepository = ref.read(sessionEntryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Set<DateTime>>(
          future: getWorkoutDaysForRange(
            sessionEntryRepository,
            DateTime.utc(2020, 1, 1),
            DateTime.utc(2100, 12, 31),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show a loading indicator
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Error loading workout days')); // Error message
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final workoutDays = snapshot.data!; // Extract workout days data

              return WorkoutCalendar(
                formatButtonVisible: true,
                workoutDays: workoutDays,
                firstDay:
                    DateTime.utc(2020, 1, 1), // Start from a long time ago
                lastDay: DateTime.utc(2030, 12, 31), // Far future end date
                calendarFormat: CalendarFormat.month, // Allow month view
                hideNavigation: false, // Show navigation
              );
            } else {
              return const Center(child: Text('No workout days found'));
            }
          },
        ),
      ),
    );
  }
}
