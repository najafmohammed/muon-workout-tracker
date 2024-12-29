import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/screens/routine_form.dart';
import 'package:muon_workout_tracker/shared/confirm_dialog.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';
import 'package:muon_workout_tracker/utils/get_sort_icon.dart';

class RoutineManager extends ConsumerStatefulWidget {
  const RoutineManager({super.key});

  @override
  RoutineManagerState createState() => RoutineManagerState();
}

class RoutineManagerState extends ConsumerState<RoutineManager> {
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  String sortBy = 'name_asc'; // Default sorting option

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routineRepo = ref.watch(routineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Routines'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RoutineForm()),
          );
        },
        label: const Text("Create Routine"),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  nameFilter = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search routines',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          // Sort Mechanism
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        sortBy =
                            sortBy == 'name_asc' ? 'name_desc' : 'name_asc';
                      }),
                      child: Chip(
                        backgroundColor: sortBy.startsWith('name')
                            ? theme.colorScheme.primary.withOpacity(0.2)
                            : theme.colorScheme.surface,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                color: sortBy.startsWith('name')
                                    ? theme.colorScheme.primary
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              getSortIcon(sortBy.startsWith('name')
                                  ? sortBy
                                  : 'name_asc'),
                              size: 16,
                              color: sortBy.startsWith('name')
                                  ? theme.colorScheme.primary
                                  : theme.iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        sortBy =
                            sortBy == 'date_asc' ? 'date_desc' : 'date_asc';
                      }),
                      child: Chip(
                        backgroundColor: sortBy.startsWith('date')
                            ? theme.colorScheme.primary.withOpacity(0.2)
                            : theme.colorScheme.surface,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                color: sortBy.startsWith('date')
                                    ? theme.colorScheme.primary
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              getSortIcon(sortBy.startsWith('date')
                                  ? sortBy
                                  : 'date_asc'),
                              size: 16,
                              color: sortBy.startsWith('date')
                                  ? theme.colorScheme.primary
                                  : theme.iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        sortBy =
                            sortBy == 'freq_asc' ? 'freq_desc' : 'freq_asc';
                      }),
                      child: Chip(
                        backgroundColor: sortBy.startsWith('freq')
                            ? theme.colorScheme.primary.withOpacity(0.2)
                            : theme.colorScheme.surface,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Frequency',
                              style: TextStyle(
                                color: sortBy.startsWith('freq')
                                    ? theme.colorScheme.primary
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              getSortIcon(sortBy.startsWith('freq')
                                  ? sortBy
                                  : 'freq_asc'),
                              size: 16,
                              color: sortBy.startsWith('freq')
                                  ? theme.colorScheme.primary
                                  : theme.iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.sort, size: 24, color: theme.iconTheme.color),
              ],
            ),
          ),
          // Routine List
          Expanded(
            child: StreamBuilder<List<Routine>>(
              stream: routineRepo.getAllRoutinesFiltered(
                nameFilter: nameFilter,
                sortBy: sortBy,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Routines Found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final routine = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.fitness_center,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          routine.name,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: theme.iconTheme.color),
                                const SizedBox(width: 4),
                                Text(
                                  'Last Run: ${formatTimeAgo(routine.lastRun)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.repeat,
                                    size: 16, color: theme.iconTheme.color),
                                const SizedBox(width: 4),
                                Text(
                                  'Frequency: ${routine.frequency}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: theme.iconTheme.color),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoutineForm(
                                            routine: routine,
                                          )),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ConfirmDialog(
                                      title: 'Delete Routine',
                                      message:
                                          'Are you sure you want to delete this routine?',
                                      onConfirm: () {
                                        routineRepo.deleteRoutine(routine.id);
                                      },
                                      onCancel: () {},
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
