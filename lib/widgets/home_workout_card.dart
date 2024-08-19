import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class HomeWorkoutCard extends StatelessWidget {
  const HomeWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardWrapper(children: [
      Text(
        'PUSH',
        style: AppTextStyle.large,
      ),
      Text(
        'Chest/Shoulder/Triceps',
        style: AppTextStyle.medium,
      ),
      InkWell(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Start Workout',
                style: TextStyle(fontSize: 20),
              ),
              Icon(Icons.arrow_forward),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    ]);
  }
}
