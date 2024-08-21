import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';

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

  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';

  @override
  Widget build(BuildContext context) {
    final exerciseRepo = ref.watch(exerciseProvider);

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
          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream:
                  exerciseRepo.getAllExercisesFiltered(nameFilter: nameFilter),
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
