import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
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
  int? _selectedIndex; // Track selected index for animation and info display

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
          final isSelected = _selectedIndex == index;
          final setCount = routineSessionNotifier.getExerciseSetCount(index);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedIndex == index) {
                  _selectedIndex = null; // Deselect if already selected
                } else {
                  _selectedIndex = index; // Select the current exercise
                  // Show the modal as a dialog
                  _showModalDialog(context, exercise, index, setCount);
                }
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isSelected
                  // Transform into a modal view
                  ? _buildListTile(exercise, index, isCurrent)
                  : _buildListTile(exercise, index, isCurrent),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile(Exercise exercise, int index, bool isCurrent) {
    return ListTile(
      key: ValueKey<int>(index),
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
            : Text('${index + 1}'),
      ),
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
          const SizedBox(width: 4),
          Text(
            exercise.muscleGroup.name,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.access_time_rounded,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            formatTimeAgo(exercise.lastRun),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.info),
    );
  }

  void _showModalDialog(
      BuildContext context, Exercise exercise, int index, int setCount) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow the user to dismiss the dialog
      builder: (BuildContext context) {
        return Dialog(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit the content dynamically
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Space between
                      children: [
                        const Text(
                          'Muscle Group:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          exercise.muscleGroup.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Space between
                      children: [
                        const Text(
                          'Last Run:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          formatTimeAgo(exercise.lastRun),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Space between
                      children: [
                        const Text(
                          'Set Count:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '$setCount',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  exercise.note?.isNotEmpty == true
                      ? exercise.note!
                      : "No notes found for this exercise.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment:
                      Alignment.bottomCenter, // Close button at the bottom
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the modal when done
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
