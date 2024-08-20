import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/screens/workout_manager.dart';

class AddWorkoutCard extends StatelessWidget {
  const AddWorkoutCard({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExerciseManager()),
          );
        },
        child: ListTile(
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            trailing: const Icon(Icons.chevron_right_rounded)),
      ),
    );
  }
}
