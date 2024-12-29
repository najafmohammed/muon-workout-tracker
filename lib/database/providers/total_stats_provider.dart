import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/total_stats.dart';
import 'package:muon_workout_tracker/database/providers/isar_provider.dart';
import 'package:muon_workout_tracker/database/repository/total_stats_repository.dart';

final totalStatsRepositoryProvider =
    StateNotifierProvider<TotalStatsRepository, TotalStats?>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) {
    throw Exception('Isar instance is not initialized');
  }
  return TotalStatsRepository(isar);
});
