import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart'; // Assume you have an exercise provider

class ExerciseStatsScreen extends ConsumerStatefulWidget {
  const ExerciseStatsScreen({super.key});

  @override
  _ExerciseStatsScreenState createState() => _ExerciseStatsScreenState();
}

class _ExerciseStatsScreenState extends ConsumerState<ExerciseStatsScreen> {
  late PageController _pageController; // Declare the PageController
  int _currentIndex = 0; // Initialize current index
  List<Exercise>? _exercises; // To store the exercises

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
    _fetchExercises(); // Fetch exercises on init
  }

  Future<void> _fetchExercises() async {
    final exerciseRepo = ref.read(exerciseProvider);
    try {
      _exercises = await exerciseRepo.getAllExercises();
      setState(() {}); // Trigger a rebuild to update the UI
    } catch (error) {
      print('Error fetching exercises: $error');
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_exercises == null) {
      // Show loading indicator while fetching
      return Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Stats'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If there's an error or no exercises
    if (_exercises!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Stats'),
        ),
        body: const Center(child: Text('No Exercises Available')),
      );
    }

    final totalExercises = _exercises!.length;

    // Find the most performed exercise
    final mostUsedExercise = _exercises!
        .reduce((curr, next) => curr.count > next.count ? curr : next);

    // Find the last performed exercise
    final lastRunExercise = _exercises!.reduce((curr, next) =>
        curr.lastRun != null &&
                next.lastRun != null &&
                curr.lastRun!.isAfter(next.lastRun!)
            ? curr
            : next);

    // Sort exercises by usage count to get the top 3
    _exercises!.sort((a, b) => b.count.compareTo(a.count));
    final topThreeExercises = _exercises!.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Exercises
            StatCard(
              title: 'Total Exercises',
              value: totalExercises.toString(),
              icon: Icons.fitness_center,
            ),
            const SizedBox(height: 8),

            // Most Used Exercise
            StatCard(
              title: 'Most Used Exercise',
              value:
                  '${mostUsedExercise.name} (${mostUsedExercise.count} times)',
              icon: Icons.repeat,
            ),
            const SizedBox(height: 8),

            // Last Performed Exercise
            StatCard(
              title: 'Last Performed Exercise',
              value:
                  '${lastRunExercise.name} (${lastRunExercise.lastRun != null ? lastRunExercise.lastRun!.toLocal().toString().split(' ')[0] : 'Never'})',
              icon: Icons.schedule,
            ),
            const SizedBox(height: 8),

            // Top 3 Exercises Section Header
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Top 3 Exercises",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Top 3 Exercises Carousel with Page Indicator
            SizedBox(
              height: 370, // Fixed height for the carousel
              child: PageView.builder(
                controller: _pageController, // Attach controller
                itemCount: topThreeExercises.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Update current index
                  });
                },
                itemBuilder: (context, index) {
                  final exercise = topThreeExercises[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Muscle Group: ${exercise.muscleGroup.name}'),
                          const SizedBox(height: 4),
                          Text('Performed: ${exercise.count} times'),
                          const SizedBox(height: 4),
                          Text(
                              'Last Run: ${exercise.lastRun != null ? exercise.lastRun!.toLocal().toString().split(' ')[0] : 'Never'}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(topThreeExercises.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.blue
                        : Colors.grey, // Update indicator color
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
