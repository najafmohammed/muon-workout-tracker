import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';
import 'package:muon_workout_tracker/shared/snackbar.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';

class Schedule extends ConsumerStatefulWidget {
  const Schedule({super.key});

  @override
  ScheduleState createState() => ScheduleState();
}

class ScheduleState extends ConsumerState<Schedule> {
  List<Routine> routines = [];
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final userSettings = ref.read(userSettingsProvider);
    final currentSplit = userSettings?.currentSplit;
    final splitRepoNotif = ref.read(splitProvider);

    if (currentSplit != null) {
      final loadedRoutines = await splitRepoNotif
          .getOrderedRoutinesFromSplit(currentSplit.value as Split);

      setState(() {
        routines = loadedRoutines;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!hasChanges) return;

    final userSettings = ref.read(userSettingsProvider);
    final currentSplit = userSettings?.currentSplit;
    if (currentSplit == null) {
      showSnackBar(context, 'No split found to update.');
      return;
    }
    final splitRepo = ref.read(splitProvider);
    final split = currentSplit.value as Split;
    split.orderedRoutineIds = routines.map((routine) => routine.id).toList();

    await splitRepo.updateSplit(split);
    showSnackBar(context, 'Changes saved successfully!');

    setState(() {
      hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.read(userSettingsProvider);
    final currentRoutineIndex = userSettings?.currentRoutineIndex;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      floatingActionButton: hasChanges
          ? FloatingActionButton(
              onPressed: _saveChanges,
              child: const Icon(Icons.save_rounded),
            )
          : null,
      body: routines.isEmpty
          ? const Center(child: Text('No routines found.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Up Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Display "Up Next" routine (index 1)
                  if (routines.length > 1)
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.workspaces_filled),
                      ),
                      title: Text(routines[1].name),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time Ago with Icon
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 4),
                              Text(formatTimeAgo(routines[1].lastRun)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.repeat, size: 16),
                              const SizedBox(width: 4),
                              Text('${routines[1].frequency} times'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: routines.length,
                      key: const ValueKey("s"),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = routines.removeAt(oldIndex);
                          routines.insert(newIndex, item);

                          hasChanges = true;
                        });
                      },
                      onReorderEnd: (_) {
                        setState(() {
                          // Trigger re-render to update "Up Next"
                        });
                      },
                      buildDefaultDragHandles: true,
                      itemBuilder: (context, index) {
                        return _buildRoutineCard(
                            routines[index], index == currentRoutineIndex);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRoutineCard(Routine routine, bool isNextWorkout) {
    return Card(
      key: ValueKey(routine.id),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: isNextWorkout ? Colors.green : null,
      child: ListTile(
        title: Text(
          routine.name,
          style: TextStyle(
            fontWeight: isNextWorkout ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        leading: ReorderableDragStartListener(
          index: routines.indexOf(routine),
          child: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
