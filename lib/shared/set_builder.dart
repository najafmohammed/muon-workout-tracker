import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/exercise_set.dart';

class SetBuilder extends ConsumerStatefulWidget {
  final List<ExerciseSet> sets;
  final bool isRunMode; // Determine if it's in run mode or creation mode
  final VoidCallback? onNextExercise; // Callback when all sets are completed

  const SetBuilder({
    super.key,
    required this.sets,
    this.isRunMode = false, // Defaults to creation mode
    this.onNextExercise,
  });

  @override
  _SetBuilderState createState() => _SetBuilderState();
}

class _SetBuilderState extends ConsumerState<SetBuilder> {
  List<bool> completedSets = [];

  @override
  void initState() {
    super.initState();
    // Initialize the completedSets list with false values for each set
    completedSets = List<bool>.filled(widget.sets.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<ExerciseSet>>(
      name: 'sets',
      initialValue: widget.sets
          .map((e) => ExerciseSet()
            ..setNumber = e.setNumber
            ..weight = e.weight
            ..reps = e.reps)
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please add at least one set.';
        }
        return null;
      },
      builder: (FormFieldState<List<ExerciseSet>> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid layout for the header
            GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 3,
              ),
              children: const [
                Center(child: Text('Set', style: AppTextStyle.medium)),
                Center(child: Text('Weight', style: AppTextStyle.medium)),
                Center(child: Text('Reps', style: AppTextStyle.medium)),
                SizedBox.shrink(), // Empty for delete button/checkbox column
              ],
            ),
            const SizedBox(height: 10),
            // Grid layout for each set
            for (int i = 0; i < field.value!.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3,
                  ),
                  children: [
                    // Display the set number
                    Center(child: Text('${i + 1}')),

                    // Weight Input
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        initialValue: field.value![i].weight.toString(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) {
                          field.value![i].weight = double.parse(value);
                          field.didChange(field.value);
                        },
                      ),
                    ),

                    // Reps Input
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        initialValue: field.value![i].reps.toString(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          field.value![i].reps = int.parse(value);
                          field.didChange(field.value);
                        },
                      ),
                    ),

                    // Action: Delete in creation mode, Checkbox in run mode
                    Center(
                      child: widget.isRunMode
                          ? Checkbox(
                              value: completedSets[i],
                              onChanged: (bool? value) {
                                setState(() {
                                  completedSets[i] = value ?? false;
                                });

                                // If all sets are completed, trigger onNextExercise
                                if (completedSets
                                    .every((completed) => completed)) {
                                  widget.onNextExercise?.call();
                                }
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Remove the set and its completion state
                                final updatedSets =
                                    List<ExerciseSet>.from(field.value!);
                                updatedSets.removeAt(i);
                                field.didChange(updatedSets);

                                setState(() {
                                  completedSets.removeAt(i);
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Add Set Button (only visible in creation mode)
            if (!widget.isRunMode)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final updatedSets = List<ExerciseSet>.from(field.value!);
                    updatedSets.add(ExerciseSet()
                      ..setNumber = updatedSets.length + 1
                      ..weight = 0
                      ..reps = 0);
                    field.didChange(updatedSets);

                    setState(() {
                      completedSets.add(false); // Add a new checkbox state
                    });
                  },
                  child: const Text('Add Set'),
                ),
              ),
          ],
        );
      },
    );
  }
}
