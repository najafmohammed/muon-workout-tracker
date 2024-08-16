import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/utils/weekday.dart';

class StreakCard extends StatefulWidget {
  const StreakCard({super.key});

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  @override
  Widget build(BuildContext context) {
    var streaks = <Widget>[];
    var date = getDaysOfWeek();
    var day = getDaysOfWeek(weekDay: true);
    date.asMap().forEach((index, value) {
      streaks.add(Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (index == 0 || index == date.length - 1)
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).primaryColor,
          ),
          child: Column(
            children: [
              Text(value.toString()),
              Text(day[index][0]),
            ],
          )));
    });
    return CardWrapper(children: [
      const Text(
        'Streak',
        style: AppTextStyle.large,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: streaks),
      )
    ]);
  }
}
