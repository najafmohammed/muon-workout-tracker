import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/screens/home.dart';
import 'package:muon_workout_tracker/screens/profile.dart';
import 'package:muon_workout_tracker/screens/stats.dart';
import 'package:muon_workout_tracker/screens/workouts.dart';
import 'package:muon_workout_tracker/shared/mini_player.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends ConsumerState<Navigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _navigationDestinations = const <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.home), label: "Home"),
    NavigationDestination(icon: Icon(Icons.fitness_center), label: "Workouts"),
    NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: "Stats"),
    NavigationDestination(icon: Icon(Icons.person_2), label: "Profile")
  ];

  _homePages(index) =>
      const <Widget>[Home(), Workouts(), Stats(), Profile()][index];

  @override
  Widget build(BuildContext context) {
    final isActive = ref.watch(routineSessionProvider)?.isActive ?? false;

    if (isActive) {
      _controller.forward(); // Show MiniPlayer with fade-in effect
    } else {
      _controller.reverse(); // Hide MiniPlayer with fade-out effect
    }

    return Scaffold(
      body: _homePages(_selectedIndex),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Only show the MiniPlayer if isActive is true
          Visibility(
            visible: isActive, // This ensures it is not rendered when inactive
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity:
                    _fadeAnimation, // Control transparency during animation
                child: const MiniPlayer(),
              ),
            ),
          ),
          NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: _navigationDestinations,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() {
              _selectedIndex = index;
            }),
          ),
        ],
      ),
    );
  }
}
