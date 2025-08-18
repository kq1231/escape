import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import '../../../providers/user_profile_provider.dart';
import '../atoms/activity_button.dart';

class ActivitySelector extends ConsumerStatefulWidget {
  final Function(String)? onActivitySelected;
  final List<String>? predefinedActivities;

  const ActivitySelector({
    super.key,
    this.onActivitySelected,
    this.predefinedActivities,
  });

  @override
  ConsumerState<ActivitySelector> createState() => _ActivitySelectorState();
}

class _ActivitySelectorState extends ConsumerState<ActivitySelector> {
  String? _selectedActivity;
  List<String> _activities = [];

  // Helper method to get appropriate text color for dark mode
  Color _getTextColor(Color defaultColor) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark ? Colors.white : defaultColor;
  }

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    final userProfile = ref.read(userProfileProvider).requireValue;
    if (userProfile != null) {
      setState(() {
        _activities = [...userProfile.hobbies];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities = widget.predefinedActivities ?? _activities;

    if (activities.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No activities available',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _getTextColor(AppTheme.mediumGray),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ElevatedButton(
            onPressed: _loadActivities,
            child: const Text('Refresh Activities'),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Pick an activity to do right now:',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getTextColor(AppTheme.darkGreen),
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingXL),
        // Activity grid
        Wrap(
          spacing: AppTheme.spacingM,
          runSpacing: AppTheme.spacingM,
          children: activities.map((activity) {
            return ActivityButton(
              activity: activity,
              icon: _getActivityIcon(activity),
              isSelected: _selectedActivity == activity,
              onPressed: () {
                setState(() {
                  _selectedActivity = activity;
                });
                widget.onActivitySelected?.call(activity);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppTheme.spacingL),
        // Something else option
        ActivityButton(
          activity: 'Something else...',
          icon: Icons.add,
          isSelected: _selectedActivity == 'Something else...',
          onPressed: () {
            setState(() {
              _selectedActivity = 'Something else...';
            });
            widget.onActivitySelected?.call('Something else...');
          },
        ),
      ],
    );
  }

  IconData _getActivityIcon(String activity) {
    final lowerActivity = activity.toLowerCase();

    if (lowerActivity.contains('read') || lowerActivity.contains('book')) {
      return Icons.menu_book;
    } else if (lowerActivity.contains('exercise') ||
        lowerActivity.contains('workout')) {
      return Icons.fitness_center;
    } else if (lowerActivity.contains('pray') ||
        lowerActivity.contains('dua')) {
      return Icons.mosque;
    } else if (lowerActivity.contains('music') ||
        lowerActivity.contains('song')) {
      return Icons.music_note;
    } else if (lowerActivity.contains('draw') ||
        lowerActivity.contains('art')) {
      return Icons.palette;
    } else if (lowerActivity.contains('cook') ||
        lowerActivity.contains('food')) {
      return Icons.restaurant;
    } else if (lowerActivity.contains('call') ||
        lowerActivity.contains('talk')) {
      return Icons.phone;
    } else if (lowerActivity.contains('walk') ||
        lowerActivity.contains('run')) {
      return Icons.directions_walk;
    } else if (lowerActivity.contains('game') ||
        lowerActivity.contains('play')) {
      return Icons.games;
    } else if (lowerActivity.contains('clean') ||
        lowerActivity.contains('tidy')) {
      return Icons.cleaning_services;
    } else {
      return Icons.apps;
    }
  }
}

// Predefined activities for users without hobbies
class PredefinedActivities {
  static const List<Map<String, dynamic>> activities = [
    {
      'name': 'Read Quran',
      'icon': Icons.mosque,
      'description': 'Connect with Allah through His words',
    },
    {
      'name': 'Make Dua',
      'icon': Icons.favorite,
      'description': 'Supplicate to Allah for strength',
    },
    {
      'name': 'Exercise',
      'icon': Icons.fitness_center,
      'description': 'Release endorphins and build discipline',
    },
    {
      'name': 'Call Friend',
      'icon': Icons.phone,
      'description': 'Talk to someone supportive',
    },
    {
      'name': 'Go for Walk',
      'icon': Icons.directions_walk,
      'description': 'Clear your mind and get fresh air',
    },
    {
      'name': 'Listen to Quran',
      'icon': Icons.headphones,
      'description': 'Let the Quran soothe your heart',
    },
    {
      'name': 'Clean Room',
      'icon': Icons.cleaning_services,
      'description': 'Focus on productive physical activity',
    },
    {
      'name': 'Play Game',
      'icon': Icons.games,
      'description': 'Engage your mind in something enjoyable',
    },
  ];

  static List<String> get activityNames =>
      activities.map((a) => a['name'] as String).toList();
}
