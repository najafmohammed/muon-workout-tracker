import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/user_settings.dart';
import 'package:muon_workout_tracker/database/providers/isar_provider.dart';
import 'package:muon_workout_tracker/database/repository/user_settings_repository.dart';

final userSettingsProvider =
    StateNotifierProvider<UserSettingsRepository, UserSettings?>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) {
    throw Exception('Isar instance is not initialized');
  }
  return UserSettingsRepository(isar);
});
