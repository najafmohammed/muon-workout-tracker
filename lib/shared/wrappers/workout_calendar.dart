import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutCalendar extends StatelessWidget {
  final Set<DateTime> workoutDays;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay; // Use this parameter
  final CalendarFormat calendarFormat;
  final bool hideNavigation;
  final bool headerVisible;
  final bool formatButtonVisible; // Parameterized format button visibility
  final AvailableGestures availableGestures; // Parameterized available gestures
  final Function(DateTime, DateTime) onDaySelected;

  const WorkoutCalendar({
    super.key,
    required this.workoutDays,
    required this.firstDay,
    required this.lastDay,
    this.headerVisible = true,
    required this.focusedDay, // Required parameter
    this.calendarFormat = CalendarFormat.month, // Default to month view
    this.hideNavigation = true, // By default, hide navigation
    this.formatButtonVisible = false, // Default to hiding format button
    this.availableGestures = AvailableGestures.all, // Default to all gestures
    required this.onDaySelected,
  });

  bool _isWorkoutDay(DateTime date) {
    return workoutDays.any((workoutDay) =>
        workoutDay.year == date.year &&
        workoutDay.month == date.month &&
        workoutDay.day == date.day);
  }

  BoxDecoration? _getDecoration(bool isWorkoutDay, bool hasPrevDayWorkout,
      bool hasNextDayWorkout, Color color) {
    if (!isWorkoutDay) return null;

    if (!hasPrevDayWorkout && !hasNextDayWorkout) {
      return BoxDecoration(color: color, shape: BoxShape.circle);
    } else if (!hasPrevDayWorkout && hasNextDayWorkout) {
      return BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
        shape: BoxShape.rectangle,
      );
    } else if (hasPrevDayWorkout && !hasNextDayWorkout) {
      return BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        shape: BoxShape.rectangle,
      );
    } else if (hasPrevDayWorkout && hasNextDayWorkout) {
      return BoxDecoration(color: color, shape: BoxShape.rectangle);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TableCalendar(
      headerVisible: headerVisible,
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay, // Use the passed focusedDay
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay,
            focusedDay); // Notify the parent widget of the selected date
      },
      calendarFormat: calendarFormat,
      headerStyle: HeaderStyle(
        titleCentered: true,
        headerPadding: const EdgeInsets.only(bottom: 20),
        formatButtonShowsNext: false,
        formatButtonVisible: formatButtonVisible,
        leftChevronVisible: !hideNavigation,
        rightChevronVisible: !hideNavigation,
      ),
      selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
      weekendDays: const [],
      availableGestures: availableGestures,
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

          BoxDecoration? decoration = _getDecoration(isWorkoutDay,
              hasPrevDayWorkout, hasNextDayWorkout, Colors.green[300]!);

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
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
        selectedBuilder: (context, day, focusedDay) {
          bool isTodayWorkout = _isWorkoutDay(day);
          bool hasPrevDayWorkout =
              _isWorkoutDay(day.subtract(const Duration(days: 1)));
          bool hasNextDayWorkout =
              _isWorkoutDay(day.add(const Duration(days: 1)));

          BoxDecoration? decoration = _getDecoration(isTodayWorkout,
              hasPrevDayWorkout, hasNextDayWorkout, Colors.green[300]!);

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: decoration,
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
        todayBuilder: (context, day, focusedDay) {
          bool isTodayWorkout = _isWorkoutDay(day);
          bool hasPrevDayWorkout =
              _isWorkoutDay(day.subtract(const Duration(days: 1)));
          bool hasNextDayWorkout =
              _isWorkoutDay(day.add(const Duration(days: 1)));

          BoxDecoration? todayDecoration = _getDecoration(isTodayWorkout,
              hasPrevDayWorkout, hasNextDayWorkout, Colors.green[300]!);
          if (!isTodayWorkout) {
            todayDecoration = BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: isDarkMode ? Colors.white : Colors.blue, width: 2),
            );
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
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
