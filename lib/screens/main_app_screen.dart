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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return const [
      HomeScreen(),
      PrayerTrackerScreen(),
      ChallengesScreen(),
      AnalyticsScreen(),
      MediaScreen(),
      SettingsScreen(),
    ];
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
