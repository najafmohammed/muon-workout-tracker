import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/repository/split_repository.dart';
import 'package:muon_workout_tracker/screens/select_routine.dart';
import 'package:muon_workout_tracker/shared/snackbar.dart';

class SplitForm extends ConsumerStatefulWidget {
  final Split? split;

  const SplitForm({super.key, this.split});

  @override
  SplitFormState createState() => SplitFormState();
}

class SplitFormState extends ConsumerState<SplitForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late String _name;
  List<Routine> selectedRoutines = []; // To hold the selected routines

  @override
  void initState() {
    super.initState();
    if (widget.split != null) {
      _name = widget.split!.name;
      // selectedRoutines = widget.split!.routines.map((e) => e).toList();
      initializeSelectedRoutines();
    } else {
      _name = '';
    }
  }

  Future<void> initializeSelectedRoutines() async {
    if (widget.split != null) {
      // Load the routines linked to the split
      await widget.split!.routines.load();

      // Create a map to quickly access routines by their ID
      final routineMap = {
        for (var routine in widget.split!.routines) routine.id: routine
      };

      // Create a list to store the routines in the correct order
      List<Routine> sortedRoutines = [];

      // Add routines in the order specified by orderedRoutineIds
      for (int routineId in widget.split!.orderedRoutineIds) {
        if (routineMap.containsKey(routineId)) {
          sortedRoutines.add(routineMap[routineId]!);
        }
      }

      // Initialize selectedRoutines with the sorted list
      setState(() {
        selectedRoutines = sortedRoutines;
      });
    }
  }

  Future<void> _submit(SplitRepository splitRepo) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (selectedRoutines.isEmpty) {
        showSnackBar(context, 'Please select at least one routine');

        return;
      } else {
        var split = Split();
        if (widget.split != null) {
          split.id = widget.split!.id;
        }
        split.name = _name;
        split.orderedRoutineIds = [];

        // Save the split with the new order of routines
        await splitRepo.addSplit(split, selectedRoutines);

        // Go back to the previous screen
        Navigator.of(context).pop();
      }
    }
  }

  void _openRoutineSelectionScreen() async {
    final result = await Navigator.push<List<Routine>>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectRoutineScreen(
          alreadySelectedRoutines: selectedRoutines,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedRoutines = result;
      });
    }
  }

  void _removeRoutine(int index) {
    setState(() {
      selectedRoutines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var splitRepo = ref.read(splitProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.split != null ? 'Edit Split' : 'Create Split'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _submit(splitRepo);
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
              Text('Routines:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openRoutineSelectionScreen,
                child: const Text('Select Routine'),
              ),
              const SizedBox(height: 20),
              if (selectedRoutines.isNotEmpty) ...[
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: selectedRoutines.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = selectedRoutines.removeAt(oldIndex);
                        selectedRoutines.insert(newIndex, item);
                      });
                    },
                    buildDefaultDragHandles: true,
                    itemBuilder: (context, index) {
                      final routine = selectedRoutines[index];
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
