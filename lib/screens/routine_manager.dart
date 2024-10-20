import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/screens/routine_form.dart';
import 'package:muon_workout_tracker/shared/confirm_dialog.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';

class RoutineManager extends ConsumerStatefulWidget {
  const RoutineManager({super.key});

  @override
  ExerciseManagerState createState() => ExerciseManagerState();
}

class ExerciseManagerState extends ConsumerState<RoutineManager> {
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<List<Routine>>(
                stream:
                    routineRepo.getAllRoutinesFiltered(nameFilter: nameFilter),
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
                          leading: const CircleAvatar(
                            child: Icon(Icons.fitness_center),
                          ),
                          title: Text(
                            routine.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height:
                                      4), // Add some space between title and details
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Last Run: ${formatTimeAgo(routine.lastRun)}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height: 4), // Space between details
                              Row(
                                children: [
                                  const Icon(Icons.repeat,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Frequency: ${routine.frequency}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          dense: true,
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
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
            )
          ],
        ));
  }
}
