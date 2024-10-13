import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/session_entry_provider.dart';
import 'package:muon_workout_tracker/shared/stats_column.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/shared/wrappers/workout_calendar.dart';
import 'package:muon_workout_tracker/utils/longest_streak.dart';
import 'package:muon_workout_tracker/utils/workout_days_range.dart';
import 'package:muon_workout_tracker/widgets/all_history_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryCard extends ConsumerWidget {
  const HistoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionEntryRepository = ref.read(sessionEntryProvider);

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return CardWrapper(
      children: [
        const Text('History', style: AppTextStyle.large),
        const SizedBox(height: 15), // Space between title and content

        FutureBuilder<Set<DateTime>>(
          future: getWorkoutDaysForRange(
              sessionEntryRepository, startOfMonth, endOfMonth),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading indicator
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              final workoutDays = snapshot.data ?? {};
              final totalDays = workoutDays.length;
              final longestStreak = calculateLongestStreak(workoutDays);

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildStatColumn(
                          Icons.calendar_today, 'Workout Days', '$totalDays'),
                      buildStatColumn(
                          Icons.star, 'Longest Streak', '$longestStreak'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 1, height: 20, color: Colors.grey),
                  const SizedBox(height: 15),
                  WorkoutCalendar(
                    workoutDays: workoutDays,
                    firstDay: startOfMonth,
                    lastDay: endOfMonth,
                    availableGestures: AvailableGestures.none,
                    hideNavigation: true, // Hide navigation for this page
                  ),
                ],
              );
            }
          },
        ),

        const SizedBox(height: 30), // Space between calendar and button

        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllHistoryPage(), // Pass data
              ),
            );
          },
          child: const Text('View All History'),
        ),
      ],
    );
  }
}
