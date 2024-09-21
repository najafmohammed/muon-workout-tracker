import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/screens/exercise_playlist.dart';
import 'package:muon_workout_tracker/shared/set_builder.dart';
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
    final routineSession = ref.watch(routineSessionProvider);
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);
    final elapsedTimeString = routineSessionNotifier.elapsedTime
        .toString()
        .split('.')
        .first
        .padLeft(8, "0");
    final isPlaying = routineSession?.isRunning ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            routineSessionNotifier.currentExercise?.name ?? "Exercise name"),
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
          const Hero(
            tag: "Progress",
            child: LinearProgressIndicator(value: .8),
          ),
          // Content section
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CardWrapper(
                children: [
                  SetBuilder(
                    // setsWithCompletion: routineSession!.exerciseSets.entries
                    //     .toList()[routineSession.currentExerciseIndex],
                    // setsWithCompletion: [],
                    isRunMode: true,
                    onNextExercise: () {
                      routineSessionNotifier.nextExercise();
                    },
                    sets: [],
                  ),
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
              routineSessionNotifier.finishSession();
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
            isPlaying: isPlaying,
            elapsedTime: elapsedTimeString,
          ),
        ],
      ),
    );
  }
}

class WorkoutControls extends StatelessWidget {
  final VoidCallback onPlayPause;
  final VoidCallback onNextExercise;
  final VoidCallback onPreviousExercise;
  final VoidCallback onFinishWorkout;
  final VoidCallback onDiscardWorkout;
  final VoidCallback onViewAllExercises;
  final bool isPlaying; // To toggle between play and pause
  final String elapsedTime; // Elapsed time string

  const WorkoutControls({
    super.key,
    required this.onPlayPause,
    required this.onNextExercise,
    required this.onPreviousExercise,
    required this.onFinishWorkout,
    required this.onDiscardWorkout,
    required this.onViewAllExercises,
    required this.isPlaying,
    required this.elapsedTime,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      children: [
        // Elapsed Time Display
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                elapsedTime,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: onViewAllExercises,
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
              onPressed: onPreviousExercise,
              iconSize: 30.0,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 60.0,
              onPressed: onPlayPause,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: onNextExercise,
              iconSize: 30.0,
            ),
          ],
        ),
        // Finish/Discard Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onFinishWorkout,
              child: const Text('Finish Workout'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: onDiscardWorkout,
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
