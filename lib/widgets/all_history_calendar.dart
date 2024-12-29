import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/session_entry.dart';
import 'package:muon_workout_tracker/database/providers/session_entry_provider.dart';
import 'package:muon_workout_tracker/database/repository/session_entry_repository.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';
import 'package:muon_workout_tracker/shared/wrappers/workout_calendar.dart';
import 'package:muon_workout_tracker/utils/workout_days_range.dart';
import 'package:muon_workout_tracker/widgets/workout_list.dart';
import 'package:table_calendar/table_calendar.dart';

class AllHistoryPage extends ConsumerStatefulWidget {
  AllHistoryPage({super.key});

  @override
  _AllHistoryPageState createState() => _AllHistoryPageState();
}

class _AllHistoryPageState extends ConsumerState<AllHistoryPage> {
  DateTime selectedDate = DateTime.now(); // Track the selected date
  Future<Set<DateTime>>? workoutDaysFuture; // Future for workout days
  CalendarFormat _calendarFormat =
      CalendarFormat.month; // Current calendar format
  ScrollController _scrollController = ScrollController(); // ScrollController
  SessionEntry? sessionEntry; // Store loaded session entry

  @override
  void initState() {
    super.initState();
    // Initialize the workout days future
    final sessionEntryRepository = ref.read(sessionEntryProvider);
    workoutDaysFuture = getWorkoutDaysForRange(
      sessionEntryRepository,
      DateTime.utc(2020, 1, 1),
      DateTime.utc(2100, 12, 31),
    );

    // Load the session entry for the current date
    _loadSessionEntry(sessionEntryRepository, selectedDate);

    // Add listener to the scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 50) {
        setState(() {
          _calendarFormat = CalendarFormat.month;
        });
      } else if (_scrollController.position.pixels < 400) {
        setState(() {
          _calendarFormat = CalendarFormat.twoWeeks;
        });
      } else {
        setState(() {
          _calendarFormat = CalendarFormat.week;
        });
      }
    });
  }

  // Load session entry for a given date
  Future<void> _loadSessionEntry(
      SessionEntryRepository repository, DateTime date) async {
    sessionEntry = await repository.getSessionEntryByDate(date);
    setState(() {}); // Trigger rebuild after loading the session entry
  }

  @override
  void dispose() {
    // Dispose the scroll controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All History'),
      ),
      body: FutureBuilder<Set<DateTime>>(
        future: workoutDaysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading workout days'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final workoutDays = snapshot.data!;
            return CustomScrollView(
              controller: _scrollController, // Use the scroll controller
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 30), // Flexible top spacing
                    child: WorkoutCalendar(
                      focusedDay: selectedDate,
                      formatButtonVisible: true,
                      workoutDays: workoutDays,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      calendarFormat: _calendarFormat, // Use the current format
                      hideNavigation: false,
                      onDaySelected: (day, focused) {
                        setState(() {
                          selectedDate = day; // Update selected date
                        });
                        // Load the session entry for the new selected date
                        _loadSessionEntry(ref.read(sessionEntryProvider), day);
                      },
                    ),
                  ),
                ),
                // Sticky header with the selected date
                SliverPersistentHeader(
                  pinned: true, // Keeps it stuck at the top
                  delegate: _WorkoutHeaderDelegate(
                    selectedDate: selectedDate,
                  ),
                ),
                // Pass the loaded session entry to WorkoutList
                sessionEntry != null
                    ? WorkoutList(sessionEntry: sessionEntry!)
                    : const SliverFillRemaining(
                        child: Center(child: Text("No workouts found")),
                      ),
              ],
            );
          } else {
            return const Center(child: Text('No workout days found'));
          }
        },
      ),
    );
  }
}

// Custom header delegate to make the header sticky
class _WorkoutHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime selectedDate;

  _WorkoutHeaderDelegate({
    required this.selectedDate,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Determine if the header is fully expanded

    return CardWrapper(
      children: [
        // Show the calendar only when the header is expanded

        Center(
          child: Text(
            'Workouts on ${selectedDate.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 70; // Header height
  @override
  double get minExtent => 70.0; // Minimum height when collapsed
  @override
  bool shouldRebuild(_WorkoutHeaderDelegate oldDelegate) {
    return oldDelegate.selectedDate != selectedDate;
  }
}
