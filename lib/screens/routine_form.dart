import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/database/repository/routine_respository.dart';
import 'package:muon_workout_tracker/screens/select_exercise.dart';
import 'package:muon_workout_tracker/shared/snackbar.dart';

class RoutineForm extends ConsumerStatefulWidget {
  final Routine? routine;

  const RoutineForm({super.key, this.routine});

  @override
  RoutineFormState createState() => RoutineFormState();
}

class RoutineFormState extends ConsumerState<RoutineForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late String _name;
  List<Exercise> selectedExercises = []; // To hold the selected routines

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      _name = widget.routine!.name;
      initializeSelectedExercises();
    } else {
      _name = '';
    }
  }

  Future<void> initializeSelectedExercises() async {
    if (widget.routine != null) {
      // Load the routine linked to the exercises
      await widget.routine!.exercises.load();

      // Create a map to quickly access routines by their ID
      final exerciseMap = {
        for (var routine in widget.routine!.exercises) routine.id: routine
      };

      // Create a list to store the routines in the correct order
      List<Exercise> sortedExercises = [];

      // Add routines in the order specified by orderedRoutineIds
      for (int exerciseId in widget.routine!.orderedExerciseIds) {
        if (exerciseMap.containsKey(exerciseId)) {
          sortedExercises.add(exerciseMap[exerciseId]!);
        }
      }

      // Initialize selectedRoutines with the sorted list
      setState(() {
        selectedExercises = sortedExercises;
      });
    }
  }

  Future<void> _submit(RoutineRepository routineRepo) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (selectedExercises.isEmpty) {
        showSnackBar(context, 'Please select at least one exercise');
        return;
      } else {
        var routine = Routine();
        if (widget.routine != null) {
          routine.id = widget.routine!.id;
          routine.lastRun = widget.routine!.lastRun;
        } else {
          routine.lastRun = DateTime.now();
        }
        routine.name = _name;
        routine.orderedExerciseIds = [];

        // Save the routine with the new order of exercises
        await routineRepo.addRoutine(routine, selectedExercises);

        // Go back to the previous screen
        Navigator.of(context).pop();
      }
    }
  }

  void _openRoutineSelectionScreen() async {
    final result = await Navigator.push<List<Exercise>>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectExerciseScreen(
          alreadySelectedExercises: selectedExercises,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedExercises = result;
      });
    }
  }

  void _removeRoutine(int index) {
    setState(() {
      selectedExercises.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var routineRepo = ref.read(routineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine != null ? 'Edit Routine' : 'Create Routine'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _submit(routineRepo);
        },
        child: const Icon(Icons.save_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: "name",
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) => _name = value!,
              ),
              const SizedBox(height: 20),
              Text('Exercises', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openRoutineSelectionScreen,
                child: const Text('Select Exercise'),
              ),
              const SizedBox(height: 20),
              if (selectedExercises.isNotEmpty) ...[
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: selectedExercises.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = selectedExercises.removeAt(oldIndex);
                        selectedExercises.insert(newIndex, item);
                      });
                    },
                    buildDefaultDragHandles: true,
                    itemBuilder: (context, index) {
                      final routine = selectedExercises[index];
                      return Card(
                        key: ValueKey(routine.id),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(routine.name),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeRoutine(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else
                const Text('No routines selected.'),
            ],
          ),
        ),
      ),
    );
  }
}
