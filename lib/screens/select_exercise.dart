import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/utils/get_sort_icon.dart';

class SelectExerciseScreen extends ConsumerStatefulWidget {
  const SelectExerciseScreen({
    Key? key,
    required this.alreadySelectedExercises,
  }) : super(key: key);

  final List<Exercise> alreadySelectedExercises;

  @override
  _SelectExerciseScreenState createState() => _SelectExerciseScreenState();
}

class _SelectExerciseScreenState extends ConsumerState<SelectExerciseScreen> {
  List<Exercise> _selectedExercises = [];
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  String sortBy = 'name_asc'; // Default sorting option

  bool _isExerciseSelected(Exercise exercise) {
    return _selectedExercises.any((e) => e.id == exercise.id);
  }

  void _toggleExerciseSelection(Exercise exercise) {
    setState(() {
      if (_isExerciseSelected(exercise)) {
        _selectedExercises.removeWhere((e) => e.id == exercise.id);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedExercises = widget.alreadySelectedExercises;
  }

  @override
  Widget build(BuildContext context) {
    final exerciseRepo = ref.watch(exerciseProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercises'),
      ),
      body: Column(
        children: [
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
                hintText: 'Search items',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  ],
                ),
                Icon(Icons.sort, size: 24, color: theme.iconTheme.color),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: exerciseRepo.getAllExercisesFiltered(
                nameFilter: nameFilter,
                sortBy: sortBy,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Exercises Found'));
                } else {
                  final exercises = snapshot.data!;

                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final isSelected = _isExerciseSelected(exercise);

                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(exercise.muscleGroup.name),
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            _toggleExerciseSelection(exercise);
                          },
                        ),
                        onTap: () {
                          _toggleExerciseSelection(exercise);
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
      floatingActionButton: _selectedExercises.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                // Pass back the selected exercises to the previous screen
                Navigator.pop(context, _selectedExercises);
              },
              label: const Text('DONE'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
