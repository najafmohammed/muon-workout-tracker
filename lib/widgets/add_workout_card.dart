import 'package:flutter/material.dart';

class AddWorkoutCard extends StatelessWidget {
  const AddWorkoutCard({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {},
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
