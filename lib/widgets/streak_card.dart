import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/utils/weekday.dart';
import 'package:muon_workout_tracker/database/providers/streak_provider.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakProvider);
    final date = getDaysOfWeek(); // List of DateTime
    final day = getDaysOfWeek(weekDay: true); // List of day names

    DateTime today = DateTime.now(); // Get today's date

    return CardWrapper(
      children: [
        const Text(
          'Streak',
          style: AppTextStyle.large,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: streakData.when(
            data: (streaks) {
              var streakWidgets = <Widget>[];
              date.asMap().forEach((index, value) {
                // Determine the color based on the streak state
                Color streakColor;
                if (streaks[index] == StreakState.active) {
                  streakColor = Theme.of(context)
                      .colorScheme
                      .inversePrimary; // Active streak
                } else if (streaks[index] == StreakState.missed) {
                  streakColor = Colors.redAccent; // Missed streak
                } else {
                  streakColor =
                      Theme.of(context).primaryColor; // Inactive streak
                }

                // Create a container for each day with a border if today
                bool isToday = (value as DateTime).year == today.year &&
                    (value).month == today.month &&
                    (value).day == today.day;

                streakWidgets.add(
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: streakColor,
                      border: isToday
                          ? Border.all(
                              color: Colors.blue,
                              width: 2.0, // Customize the border width
                            )
                          : null, // No border for other days
                    ),
                    child: Column(
                      children: [
                        Text((value).day.toString()), // Display day number
                        Text(day[index][0]), // Display day name
                      ],
                    ),
                  ),
                );
              });

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: streakWidgets,
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => const Text("Error loading streaks"),
          ),
        ),
      ],
    );
  }
}
