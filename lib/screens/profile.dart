import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch user settings from the provider
    final userSettings = ref.watch(userSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Unified horizontal padding
        child: userSettings == null
            ? const Center(child: Text('No user settings found.'))
            : ListView(
                children: [
                  const SizedBox(height: 16.0), // Consistent padding top

                  // Profile Icon Section with an overlay icon
                  const Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              size: 70,
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Editable Username
                  ListTile(
                    contentPadding: EdgeInsets.zero, // Remove inner padding
                    title: TextFormField(
                      initialValue: userSettings.username.isNotEmpty
                          ? userSettings.username
                          : 'Your Name',
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (value) {
                        ref
                            .read(userSettingsProvider.notifier)
                            .updateUsername(value);
                      },
                    ),
                  ),

                  // Editable Height
                  ListTile(
                    contentPadding: EdgeInsets.zero, // Remove inner padding
                    title: TextFormField(
                      initialValue: userSettings.height.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Height (cm)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        ref
                            .read(userSettingsProvider.notifier)
                            .updateHeight(double.tryParse(value) ?? 0);
                      },
                    ),
                  ),

                  // Editable Weight
                  ListTile(
                    contentPadding: EdgeInsets.zero, // Remove inner padding
                    title: TextFormField(
                      initialValue: userSettings.weight.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Weight (kg)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        ref
                            .read(userSettingsProvider.notifier)
                            .updateWeight(double.tryParse(value) ?? 0);
                      },
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  // Notifications Section
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifications'),
                    trailing: Transform.scale(
                      scale: 0.8, // Make the switch smaller
                      child: Switch(
                        value: userSettings.notificationsEnabled,
                        onChanged: (value) {
                          ref
                              .read(userSettingsProvider.notifier)
                              .toggleNotifications(value);
                        },
                      ),
                    ),
                    onTap: () {
                      // Toggle switch on ListTile tap
                      ref
                          .read(userSettingsProvider.notifier)
                          .toggleNotifications(
                              !userSettings.notificationsEnabled);
                    },
                  ),

                  // Dark/Light Mode Section
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Dark Mode'),
                    trailing: Transform.scale(
                      scale: 0.8, // Make the switch smaller
                      child: Switch(
                        value: userSettings.darkMode,
                        onChanged: (value) {
                          ref
                              .read(userSettingsProvider.notifier)
                              .toggleDarkMode(value);
                        },
                      ),
                    ),
                    onTap: () {
                      // Toggle switch on ListTile tap
                      ref
                          .read(userSettingsProvider.notifier)
                          .toggleDarkMode(!userSettings.darkMode);
                    },
                  ),

                  const SizedBox(height: 16.0),

                  // Theme Color Section with Indicator for Current Color
                  const Text('Theme Color'),
                  const SizedBox(height: 8.0),
                  const ThemeColorSelector(), // Updated to show selected color
                  const SizedBox(height: 18.0),
                ],
              ),
      ),
    );
  }
}

// Custom Theme Color Selector Widget with Current Color Indicator
class ThemeColorSelector extends ConsumerStatefulWidget {
  const ThemeColorSelector({super.key});

  @override
  ConsumerState<ThemeColorSelector> createState() => _ThemeColorSelectorState();
}

class _ThemeColorSelectorState extends ConsumerState<ThemeColorSelector> {
  @override
  Widget build(BuildContext context) {
    // Get the current selected color from user settings
    final userSettings = ref.watch(userSettingsProvider);
    final selectedColor = userSettings?.themeColor;

    // Available color options
    final List<int> colors = [
      0xFF6200EE,
      0xFF00EEFF,
      0xFFFF5722,
      0xFF2196F3,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: colors.map((color) {
        final isSelected = color == selectedColor;

        return GestureDetector(
          onTap: () {
            ref.read(userSettingsProvider.notifier).updateThemeColor(color);
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Color(color),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null, // Show check icon if it's the selected color
          ),
        );
      }).toList(),
    );
  }
}
