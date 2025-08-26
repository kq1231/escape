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
  final List<Widget> _baseScreens = [];
  final int _analyticsIndex = 3; // Analytics screen index

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _baseScreens.addAll([
      HomeScreen(),
      PrayerTrackerScreen(),
      ChallengesScreen(),
      Container(), // Placeholder for analytics - will be added dynamically, Inshaa Allah
      MediaScreen(),
      SettingsScreen(),
    ]);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    List<Widget> screens = List.from(_baseScreens);

    // Only add Analytics screen if we're currently on it
    if (_currentIndex == _analyticsIndex) {
      screens[_analyticsIndex] = const AnalyticsScreen();
    } else {
      // Remove analytics screen when navigating away
      screens[_analyticsIndex] = Container(); // Empty placeholder
    }

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
}
