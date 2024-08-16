import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/screens/home.dart';
import 'package:muon_workout_tracker/screens/profile.dart';
import 'package:muon_workout_tracker/screens/stats.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final _navigationDestinations = const <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.home), label: "Home"),
    NavigationDestination(icon: Icon(Icons.fitness_center), label: "Stats"),
    NavigationDestination(icon: Icon(Icons.person_2), label: "Profile")
  ];

  _homePages(index) => const <Widget>[Home(), Stats(), Profile()][index];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _homePages(_selectedIndex),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _navigationDestinations,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() {
            _selectedIndex = index;
          }),
        ));
  }
}
