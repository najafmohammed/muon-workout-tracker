import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/models/exercise_history.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/database/providers/muscle_group_provider.dart';
import 'package:muon_workout_tracker/database/repository/exercise_repository.dart';
import 'package:muon_workout_tracker/shared/set_builder.dart';

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
    } else {
      // Default values for a new exercise
      _name = '';
      _muscleGroup = MuscleGroup.abs; // Default value
    }
  }

  Future<void> _submit(ExerciseRepository exerciseRepo) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Handle submission: create or update exercise
      final formState = _formKey.currentState?.value;

      final set = (formState?['sets']);
      final muscleGroup = formState?['muscleGroup'];
      final name = formState?['name'];
      var history = ExerciseHistory()
        ..date = DateTime.now()
        ..sets = set;
      var exercise = Exercise()
        ..exerciseHistory.add(history)
        ..name = name
        ..lastRun = DateTime.now()
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
      body: SingleChildScrollView(
        child: Padding(
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
      ),
    );
  }
}
