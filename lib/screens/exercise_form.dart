import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/providers/exercise_history_provider.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/database/providers/muscle_group_provider.dart';
import 'package:muon_workout_tracker/database/repository/exercise_history_repository.dart';
import 'package:muon_workout_tracker/database/repository/exercise_repository.dart';

class ExerciseForm extends ConsumerStatefulWidget {
  final Exercise? exercise; // Pass the exercise if editing, null if creating

  const ExerciseForm({super.key, this.exercise});

  @override
  ExerciseFormState createState() => ExerciseFormState();
}

class ExerciseFormState extends ConsumerState<ExerciseForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late String _name;
  late MuscleGroup _muscleGroup;
  late double _increment;
  List<ExerciseSet> sets = [];

  // Add a new set with default weight and reps
  void _addSet() {
    setState(() {
      sets.add(ExerciseSet()
        ..setNumber = sets.length + 1
        ..weight = 0
        ..reps = 0);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      setState(() {
        sets.addAll(widget.exercise!.exerciseHistory.last.sets);
      });
    } else {
      _addSet();
    }
    if (widget.exercise != null) {
      // Initialize form fields with existing exercise data
      _name = widget.exercise!.name;
      _muscleGroup = widget.exercise!.muscleGroup;
      _increment = widget.exercise!.increment;
    } else {
      // Default values for a new exercise
      _name = '';
      _muscleGroup = MuscleGroup.abs; // Default value
      _increment = 5;
    }
  }

  Future<void> _submit(ExerciseRepository exerciseRepo) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Handle submission: create or update exercise
      final formState = _formKey.currentState?.value;

      final set = (formState?['sets']);
      final increment = double.parse(formState?['increment']);
      final muscleGroup = formState?['muscleGroup'];
      final name = formState?['name'];
      var history = ExerciseHistory()
        ..date = DateTime.now()
        ..sets = set;
      var exercise = Exercise()
        ..exerciseHistory.add(history)
        ..name = name
        ..lastRun = DateTime.now()
        ..increment = increment
        ..muscleGroup = muscleGroup;
      if (widget.exercise != null) {
        exercise.id = widget.exercise!.id;
        history.id = widget.exercise!.exerciseHistory.last.id;
        await exerciseRepo.updateExercise(exercise, history);
      } else {
        await exerciseRepo.addExercise(exercise, history);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var dropdown = ref.read(muscleGroupsProvider);
    var exerciseRepo = ref.read(exerciseProvider);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.exercise != null ? 'Edit Exercise' : 'Create Exercise'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _submit(exerciseRepo);
        },
        child: const Icon(Icons.save_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
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
              FormBuilderDropdown<MuscleGroup>(
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'muscleGroup',
                  initialValue: _muscleGroup,
                  decoration: const InputDecoration(
                    labelText: 'Muscle Group',
                  ),
                  items: dropdown
                      .map((e) => DropdownMenuItem(
                            value: e.value,
                            child: Text(e.name),
                          ))
                      .toList()),
              FormBuilderTextField(
                name: "increment",
                initialValue: _increment.toString(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, // No decimal point
                ),
                decoration: const InputDecoration(labelText: 'Increment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) => _name = value!,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.exercise != null
                      ? "Edit last Sets"
                      : "Add initial sets",
                  style: AppTextStyle.large,
                ),
              ),
              SetBuilder(sets: sets)
            ],
          ),
        ),
      ),
    );
  }
}

class SetBuilder extends StatelessWidget {
  const SetBuilder({
    super.key,
    required this.sets,
  });

  final List<ExerciseSet> sets;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<ExerciseSet>>(
      name: 'sets',
      initialValue: sets
          .map((e) => ExerciseSet()
            ..setNumber = e.setNumber
            ..weight = e.weight
            ..reps = e.reps)
          .toList(),
      validator: (value) {
        // Validate that the list is not empty and all sets have valid values
        if (value == null || value.isEmpty) {
          return 'Please add at least one set.';
        }
        // for (var set in value) {
        //   if (set.weight < 0) {
        //     return 'Weight must be greater than 0 for each set.';
        //   }
        //   if (set.reps < 0) {
        //     return 'Reps must be greater than 0 for each set.';
        //   }
        // }
        return null; // Return null if validation passes
      },
      builder: (FormFieldState<List<ExerciseSet>> field) {
        return Column(
          children: [
            for (int i = 0; i < field.value!.length; i++)
              Row(
                children: [
                  Text('Set ${field.value![i].setNumber}'),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      initialValue: field.value![i].weight.toString(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      decoration:
                          const InputDecoration(labelText: 'Weight (kg)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        field.value![i] = field.value![i]
                          ..weight = double.parse(value);
                        field.didChange(field.value);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      initialValue: field.value![i].reps.toString(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      decoration: const InputDecoration(labelText: 'Reps'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        field.value![i] = field.value![i]
                          ..reps = int.parse(value);
                        field.didChange(field.value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      field.value!.removeAt(i);
                      field.didChange(field.value);
                    },
                  ),
                ],
              ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                field.value!.add(ExerciseSet()
                  ..setNumber = field.value!.length + 1
                  ..weight = 0
                  ..reps = 0);
                field.didChange(field.value);
              },
              child: const Text('Add Set'),
            ),
          ],
        );
      },
    );
  }
}
