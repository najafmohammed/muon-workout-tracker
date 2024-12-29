import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/shared/muscle_group_split.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';

class RoutineStatsScreen extends ConsumerStatefulWidget {
  const RoutineStatsScreen({super.key});

  @override
  _RoutineStatsScreenState createState() => _RoutineStatsScreenState();
}

class _RoutineStatsScreenState extends ConsumerState<RoutineStatsScreen> {
  late PageController _pageController; // Declare the PageController
  int _currentIndex = 0; // Initialize current index
  List<Routine>? _routines; // To store the routines

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
    _fetchRoutines(); // Fetch routines on init
  }

  Future<void> _fetchRoutines() async {
    final routineRepo = ref.read(routineProvider);
    try {
      _routines = await routineRepo.getAllRoutines();
      setState(() {}); // Trigger a rebuild to update the UI
    } catch (error) {
      // Handle error (you can show a message or log it)
      print('Error fetching routines: $error');
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_routines == null) {
      // Show loading indicator while fetching
      return Scaffold(
        appBar: AppBar(
          title: const Text('Routine Stats'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If there's an error or no routines
    if (_routines!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Routine Stats'),
        ),
        body: const Center(child: Text('No Routines Available')),
      );
    }

    final totalRoutines = _routines!.length;

    // Find the most used routine
    final mostUsedRoutine = _routines!
        .reduce((curr, next) => curr.frequency > next.frequency ? curr : next);

    // Find the last run routine
    final lastRunRoutine = _routines!.reduce((curr, next) =>
        curr.lastRun != null &&
                next.lastRun != null &&
                curr.lastRun!.isAfter(next.lastRun!)
            ? curr
            : next);

    // Sort routines by frequency to get the top 3
    _routines!.sort((a, b) => b.frequency.compareTo(a.frequency));
    final topThreeRoutines = _routines!.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Routines
            StatCard(
              title: 'Total Routines',
              value: totalRoutines.toString(),
              icon: Icons.fitness_center,
            ),
            const SizedBox(height: 8),

            // Most Used Routine
            StatCard(
              title: 'Most Used Routine',
              value:
                  '${mostUsedRoutine.name} (${mostUsedRoutine.frequency} times)',
              icon: Icons.repeat,
            ),
            const SizedBox(height: 8),

            // Last Run Routine
            StatCard(
              title: 'Last Run Routine',
              value:
                  '${lastRunRoutine.name} (${formatTimeAgo(lastRunRoutine.lastRun!)})',
              icon: Icons.schedule,
            ),
            const SizedBox(height: 8),

            // Top 3 Routines Section Header
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Top 3 Routines",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Top 3 Routines Carousel with Page Indicator
            SizedBox(
              height: 370, // Fixed height for the carousel
              child: PageView.builder(
                controller: _pageController, // Attach controller
                itemCount: topThreeRoutines.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Update current index
                  });
                },
                itemBuilder: (context, index) {
                  final routine = topThreeRoutines[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routine.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Frequency: ${routine.frequency} times'),
                          const SizedBox(height: 4),
                          Text(
                            'Last Run: ${formatTimeAgo(routine.lastRun!)}',
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: MuscleGroupSplit(routine: routine),
                          ),
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
              children: List.generate(topThreeRoutines.length, (index) {
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
