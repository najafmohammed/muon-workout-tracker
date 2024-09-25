import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart'; // Import the animations package
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/shared/expanded_mini_player.dart';

class MiniPlayer extends ConsumerStatefulWidget {
  const MiniPlayer({super.key});

  @override
  MiniPlayerState createState() => MiniPlayerState();
}

class MiniPlayerState extends ConsumerState<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    final routineSessionProv = ref.watch(routineSessionProvider);
    final isRunning = routineSessionProv?.isRunning ?? false;
    final progress = routineSessionProv?.progress ?? 0.0;
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);

    // Formatting for current set and reps
    final currentSet =
        '${(routineSessionNotifier.currentSet?.entries.first.value.weight.toInt())} Kg x ${routineSessionNotifier.currentSet?.entries.first.value.reps}';

    return OpenContainer(
      openColor: Colors.black,
      closedColor: Theme.of(context).primaryColor,
      transitionType: ContainerTransitionType.fadeThrough,
      closedShape: const RoundedRectangleBorder(),
      closedElevation: 0.0,
      openElevation: 0.0,
      transitionDuration: const Duration(milliseconds: 700),
      closedBuilder: (context, action) =>
          _buildMiniPlayer(context, action, progress, currentSet, isRunning),
      openBuilder: (context, action) => const ExpandedMiniPlayer(),
    );
  }

  // The MiniPlayer UI
  Widget _buildMiniPlayer(BuildContext context, VoidCallback action,
      double progress, String currentSet, bool isRunning) {
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);

    return InkWell(
      onTap: action, // Trigger the container transform animation
      child: Column(
        children: [
          // Progress bar
          Hero(
            tag: "Progress",
            child: LinearProgressIndicator(value: progress),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.fitness_center),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "CurrentExerciseName",
                          child: Text(
                              routineSessionNotifier.currentExercise?.name ??
                                  ""),
                        ),
                        Text(currentSet),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      routineSessionNotifier.togglePause();
                    },
                    icon: Icon(
                      isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      routineSessionNotifier.discardSession();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
