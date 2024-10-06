import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

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
            _buildGroupedStatCard(' Routine', Icons.fitness_center),
            _buildGroupedStatCard(' Split', Icons.group),
            _buildGroupedStatCard(' Exercise', Icons.sports_gymnastics),
          ],
        ),
      ],
    );
  }

  // Helper method to create grouped stat cards
  Widget _buildGroupedStatCard(String title, IconData icon) {
    return CardWrapper(
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
    );
  }
}
