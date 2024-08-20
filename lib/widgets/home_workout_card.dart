import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class HomeWorkoutCard extends ConsumerWidget {
  const HomeWorkoutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineSession = ref.watch(routineSessionProvider.notifier);

    return CardWrapper(children: [
      const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Workout",
                style: AppTextStyle.large,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'PUSH',
                style: AppTextStyle.small,
              ),
            ],
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
              onPressed: () {
                routineSession.start();
              },
              child: const Text("Start Workout")),
        ],
      )
    ]);
  }
}
