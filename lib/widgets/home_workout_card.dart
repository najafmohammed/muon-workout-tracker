import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class HomeWorkoutCard extends ConsumerWidget {
  const HomeWorkoutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final split = ref.watch(splitProvider);
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);
    final userSettings = ref.watch(userSettingsProvider);

    Future<Routine> getWorkoutName() async {
      final routine = await split
          .getOrderedRoutinesFromSplit(
              userSettings?.currentSplit.value as Split)
          .then((value) => value[userSettings!.currentRoutineIndex]);
      return routine;
    }

    return CardWrapper(
      children: [
        FutureBuilder(
          future: getWorkoutName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while waiting
            } else if (snapshot.hasError) {
              return const Text('Error loading routine'); // Handle errors
            } else if (snapshot.hasData) {
              final workoutName = snapshot.data?.name ??
                  'Unknown Routine'; // Fetch the routine name
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Workout",
                    style: AppTextStyle.large,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    workoutName,
                    style: AppTextStyle.small,
                  ),
                ],
              );
            } else {
              return const Text(
                  'No routine found'); // Handle case where no routine is found
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                routineSessionNotifier.start();
              },
              child: const Text("Start Workout"),
            ),
          ],
        ),
      ],
    );
  }
}
