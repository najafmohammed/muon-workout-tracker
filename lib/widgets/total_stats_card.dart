import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/total_stats.dart';
import 'package:muon_workout_tracker/database/providers/total_stats_provider.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/utils/stats_formating.dart';

class TotalStatsCard extends ConsumerWidget {
  const TotalStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Function to fetch total stats
    Future<TotalStats?> fetchTotalStats() async {
      return await ref
          .read(totalStatsRepositoryProvider.notifier)
          .getTotalStats();
    }

    return FutureBuilder<TotalStats?>(
      future: fetchTotalStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading stats"));
        } else if (snapshot.hasData && snapshot.data != null) {
          final stats = snapshot.data!;
          final percentChanges = ref
              .read(totalStatsRepositoryProvider.notifier)
              .getPercentageChange();

          // Use utility functions to format time and volume
          String formattedTime = formatTime(stats.totalTime);
          String formattedVolume = formatVolume(stats.totalVolume);

          return CardWrapper(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(
                    icon: Icons.timer,
                    color: Colors.blue,
                    value: formattedTime,
                    percentageChange: percentChanges['timeChange']!,
                    label: 'Time',
                  ),
                  _buildStatColumn(
                    icon: Icons.fitness_center,
                    color: Colors.red,
                    value: '${stats.totalWorkouts}',
                    percentageChange: percentChanges['workoutChange']!,
                    label: 'Workouts',
                  ),
                  _buildStatColumn(
                    icon: Icons.scale,
                    color: Colors.orange,
                    value: formattedVolume,
                    percentageChange: percentChanges['volumeChange']!,
                    label: 'Volume',
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(child: Text('No stats found'));
        }
      },
    );
  }

  // Helper method to build each stat column
  Column _buildStatColumn({
    required IconData icon,
    required Color color,
    required String value,
    required double percentageChange,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: color),
        Text(value, style: AppTextStyle.large),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              percentageChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: percentageChange >= 0 ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 4), // Space between icon and percentage text
            Text(
              '${percentageChange.toStringAsFixed(1)}%',
              style: TextStyle(
                color: percentageChange >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyle.small),
      ],
    );
  }
}
