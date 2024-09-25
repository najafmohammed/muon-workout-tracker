import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/database/providers/timer_provider.dart';
import 'package:muon_workout_tracker/screens/exercise_playlist.dart';
import 'package:muon_workout_tracker/shared/set_builder.dart';
import 'package:muon_workout_tracker/shared/snackbar.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class ExpandedMiniPlayer extends ConsumerStatefulWidget {
  const ExpandedMiniPlayer({super.key});

  @override
  _ExpandedMiniPlayerState createState() => _ExpandedMiniPlayerState();
}

class _ExpandedMiniPlayerState extends ConsumerState<ExpandedMiniPlayer> {
  @override
  Widget build(BuildContext context) {
    // Read the session state and notifier
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);
    final routineSession = ref.watch(routineSessionProvider);
    final currentExercise = routineSessionNotifier.currentExercise;
    final progress = routineSession?.progress ?? 0.0;
    // Get the sets for the current exercise
    final currentExerciseSets =
        routineSessionNotifier.exerciseSets[currentExercise];
    return Scaffold(
      appBar: AppBar(
        title: Text(currentExercise?.name ?? "Exercise name"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Hero(
            tag: "Progress",
            child: LinearProgressIndicator(value: progress),
          ),
          // Content section
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CardWrapper(
                children: [
                  // Isolate SetBuilder in a Consumer

                  SetBuilder(
                    onNextExercise: () => routineSessionNotifier.nextExercise(),
                    isRunMode: true,
                    completed: currentExerciseSets
                            ?.map((entry) => entry['completed'] as bool)
                            .toList() ??
                        [],
                    sets: currentExerciseSets
                            ?.map((entry) => entry['set'] as ExerciseSet)
                            .toList() ??
                        [],
                  )
                ],
              ),
            ),
          ),
          // Workout Controls with Elapsed Time
          WorkoutControls(
            onPlayPause: () {
              routineSessionNotifier.togglePause();
            },
            onNextExercise: () {
              routineSessionNotifier.nextExercise();
            },
            onPreviousExercise: () {
              routineSessionNotifier.previousExercise();
            },
            onFinishWorkout: () {
              bool result = routineSessionNotifier.finishSession();

              if (result == true) {
                showSnackBar(context, 'Session successfully finished!');
                Navigator.pop(context);
              } else {
                showSnackBar(context,
                    'You must complete all sets before finishing the session.');
              }
            },
            onDiscardWorkout: () {
              routineSessionNotifier.discardSession();
              Navigator.pop(context);
            },
            onViewAllExercises: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExercisePlaylist()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WorkoutControls extends ConsumerStatefulWidget {
  final VoidCallback onPlayPause;
  final VoidCallback onNextExercise;
  final VoidCallback onPreviousExercise;
  final VoidCallback onFinishWorkout;
  final VoidCallback onDiscardWorkout;
  final VoidCallback onViewAllExercises;

  const WorkoutControls({
    super.key,
    required this.onPlayPause,
    required this.onNextExercise,
    required this.onPreviousExercise,
    required this.onFinishWorkout,
    required this.onDiscardWorkout,
    required this.onViewAllExercises,
  });

  @override
  ConsumerState<WorkoutControls> createState() => _WorkoutControlsState();
}

class _WorkoutControlsState extends ConsumerState<WorkoutControls> {
  @override
  Widget build(BuildContext context) {
    final routineSession = ref.watch(routineSessionProvider);
    final isPlaying = routineSession?.isRunning ?? false;
    final timerNotifier = ref.watch(timerProvider);
    final elapsedTimeString =
        timerNotifier.toString().split('.').first.padLeft(8, "0");
    return CardWrapper(
      children: [
        // Elapsed Time Display
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                elapsedTimeString,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onViewAllExercises,
                icon: const Icon(Icons.playlist_play),
              ),
            ],
          ),
        ),
        // Play/Pause Button and Navigation Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: widget.onPreviousExercise,
              iconSize: 30.0,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 60.0,
              onPressed: widget.onPlayPause,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: widget.onNextExercise,
              iconSize: 30.0,
            ),
          ],
        ),
        // Finish/Discard Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: widget.onFinishWorkout,
              child: const Text('Finish Workout'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: widget.onDiscardWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Discard Workout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
