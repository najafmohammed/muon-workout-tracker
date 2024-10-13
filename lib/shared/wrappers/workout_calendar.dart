import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutCalendar extends StatelessWidget {
  final Set<DateTime> workoutDays;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarFormat calendarFormat;
  final bool hideNavigation;
  final bool formatButtonVisible; // Parameterized format button visibility
  final AvailableGestures availableGestures; // Parameterized available gestures

  const WorkoutCalendar({
    super.key,
    required this.workoutDays,
    required this.firstDay,
    required this.lastDay,
    this.calendarFormat = CalendarFormat.month, // Default to month view
    this.hideNavigation = true, // By default, hide navigation
    this.formatButtonVisible = false, // Default to hiding format button
    this.availableGestures = AvailableGestures.all, // Default to all gestures
  });

  bool _isWorkoutDay(DateTime date) {
    return workoutDays.any((workoutDay) =>
        workoutDay.year == date.year &&
        workoutDay.month == date.month &&
        workoutDay.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: DateTime.now(),

      calendarFormat: calendarFormat,
      headerStyle: HeaderStyle(
        titleCentered: true,
        headerPadding: const EdgeInsets.only(bottom: 20),
        formatButtonShowsNext: false,
        formatButtonVisible: formatButtonVisible, // Now parameterized
        leftChevronVisible:
            !hideNavigation, // Control visibility of navigation buttons
        rightChevronVisible:
            !hideNavigation, // Control visibility of navigation buttons
      ),
      weekendDays: const [],

      availableGestures: availableGestures, // Now parameterized
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: _isWorkoutDay(DateTime.now())
              ? (isDarkMode ? Colors.green : Colors.green)
              : null,
          border: _isWorkoutDay(DateTime.now())
              ? null
              : Border.all(
                  color: isDarkMode ? Colors.white : Colors.blue, width: 2),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: true,
        defaultTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        disabledTextStyle: TextStyle(
          color: isDarkMode ? Colors.red.shade300 : Colors.red,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          bool isWorkoutDay = _isWorkoutDay(day);
          bool hasPrevDayWorkout =
              _isWorkoutDay(day.subtract(const Duration(days: 1)));
          bool hasNextDayWorkout =
              _isWorkoutDay(day.add(const Duration(days: 1)));

          BoxDecoration? decoration;
          if (isWorkoutDay) {
            if (!hasPrevDayWorkout && !hasNextDayWorkout) {
              decoration = BoxDecoration(
                color: Colors.green[300],
                shape: BoxShape.circle,
              );
            } else if (!hasPrevDayWorkout && hasNextDayWorkout) {
              decoration = BoxDecoration(
                color: Colors.green[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                shape: BoxShape.rectangle,
              );
            } else if (hasPrevDayWorkout && !hasNextDayWorkout) {
              decoration = BoxDecoration(
                color: Colors.green[300],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                shape: BoxShape.rectangle,
              );
            } else if (hasPrevDayWorkout && hasNextDayWorkout) {
              decoration = BoxDecoration(
                color: Colors.green[300],
                shape: BoxShape.rectangle,
              );
            }
          }

          return Container(
            decoration: decoration,
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isWorkoutDay
                      ? (isDarkMode ? Colors.black : Colors.white)
                      : (isDarkMode ? Colors.white : Colors.black),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          bool isTodayWorkout = _isWorkoutDay(day);
          bool hasPrevDayWorkout =
              _isWorkoutDay(day.subtract(const Duration(days: 1)));
          bool hasNextDayWorkout =
              _isWorkoutDay(day.add(const Duration(days: 1)));

          BoxDecoration? todayDecoration;
          if (isTodayWorkout) {
            if (!hasPrevDayWorkout && !hasNextDayWorkout) {
              todayDecoration = BoxDecoration(
                color: Colors.green[300],
                shape: BoxShape.circle,
              );
            } else if (!hasPrevDayWorkout && hasNextDayWorkout) {
              todayDecoration = BoxDecoration(
                color: Colors.green[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                shape: BoxShape.rectangle,
              );
            } else if (hasPrevDayWorkout && !hasNextDayWorkout) {
              todayDecoration = BoxDecoration(
                color: Colors.green[300],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                shape: BoxShape.rectangle,
              );
            } else if (hasPrevDayWorkout && hasNextDayWorkout) {
              todayDecoration = BoxDecoration(
                color: Colors.green[300],
                shape: BoxShape.rectangle,
              );
            }
          } else {
            todayDecoration = BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: isDarkMode ? Colors.white : Colors.blue, width: 2),
            );
          }

          return Container(
            decoration: todayDecoration,
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isTodayWorkout
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
      eventLoader: (day) {
        bool isWorkoutDay = _isWorkoutDay(day);
        return isWorkoutDay ? ['Workout'] : [];
      },
    );
  }
}
