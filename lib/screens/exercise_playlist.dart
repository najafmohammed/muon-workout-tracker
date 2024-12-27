import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';

class ExercisePlaylist extends ConsumerStatefulWidget {
  const ExercisePlaylist({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ExercisePlaylist> createState() => _ExercisePlaylistState();
}

class _ExercisePlaylistState extends ConsumerState<ExercisePlaylist>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Loops the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routineSession = ref.watch(routineSessionProvider);
    final routineSessionNotifier = ref.watch(routineSessionProvider.notifier);

    final exercises = routineSession?.exercises ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Playlist'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final isCurrent = routineSession?.currentExerciseIndex == index;

          return ListTile(
            leading: CircleAvatar(
                backgroundColor: isCurrent
                    ? Colors.green.withOpacity(0.2)
                    : Colors.blueAccent.withOpacity(0.2),
                child: isCurrent
                    ? AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + _controller.value * 0.3,
                            child: const Icon(
                              Icons.play_circle_fill,
                              color: Colors.green,
                            ),
                          );
                        },
                      )
                    : Text('${index + 1}'.toString())),
            title: Text(
              exercise.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.fitness_center, // Replace with an appropriate icon
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(
                    width: 4), // Adds spacing between the icon and text
                Text(
                  exercise.muscleGroup.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                    width:
                        16), // Adds spacing between muscle group and sets info
                const Icon(
                  Icons.access_time_rounded, // Icon to represent sets
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  formatTimeAgo(exercise
                      .lastRun), // Replace with the actual sets field in your data model
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: Text(routineSessionNotifier
                  .getCurrentExerciseSetCount()
                  .toString()),
            ),
            onTap: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
