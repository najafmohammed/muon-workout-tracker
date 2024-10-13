import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class AddWorkoutCard extends StatelessWidget {
  const AddWorkoutCard({super.key, required this.label, required this.widget});
  final String label;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
      child: CardWrapper(
        children: [
          ListTile(
              dense: true,
              title: Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              trailing: const Icon(Icons.chevron_right_rounded)),
        ],
      ),
    );
  }
}
