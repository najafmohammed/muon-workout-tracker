import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/routine.dart';
import 'package:muon_workout_tracker/database/providers/routine_provider.dart';
import 'package:muon_workout_tracker/utils/format_time_ago.dart';

class SelectRoutineScreen extends ConsumerStatefulWidget {
  const SelectRoutineScreen({
    Key? key,
    required this.alreadySelectedRoutines,
  }) : super(key: key);

  final List<Routine> alreadySelectedRoutines;

  @override
  _SelectRoutineScreenState createState() => _SelectRoutineScreenState();
}

class _SelectRoutineScreenState extends ConsumerState<SelectRoutineScreen> {
  List<Routine> _selectedRoutines = [];

  bool _isRoutineSelected(Routine routine) {
    return _selectedRoutines.any((e) => e.id == routine.id);
  }

  void _toggleRoutineSelection(Routine routine) {
    setState(() {
      if (_isRoutineSelected(routine)) {
        _selectedRoutines.removeWhere((e) => e.id == routine.id);
      } else {
        _selectedRoutines.add(routine);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedRoutines = widget.alreadySelectedRoutines;
  }

  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';

  @override
  Widget build(BuildContext context) {
    final routineRepo = ref.watch(routineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Routines'),
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
            child: StreamBuilder<List<Routine>>(
              stream:
                  routineRepo.getAllRoutinesFiltered(nameFilter: nameFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Exercises Found'));
                } else {
                  final routines = snapshot.data!;

                  return ListView.builder(
                    itemCount: routines.length,
                    itemBuilder: (context, index) {
                      final exercise = routines[index];
                      final isSelected = _isRoutineSelected(exercise);

                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(formatTimeAgo(exercise.lastRun)),
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            _toggleRoutineSelection(exercise);
                          },
                        ),
                        onTap: () {
                          _toggleRoutineSelection(exercise);
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
      floatingActionButton: _selectedRoutines.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                // Pass back the selected routine to the previous screen
                Navigator.pop(context, _selectedRoutines);
              },
              label: const Text('DONE'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
