import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/isar_provider.dart';
import 'package:muon_workout_tracker/database/repository/split_repository.dart';

final splitProvider = Provider<SplitRepository>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) {
    throw Exception('Isar instance is not initialized');
  }
  return SplitRepository(isar);
});
