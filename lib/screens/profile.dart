import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';
import 'package:muon_workout_tracker/utils/url_launch.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  static const List<String> catGifs = [
    "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjlhNHRvdzZ5OWhxcjd5N3Juamlpcnp4eWJiNzQzejBlc3A3aTRrcyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/WNcb7X5QHgr9cqWm1S/giphy.gif",
    "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExYXJoaTNhMzVoZjlieTZzM2w3dWVoNmo1dmtra2x4MjNoc3pnMHQ0ZSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/Lp5wuqMOmLUaAd0jBG/giphy-downsized.gif",
    "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExNTl2ZTRnY2QwbjlydGs2bTg3Zmh0cWlqanZhZGE1cTYzdXN5dXU0ayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/W0VuY0dTxH9L6vLUJ2/giphy.gif",
    "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExNnVvbmp1dmMwcnNqa3V1dGl6NHlhbGJuaDZrb2Rhemw4NGNuajBwdiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/m2UOUl8V5CBc4/giphy-downsized.gif",
  ];

  int index = Random().nextInt(catGifs.length);

  @override
  Widget build(BuildContext context) {
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

                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          index = (index + 1) % catGifs.length;
                        });
                      },
                      child: CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                            child: Image.network(
                          catGifs[index],
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // The image is fully loaded, return it.
                            }
                            return Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null, // Spinner progress or indeterminate if unknown
                                ),
                              ),
                            );
                          },
                        )),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Personal Info',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
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

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Preferences',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'About',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('GIF Attribution'),
                    subtitle: const Text('GIPHY'),
                    trailing: InkWell(
                      onTap: () async {
                        launchURL("https://giphy.com/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(
                            12.0), // Increased padding for a larger clickable area
                        child: Image.asset(
                          'assets/images/${userSettings.darkMode ? "giphy-dark" : "giphy-light"}.png',
                          height:
                              40, // Increased height to make the icon larger
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Info'),
                    subtitle: const Text('Developed by Najaf'),
                    trailing: InkWell(
                      onTap: () {
                        launchURL(
                            "https://github.com/najafmohammed/muon-workout-tracker");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(
                            12.0), // Increased padding for a larger clickable area
                        child: Image.asset(
                          'assets/images/${userSettings.darkMode ? "github-light" : "github-dark"}.png',
                          height:
                              40, // Increased height to make the icon larger
                        ),
                      ),
                    ),
                  ),
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
