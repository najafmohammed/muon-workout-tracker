import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';
import 'package:muon_workout_tracker/screens/schedule.dart';
import 'package:muon_workout_tracker/shared/wrappers/accordion.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/widgets/workout_configuration.dart';

class HomeWorkoutCard extends ConsumerWidget {
  const HomeWorkoutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final split = ref.watch(splitProvider);
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);
    final userSettings = ref.watch(userSettingsProvider);

    Stream<String?> getWorkoutName() {
      return split.getWorkoutNameStream(
          currentRoutineIndex: userSettings!.currentRoutineIndex);
    }

    return StreamBuilder(
      stream: getWorkoutName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting
        } else if (snapshot.hasError) {
          return AccordionWrapper(
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              notificationTitle: 'Workout Configuration',
              child: WorkoutConfiguration(
                error: snapshot.error.toString(),
              )); // Handle errors
        } else if (snapshot.hasData) {
          final workoutName =
              snapshot.data ?? 'Unknown Routine'; // Fetch the routine name
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWrapper(children: [
                AccordionWrapper(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    notificationTitle: 'Workout Configuration',
                    child: WorkoutConfiguration()),
              ]),
              CardWrapper(children: [
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Schedule()),
                        );
                      },
                      child: const Text("Schedule"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        routineSessionNotifier.start();
                      },
                      child: const Text("Start Workout"),
                    ),
                  ],
                ),
              ])
            ],
          );
        } else {
          return const Text(
              'No routine found'); // Handle case where no routine is found
        }
      },
    );
  }
}
