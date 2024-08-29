import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/repository/split_repository.dart';
import 'package:muon_workout_tracker/screens/select_routine.dart';

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
      selectedRoutines = widget.split!.routines.map((e) => e).toList();
    } else {
      _name = '';
    }
  }

  Future<void> _submit(SplitRepository splitRepo) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (selectedRoutines.isEmpty) {
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
        var split = Split();
        if (widget.split != null) {
          split.id = widget.split!.id;
        }
        split.name = _name;
        splitRepo.addSplit(split, selectedRoutines);
        // Backend implementation for saving the routine
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

  void _removeExercise(int index) {
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
              Text('Routine:', style: Theme.of(context).textTheme.headline6),
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
                    itemBuilder: (context, index) {
                      final routine = selectedRoutines[index];
                      return ListTile(
                        key: ValueKey(routine.id),
                        title: Text(routine.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeExercise(index),
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
