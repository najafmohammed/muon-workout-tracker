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
  late Map<int, String> selectedTags;

  @override
  void initState() {
    super.initState();
    final routineSession = ref.read(routineSessionProvider);
    selectedTags = {
      for (int i = 0; i < (routineSession?.exercises.length ?? 0); i++)
        i: routineSession?.tag[i] ?? "Same",
    };
  }

  @override
  Widget build(BuildContext context) {
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);
    final routineSession = ref.watch(routineSessionProvider);
    final currentExercise = routineSessionNotifier.currentExercise;
    final progress = routineSession?.progress ?? 0.0;
    final currentExerciseSets =
        routineSessionNotifier.exerciseSets[currentExercise];
    final currentIndex = routineSession?.currentExerciseIndex ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Hero(
            tag: "CurrentExerciseName",
            child: Text(currentExercise?.name ?? "Exercise name")),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Progress Indicator
          Column(
            children: [
              Hero(
                tag: "Progress",
                child: LinearProgressIndicator(value: progress),
              ),

              // Content section
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: CardWrapper(
                  children: [
                    SetBuilder(
                      onNextExercise: () =>
                          routineSessionNotifier.nextExercise(),
                      isRunMode: true,
                      completed: currentExerciseSets
                              ?.map((entry) => entry['completed'] as bool)
                              .toList() ??
                          [],
                      sets: currentExerciseSets
                              ?.map((entry) => entry['set'] as ExerciseSet)
                              .toList() ??
                          [],
                    ),
                    Column(
                      children: [
                        const Divider(),
                        const Center(
                          child: Text(
                            "Tag for next workout",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Previous tag display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                "Previous Tag",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                routineSessionNotifier.getPrevTag(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _getTagColor(
                                      routineSessionNotifier.getPrevTag()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Next tag selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChoiceChip(
                              label: const Text('Lighter'),
                              selected: selectedTags[currentIndex] == 'Lighter',
                              onSelected: (bool isSelected) {
                                setState(() {
                                  selectedTags[currentIndex] = isSelected
                                      ? 'Lighter'
                                      : selectedTags[currentIndex] ?? "Same";
                                  routineSessionNotifier.updateTag(currentIndex,
                                      selectedTags[currentIndex]!);
                                });
                              },
                              selectedColor: Colors.red[600],
                            ),
                            ChoiceChip(
                              label: const Text('Same'),
                              selected: selectedTags[currentIndex] == 'Same',
                              onSelected: (bool isSelected) {
                                setState(() {
                                  selectedTags[currentIndex] = isSelected
                                      ? 'Same'
                                      : selectedTags[currentIndex] ?? "Same";
                                  routineSessionNotifier.updateTag(currentIndex,
                                      selectedTags[currentIndex]!);
                                });
                              },
                              selectedColor: Colors.blue[600],
                            ),
                            ChoiceChip(
                              label: const Text('Increase'),
                              selected:
                                  selectedTags[currentIndex] == 'Increase',
                              onSelected: (bool isSelected) {
                                setState(() {
                                  selectedTags[currentIndex] = isSelected
                                      ? 'Increase'
                                      : selectedTags[currentIndex] ?? "Same";
                                  routineSessionNotifier.updateTag(currentIndex,
                                      selectedTags[currentIndex]!);
                                });
                              },
                              selectedColor: Colors.green[600],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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

Color _getTagColor(String tag) {
  switch (tag) {
    case 'Lighter':
      return Colors.red[600]!;
    case 'Same':
      return Colors.blue[600]!;
    case 'Increase':
      return Colors.green[600]!;
    default:
      return Colors.grey; // Fallback color if the tag doesn't match
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
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);
    final isPlaying = routineSession?.isRunning ?? false;
    final timerNotifier = ref.watch(timerProvider);
    final elapsedTimeString =
        timerNotifier.toString().split('.').first.padLeft(8, "0");
    return CardWrapper(
      children: [
        // Elapsed Time Display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              elapsedTimeString,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: widget.onViewAllExercises,
              icon: const Icon(Icons.playlist_play),
            ),
          ],
        ),
        // Play/Pause Button and Navigation Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: routineSessionNotifier.getWorkoutPosition() ==
                      WorkoutPosition.start
                  ? null
                  : widget.onPreviousExercise,
              iconSize: 30.0,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 60.0,
              onPressed: widget.onPlayPause,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: routineSessionNotifier.getWorkoutPosition() ==
                      WorkoutPosition.end
                  ? null
                  : widget.onNextExercise,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(.2),
              ),
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
