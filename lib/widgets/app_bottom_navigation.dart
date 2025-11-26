import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:escape/theme/app_constants.dart';

class AppBottomNavigationItem {
  static const List<IconData> icons = [
    Icons.home,
    Icons.access_time,
    Icons.flag,
    Icons.analytics,
    Icons.play_circle_outline,
    Icons.settings,
  ];

  static const List<String> labels = [
    'Home',
    'Prayer',
    'Challenges',
    'Analytics',
    'Media',
    'Settings',
  ];
}

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      initialSelectedTab: AppBottomNavigationItem.labels[currentIndex],
      useSafeArea: true,
      labels: AppBottomNavigationItem.labels,
      icons: AppBottomNavigationItem.icons,
      tabSize: 40,

      // 🔥 COLORS YOU ASKED FOR
      tabBarColor: AppConstants.white,                        // Background white
      tabSelectedColor: AppConstants.primaryGreen,            // Selected circle = primary
      tabIconSelectedColor: Colors.white,                     // Selected icon = white
      tabIconColor: AppConstants.primaryGreen,                // Unselected icons = primary

      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,fontSize: 11,
        color: AppConstants.primaryGreen,                      // Label color
      ),

      onTabItemSelected: (index) => onTap(index),
    );
  }
}
