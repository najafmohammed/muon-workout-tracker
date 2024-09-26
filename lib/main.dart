import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/config/theme.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';
import 'package:muon_workout_tracker/screens/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingsProv = ref.watch(userSettingsProvider);
    final bool isDarkMode = userSettingsProv!.darkMode;

    return MaterialApp(
      restorationScopeId: 'app',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.darkTheme(Color(userSettingsProv.themeColor), true),
      theme: AppTheme.darkTheme(Color(userSettingsProv.themeColor), false),
      home: const Navigation(),
    );
  }
}
