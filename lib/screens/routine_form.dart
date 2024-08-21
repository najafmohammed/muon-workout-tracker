import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/database/repository/routine_respository.dart';
import 'package:muon_workout_tracker/screens/select_exercise.dart';

class RoutineForm extends ConsumerStatefulWidget {
  final Routine? routine;

  const RoutineForm({super.key, this.routine});

  @override
  RoutineFormState createState() => RoutineFormState();
}

class RoutineFormState extends ConsumerState<RoutineForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late String _name;
  List<Exercise> selectedExercises = []; // To hold the selected exercises

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      _name = widget.routine!.name;
      selectedExercises = widget.routine!.exercises.map((e) => e).toList();
    } else {
      _name = '';
    }
  }

  Future<void> _submit(RoutineRepository routineRepo) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (selectedExercises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Please select at least one exercise',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).cardColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
              textColor: Colors.white,
            ),
          ),
        );
        return;
      } else {
        var routine = Routine();
        if (widget.routine != null) {
          routine.id = widget.routine!.id;
        }
        routine.name = _name;
        routine.lastRun = DateTime.now();
        routineRepo.addRoutine(routine, selectedExercises);
        // Backend implementation for saving the routine
        Navigator.of(context).pop();
      }
    }
  }

  void _openExerciseSelectionScreen() async {
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

  void _removeExercise(int index) {
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
              Text('Exercises:', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openExerciseSelectionScreen,
                child: const Text('Select Exercises'),
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
                    itemBuilder: (context, index) {
                      final exercise = selectedExercises[index];
                      return ListTile(
                        key: ValueKey(exercise.id),
                        title: Text(exercise.name),
                        subtitle: Text(exercise.muscleGroup.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeExercise(index),
                        ),
                      );
                    },
                  ),
                ),
              ] else
                const Text('No exercises selected.'),
            ],
          ),
        ),
      ),
    );
  }
}
