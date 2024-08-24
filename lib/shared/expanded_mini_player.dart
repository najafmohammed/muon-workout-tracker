import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/screens/exercise_form.dart';
import 'package:muon_workout_tracker/shared/confirm_dialog.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class ExpandedMiniPlayer extends StatefulWidget {
  const ExpandedMiniPlayer({super.key});

  @override
  State<ExpandedMiniPlayer> createState() => _ExpandedMiniPlayerState();
}

class _ExpandedMiniPlayerState extends State<ExpandedMiniPlayer> {
  List<ExerciseSet> sets = [
    ExerciseSet()
      ..setNumber = 1
      ..reps = 1
      ..weight = 10,
    ExerciseSet()
      ..setNumber = 2
      ..reps = 2
      ..weight = 20,
  ];

  bool _isPlaying = false;
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTime = DateTime.now();
      } else {
        if (_startTime != null) {
          _elapsedTime += DateTime.now().difference(_startTime!);
          _startTime = null;
        }
      }
    });
    // Handle play/pause logic
  }

  void _nextExercise() {
    // Handle going to the next exercise
  }

  void _previousExercise() {
    // Handle going to the previous exercise
  }

  void _finishWorkout() {
    // Handle finishing the workout
  }

  void _discardWorkout() {
    // Handle discarding the workout
  }

  void _viewAllExercises() {
    // Handle viewing all exercises
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTimeString =
        _elapsedTime.toString().split('.').first.padLeft(8, "0");

    return Scaffold(
      appBar: AppBar(
        title: const Text('PUSH'),
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
                    sets: sets,
                    isRunMode: true,
                    onNextExercise: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog(
                            title: 'Delete Item',
                            message:
                                'Are you sure you want to delete this item?',
                            onConfirm: () {},
                            onCancel: () {},
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Workout Controls with Elapsed Time
          WorkoutControls(
            onPlayPause: _togglePlayPause,
            onNextExercise: _nextExercise,
            onPreviousExercise: _previousExercise,
            onFinishWorkout: _finishWorkout,
            onDiscardWorkout: _discardWorkout,
            onViewAllExercises: _viewAllExercises,
            isPlaying: _isPlaying,
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
                '${elapsedTime}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.playlist_play))
            ],
          ),
        ),
        // Play/Pause Button

        // Navigation Controls
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
