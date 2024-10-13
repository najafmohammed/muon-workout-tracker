import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';
import 'package:muon_workout_tracker/database/providers/session_entry_provider.dart';
import 'package:muon_workout_tracker/shared/stats_column.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:intl/intl.dart'; // For formatting date

class LastSessionCard extends ConsumerWidget {
  const LastSessionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the latest session entry
    Future<SessionEntry?> fetchLatestSession() async {
      final sessionEntryProv = ref.read(sessionEntryProvider);
      return await sessionEntryProv
          .getLatestSessionEntry(); // Assuming this is implemented
    }

    return FutureBuilder<SessionEntry?>(
      future: fetchLatestSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading last session'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final sessionEntry = snapshot.data!;
          final lastRoutine = sessionEntry.routines.lastOrNull?.name ??
              'Unknown'; // Get last routine name
          final formattedDate = DateFormat('MMM d, yyyy')
              .format(sessionEntry.date); // Format the session date

          return CardWrapper(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text('Last Session', style: AppTextStyle.large),
                  const SizedBox(height: 10), // Space between title and content

                  // Content row with icons and text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildStatColumn(
                          Icons.fitness_center, 'Workout', '$lastRoutine'),
                      buildStatColumn(
                          Icons.date_range, 'Date', '$formattedDate'),
                    ],
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(child: Text('No last session found'));
        }
      },
    );
  }
}
