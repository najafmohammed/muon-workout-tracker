import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';
import 'package:muon_workout_tracker/utils/get_sort_icon.dart';

class SelectRoutineScreen extends ConsumerStatefulWidget {
  const SelectRoutineScreen({
    Key? key,
    required this.alreadySelectedRoutines,
  }) : super(key: key);

  final List<Routine> alreadySelectedRoutines;

  @override
  _SelectRoutineScreenState createState() => _SelectRoutineScreenState();
}

class _SelectRoutineScreenState extends ConsumerState<SelectRoutineScreen> {
  List<Routine> _selectedRoutines = [];
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  String sortBy = 'Name'; // Default sorting criteria
  final List<String> sortOptions = ['Name', 'Last Run'];

  @override
  void initState() {
    super.initState();
    _selectedRoutines = widget.alreadySelectedRoutines;
  }

  bool _isRoutineSelected(Routine routine) {
    return _selectedRoutines.any((e) => e.id == routine.id);
  }

  void _toggleRoutineSelection(Routine routine) {
    setState(() {
      if (_isRoutineSelected(routine)) {
        _selectedRoutines.removeWhere((e) => e.id == routine.id);
      } else {
        _selectedRoutines.add(routine);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routineRepo = ref.watch(routineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Routines'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar and Sorting
            TextField(
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
            const SizedBox(width: 8),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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

            Expanded(
              child: StreamBuilder<List<Routine>>(
                stream: routineRepo.getAllRoutinesFiltered(
                    nameFilter: nameFilter, sortBy: sortBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Routines Found'));
                  } else {
                    final routines = snapshot.data!;
                    return ListView.builder(
                      itemCount: routines.length,
                      itemBuilder: (context, index) {
                        final routine = routines[index];
                        final isSelected = _isRoutineSelected(routine);

                        return ListTile(
                          title: Text(
                            routine.name,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Last Run: ${formatTimeAgo(routine.lastRun)}',
                            style: theme.textTheme.bodySmall,
                          ),
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              _toggleRoutineSelection(routine);
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                          onTap: () {
                            _toggleRoutineSelection(routine);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedRoutines.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                // Pass back the selected routines
                Navigator.pop(context, _selectedRoutines);
              },
              label: const Text('DONE'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
