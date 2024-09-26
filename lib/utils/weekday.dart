import 'package:intl/intl.dart';

List getDaysOfWeek({bool weekDay = false}) {
  List daysOfWeek = [];

  // Get the current date and find the previous Sunday
  DateTime now = DateTime.now();
  DateTime previousSunday =
      now.subtract(Duration(days: now.weekday == 7 ? 0 : now.weekday));

  // Generate the names of the days of the week starting from the previous Sunday
  for (int i = 0; i < 7; i++) {
    DateTime currentDay = previousSunday.add(Duration(days: i));
    weekDay
        ? daysOfWeek.add(DateFormat('E').format(currentDay))
        : daysOfWeek.add(currentDay);
  }

  return daysOfWeek;
}
