import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';
import 'package:muon_workout_tracker/database/providers/exercise_provider.dart';
import 'package:muon_workout_tracker/screens/exercise_form.dart';
import 'package:muon_workout_tracker/shared/confirm_dialog.dart';

class ExerciseManager extends ConsumerStatefulWidget {
  const ExerciseManager({super.key});

  @override
  ExerciseManagerState createState() => ExerciseManagerState();
}

class ExerciseManagerState extends ConsumerState<ExerciseManager> {
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  @override
  Widget build(BuildContext context) {
    final exerciseRepo = ref.watch(exerciseProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Exercises'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExerciseForm()),
              );
            },
            label: const Text("Create Exercise"),
            icon: const Icon(Icons.add)),
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
                stream: exerciseRepo.getAllExercisesFiltered(
                    nameFilter: nameFilter),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Exercises Found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final exercise = snapshot.data![index];
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.fitness_center),
                          ),
                          title: Text(exercise.name),
                          subtitle: Text(exercise.muscleGroup.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExerciseForm(
                                              exercise: exercise,
                                            )),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmDialog(
                                        title: 'Delete Item',
                                        message:
                                            'Are you sure you want to delete this item?',
                                        onConfirm: () {
                                          exerciseRepo
                                              .deleteExercise(exercise.id);
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
            )
          ],
        ));
  }
}
