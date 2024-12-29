import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/screens/exercise_stats_adv.dart';
import 'package:muon_workout_tracker/screens/routine_stats_adv.dart';
import 'package:muon_workout_tracker/screens/split_stats_adv.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

// Update the AdvancedStatsCard widget
class AdvancedStatsCard extends ConsumerWidget {
  const AdvancedStatsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardWrapper(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Advanced Stats', style: AppTextStyle.large),
          ],
        ),
        const SizedBox(height: 10),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          children: [
            _buildGroupedStatCard(context, 'Routine', Icons.fitness_center, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RoutineStatsScreen()),
              );
            }),
            _buildGroupedStatCard(context, 'Split', Icons.group, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SplitStatsScreen()),
              );
            }),
            _buildGroupedStatCard(context, 'Exercise', Icons.sports_gymnastics,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExerciseStatsScreen()),
              );
            }),
          ],
        ),
      ],
    );
  }

  // Updated helper method to create grouped stat cards with onTap
  Widget _buildGroupedStatCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CardWrapper(
        children: [
          Center(
            child: Column(
              children: [
                Icon(icon, size: 30, color: Colors.blue),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTextStyle.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
