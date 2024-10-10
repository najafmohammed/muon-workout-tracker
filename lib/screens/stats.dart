import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/widgets/advanced_stats_card.dart';
import 'package:muon_workout_tracker/widgets/history_card.dart';
import 'package:muon_workout_tracker/widgets/last_session_card.dart';
import 'package:muon_workout_tracker/widgets/total_stats_card.dart';

class Stats extends ConsumerWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TotalStatsCard(),
            LastSessionCard(),
            HistoryCard(),
            AdvancedStatsCard()
          ],
        ),
      ),
    );
  }
}
