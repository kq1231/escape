import 'package:flutter/material.dart';
import '../widgets/app_bottom_navigation.dart';
import '../features/prayer/screens/prayer_tracker_screen.dart';
import '../features/challenges/screens/challenges_screen.dart';
import '../features/analytics/screens/analytics_screen.dart';
import '../features/media/screens/media_screen.dart';
import '../screens/home_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  // Track which screens have been visited to keep them in the stack
  final Set<int> _visitedScreens = {0}; // Home screen is visited by default

  final int _analyticsIndex =
      3; // Analytics screen should be disposed when navigating away

  @override
  void initState() {
    super.initState();
    // Home screen (index 0) is already marked as visited
  }

  void _onTabTapped(int index) {
    setState(() {
      // If navigating away from analytics, mark it as not visited (dispose it)
      if (_currentIndex == _analyticsIndex && index != _analyticsIndex) {
        _visitedScreens.remove(_analyticsIndex);
      }

      // Add new screen to visited set (this will keep it in the stack)
      _visitedScreens.add(index);

      _currentIndex = index;
    });
  }

  /// Creates the appropriate screen widget based on index
  Widget _createScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const PrayerTrackerScreen();
      case 2:
        return const ChallengesScreen();
      case 3:
        return const AnalyticsScreen();
      case 4:
        return const MediaScreen();
      case 5:
        return const SettingsScreen();
      default:
        return Container(); // Fallback for invalid indices
    }
  }

  /// Builds the screens list for IndexedStack
  /// Only includes screens that have been visited (and should remain in stack)
  List<Widget> _buildScreens() {
    List<Widget> screens = [];

    for (int i = 0; i < 6; i++) {
      if (_visitedScreens.contains(i)) {
        // Screen has been visited, add actual widget to keep it alive
        screens.add(_createScreen(i));
      } else {
        // Screen not visited yet, add placeholder container
        screens.add(Container());
      }
    }

    // Debug print to see which screens are in the stack
    // print('Screens in stack: ${_visitedScreens.toList()}');
    // print('Current index: $_currentIndex');

    return screens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _buildScreens()),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  @override
  void dispose() {
    // Clear visited screens set
    _visitedScreens.clear();
    super.dispose();
  }
}
