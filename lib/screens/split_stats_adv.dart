import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart'; // Assume you have a split provider

class SplitStatsScreen extends ConsumerStatefulWidget {
  const SplitStatsScreen({super.key});

  @override
  _SplitStatsScreenState createState() => _SplitStatsScreenState();
}

class _SplitStatsScreenState extends ConsumerState<SplitStatsScreen> {
  late PageController _pageController; // Declare the PageController
  int _currentIndex = 0; // Initialize current index
  List<Split>? _splits; // To store the splits

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
    _fetchSplits(); // Fetch splits on init
  }

  Future<void> _fetchSplits() async {
    final splitRepo = ref.read(splitProvider);
    try {
      _splits = await splitRepo
          .getAllSplits(); // Assuming this is your provider method
      setState(() {}); // Trigger a rebuild to update the UI
    } catch (error) {
      // Handle error (you can show a message or log it)
      print('Error fetching splits: $error');
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_splits == null) {
      // Show loading indicator while fetching
      return Scaffold(
        appBar: AppBar(
          title: const Text('Split Stats'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If there's an error or no splits
    if (_splits!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Split Stats'),
        ),
        body: const Center(child: Text('No Splits Available')),
      );
    }

    final totalSplits = _splits!.length;

    // Find the split with the most routines
    final mostUsedSplit = _splits!.reduce((curr, next) =>
        curr.routines.length > next.routines.length ? curr : next);

    // Find the last used split (assuming nextIndex shows the most recent progress)
    final lastUsedSplit = _splits!
        .reduce((curr, next) => curr.nextIndex > next.nextIndex ? curr : next);

    // Sort splits by number of routines to get the top 3
    _splits!.sort((a, b) => b.routines.length.compareTo(a.routines.length));
    final topThreeSplits = _splits!.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Splits
            StatCard(
              title: 'Total Splits',
              value: totalSplits.toString(),
              icon: Icons.dashboard,
            ),
            const SizedBox(height: 8),

            // Split with Most Routines
            StatCard(
              title: 'Most Used Split',
              value:
                  '${mostUsedSplit.name} (${mostUsedSplit.routines.length} routines)',
              icon: Icons.repeat,
            ),
            const SizedBox(height: 8),

            // Last Used Split
            StatCard(
              title: 'Last Used Split',
              value:
                  '${lastUsedSplit.name} (Index: ${lastUsedSplit.nextIndex})',
              icon: Icons.schedule,
            ),
            const SizedBox(height: 8),

            // Top 3 Splits Section Header
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Top 3 Splits",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Top 3 Splits Carousel with Page Indicator
            SizedBox(
              height: 370, // Fixed height for the carousel
              child: PageView.builder(
                controller: _pageController, // Attach controller
                itemCount: topThreeSplits.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Update current index
                  });
                },
                itemBuilder: (context, index) {
                  final split = topThreeSplits[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            split.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Routines: ${split.routines.length}'),
                          const SizedBox(height: 4),
                          Text(
                            'Last Index: ${split.nextIndex}',
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "Routines",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: split.routines.length,
                              itemBuilder: (context, routineIndex) {
                                final routine =
                                    split.routines.toList()[routineIndex];
                                return ListTile(
                                  title: Text(routine.name),
                                  leading: const Icon(Icons.fitness_center),
                                  trailing: Text(
                                      "exercises ${routine.exercises.length.toString()}"),
                                );
                              },
                            ),
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
              children: List.generate(topThreeSplits.length, (index) {
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
