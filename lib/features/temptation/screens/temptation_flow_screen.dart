import 'dart:async';
import 'package:escape/models/temptation.dart';
import 'package:escape/providers/current_active_temptation_provider.dart';
import 'package:escape/providers/user_profile_provider.dart';
import 'package:escape/repositories/temptation_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import '../services/temptation_storage_service.dart';
import '../atoms/temptation_page_indicator.dart';
import '../atoms/countdown_timer.dart';
import '../molecules/motivation_card.dart';
import '../molecules/lust_cycle_diagram.dart';
import '../molecules/activity_selector.dart';

class TemptationFlowScreen extends ConsumerStatefulWidget {
  const TemptationFlowScreen({super.key});

  @override
  ConsumerState<TemptationFlowScreen> createState() =>
      _TemptationFlowScreenState();
}

class _TemptationFlowScreenState extends ConsumerState<TemptationFlowScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  String? _selectedActivity;
  final List<String> _selectedTriggers = [];
  final List<String> _helpfulActivities = [];
  final TemptationStorageService _storageService = TemptationStorageService();
  Timer? _timerRefresh;

  // Helper method to get appropriate text color for theme
  Color _getTextColor(Color defaultColor) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : defaultColor;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeTemptation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timerRefresh?.cancel();
    super.dispose();
  }

  Future<void> _initializeTemptation() async {
    await _storageService.initialize();

    if (_storageService.hasActiveTemptation()) {
      // Resume existing temptation - the provider will handle this
      setState(() {
        _selectedActivity = _storageService.getSelectedActivity();
      });

      // Check if timer is active and navigate directly to timer screen (page 4)
      if (_storageService.isTimerActive()) {
        // Jump to timer screen (page 4)
        _pageController.jumpToPage(4);
        setState(() {
          _currentPage = 4;
        });
        // Start timer refresh to update UI in real-time
        _startTimerRefresh();
      }
    } else {
      // Create new temptation using the repository
      final newTemptation = Temptation(createdAt: DateTime.now());
      final id = await ref
          .read(temptationRepositoryProvider.notifier)
          .createTemptation(newTemptation);

      // Store in SharedPreferences
      await _storageService.storeActiveTemptation(
        temptationId: id,
        startTime: newTemptation.createdAt,
        intensityBefore: 5, // Default intensity
      );
    }
  }

  void _startTimerRefresh() {
    // Cancel existing timer if any
    _timerRefresh?.cancel();

    // Start new timer to refresh UI every second
    _timerRefresh = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if timer is still active
      if (_storageService.isTimerActive()) {
        // Trigger UI update
        if (mounted) {
          setState(() {});
        }
      } else {
        // Timer completed, stop refresh
        _timerRefresh?.cancel();
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onCountdownComplete() async {
    // Navigate to final page
    _pageController.animateToPage(
      5,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onSuccess() async {
    // Stop timer first
    await _storageService.stopTimer();

    // Use the currentActiveTemptation provider to complete temptation successfully
    await ref
        .read(currentActiveTemptationProvider.notifier)
        .completeTemptation(
          temptation: Temptation(
            createdAt: DateTime.now(),
            wasSuccessful: true,
            resolutionNotes:
                'Successfully overcame temptation through activity: $_selectedActivity',
            triggers: _selectedTriggers,
            helpfulActivities: _helpfulActivities,
          ),
        );

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Alhamdulillah! 🎉'),
          content: const Text(
            'Allah has blessed you with strength! '
            'May Allah grant you more victories like this. '
            'Your victory has been recorded.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  void _onTriggerSelected(String trigger) {
    setState(() {
      if (_selectedTriggers.contains(trigger)) {
        _selectedTriggers.remove(trigger);
      } else {
        _selectedTriggers.add(trigger);
      }
    });
  }

  void _onHelpfulActivitySelected(String activity) {
    setState(() {
      if (_helpfulActivities.contains(activity)) {
        _helpfulActivities.remove(activity);
      } else {
        _helpfulActivities.add(activity);
      }
    });
  }

  void _onRelapse() async {
    // Stop timer first
    await _storageService.stopTimer();

    // Use the currentActiveTemptation provider to complete temptation with relapse
    await ref
        .read(currentActiveTemptationProvider.notifier)
        .completeTemptation(
          temptation: Temptation(
            createdAt: DateTime.now(),
            wasSuccessful: false,
            resolutionNotes: 'Relapsed but made tawbah',
            triggers: _selectedTriggers,
            helpfulActivities: _helpfulActivities,
          ),
        );

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Don\'t worry, Allah will always forgive you! 🌙'),
          content: const Text(
            'Allah is At-Tawwab, The Accepter of Repentance. '
            'Make tawbah and move forward, don\'t dwell on it. '
            'Every new moment is a chance to start again.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  void _onCancelSession() async {
    // Show confirmation dialog
    final shouldCancel = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Session?'),
        content: const Text(
          'Are you sure you want to cancel this temptation session? '
          'This will remove all progress and you\'ll need to start over.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No, Continue'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      // Stop timer first
      await _storageService.stopTimer();

      // Use the currentActiveTemptation provider to cancel temptation
      await ref
          .read(currentActiveTemptationProvider.notifier)
          .cancelTemptation();

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPage == 0 ? 'I Need Help' : 'Temptation Protocols',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Text(
                  'Step ${_currentPage + 1} of 6',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGray,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TemptationPageIndicator(
                  currentPage: _currentPage,
                  pageCount: 6,
                  activeColor: AppTheme.primaryGreen,
                  inactiveColor: AppTheme.mediumGray,
                ),
              ],
            ),
          ),
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _buildCalmPage();
                  case 1:
                    return _buildEducationPage();
                  case 2:
                    return _buildMotivationPage();
                  case 3:
                    return _buildActivityPage();
                  case 4:
                    return _buildActionPage();
                  case 5:
                    return _buildResolutionPage();
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildCalmPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mosque, size: 80, color: AppTheme.primaryGreen),
          const SizedBox(height: AppTheme.spacingXL),
          Text(
            'Assalamu alaykum brother/sister',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTextColor(AppTheme.darkGreen),
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingL),
          IslamicMotivationCards.buildCard(context, 0), // Allah's Promise
          const SizedBox(height: AppTheme.spacingXL),
          Text(
            'Take a deep breath and know that Allah is with you.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _getTextColor(AppTheme.mediumGray),
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LustCycleDiagram(),
          const SizedBox(height: AppTheme.spacingXL),
          IslamicMotivationCards.buildCard(context, 3), // Temporary Feeling
        ],
      ),
    );
  }

  Widget _buildMotivationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IslamicMotivationCards.buildCard(context, 4), // Spiritual Rewards
          const SizedBox(height: AppTheme.spacingM),
          IslamicMotivationCards.buildCard(context, 5), // Immense AJR
          const SizedBox(height: AppTheme.spacingM),
          IslamicMotivationCards.buildCard(context, 1), // Divine Mercy
        ],
      ),
    );
  }

  Widget _buildActivityPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActivitySelector(
            predefinedActivities: PredefinedActivities.activityNames,
            onActivitySelected: (activity) {
              setState(() {
                _selectedActivity = activity;
              });

              // Start timer when activity is selected
              _storageService.startTimer(durationMinutes: 30);
            },
          ),
          if (_selectedActivity != null) ...[
            const SizedBox(height: AppTheme.spacingXL),
            Text(
              'Selected: $_selectedActivity',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTextColor(AppTheme.primaryGreen),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Timer started for 30 minutes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getTextColor(AppTheme.mediumGray),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _selectedActivity != null
                ? 'Go $_selectedActivity for 30 minutes'
                : 'Select an activity above for 30 minutes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTextColor(AppTheme.darkGreen),
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Show timer status
          if (_storageService.isTimerActive()) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                border: Border.all(color: AppTheme.primaryGreen),
              ),
              child: Column(
                children: [
                  Text(
                    'Timer Active',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Time remaining: ${_storageService.getFormattedRemainingTime()}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _getTextColor(AppTheme.darkGreen),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Time elapsed: ${_storageService.getFormattedElapsedTime()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getTextColor(AppTheme.mediumGray),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ] else ...[
            Text(
              'Start timer by selecting an activity',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ],

          CountdownTimer(
            remainingSeconds: _storageService.isTimerActive()
                ? _storageService.getRemainingTime().inSeconds
                : 30 * 60, // Default 30 minutes if no active timer
            onComplete: _onCountdownComplete,
            primaryColor: AppTheme.primaryGreen,
            backgroundColor: AppTheme.lightGreen,
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Cancel Session Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _onCancelSession,
              icon: const Icon(Icons.cancel, color: AppTheme.white),
              label: const Text(
                'Cancel Session',
                style: TextStyle(color: AppTheme.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingXL,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),
          Text(
            'Come back when you\'re done! You can close the app.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _getTextColor(AppTheme.mediumGray),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How did it go?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTextColor(AppTheme.darkGreen),
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _onSuccess,
                icon: const Icon(Icons.check_circle, color: AppTheme.white),
                label: const Text(
                  'Alhamdulillah,\nI overcame it!',
                  style: TextStyle(color: AppTheme.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingXL,
                  ),
                  minimumSize: const Size(150, 80),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _onRelapse,
                icon: const Icon(Icons.cancel, color: AppTheme.white),
                label: const Text(
                  'Relapsed',
                  style: TextStyle(color: AppTheme.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingXL,
                  ),
                  minimumSize: const Size(150, 80),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Optional questions section
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                  : AppTheme.lightGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Column(
              children: [
                Text(
                  'Optional: Help us understand better',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingM),

                // Triggers section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What were the triggers? (select all that apply)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Wrap(
                      spacing: AppTheme.spacingS,
                      runSpacing: AppTheme.spacingS,
                      children: [
                        // User's personal triggers from profile
                        ...?ref
                            .read(userProfileProvider)
                            .requireValue
                            ?.triggers
                            .map((trigger) => _buildTriggerChip(trigger)),
                        // Common triggers as fallback
                        if ((ref
                                    .read(userProfileProvider)
                                    .requireValue
                                    ?.triggers ??
                                [])
                            .isEmpty) ...[
                          _buildTriggerChip('Boredom'),
                          _buildTriggerChip('Stress'),
                          _buildTriggerChip('Loneliness'),
                          _buildTriggerChip('Anger'),
                          _buildTriggerChip('Anxiety'),
                          _buildTriggerChip('Social Media'),
                          _buildTriggerChip('Other'),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Helpful activities section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What helped you the most? (select all that apply)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Wrap(
                      spacing: AppTheme.spacingS,
                      runSpacing: AppTheme.spacingS,
                      children: [
                        _buildHelpfulActivityChip('Selected Activity'),
                        _buildHelpfulActivityChip('Deep Breathing'),
                        _buildHelpfulActivityChip('Dua/Prayer'),
                        _buildHelpfulActivityChip('Calling Someone'),
                        _buildHelpfulActivityChip('Exercise'),
                        _buildHelpfulActivityChip('Reading Quran'),
                        _buildHelpfulActivityChip('Other'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),
          Text(
            'Your response will help us understand what works best for you.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _getTextColor(AppTheme.mediumGray),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerChip(String trigger) {
    final isSelected = _selectedTriggers.contains(trigger);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(trigger),
      selected: isSelected,
      onSelected: (selected) {
        _onTriggerSelected(trigger);
      },
      backgroundColor: isDarkMode
          ? AppTheme.primaryGreen.withValues(alpha: 0.2)
          : AppTheme.lightGreen.withValues(alpha: 0.3),
      selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.6),
      checkmarkColor: AppTheme.white,
      labelStyle: TextStyle(
        color: isSelected
            ? AppTheme.white
            : _getTextColor(AppTheme.primaryGreen),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildHelpfulActivityChip(String activity) {
    final isSelected = _helpfulActivities.contains(activity);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(activity),
      selected: isSelected,
      onSelected: (selected) {
        _onHelpfulActivitySelected(activity);
      },
      backgroundColor: isDarkMode
          ? AppTheme.primaryGreen.withValues(alpha: 0.2)
          : AppTheme.lightGreen.withValues(alpha: 0.3),
      selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.6),
      checkmarkColor: AppTheme.white,
      labelStyle: TextStyle(
        color: isSelected
            ? AppTheme.white
            : _getTextColor(AppTheme.primaryGreen),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
              ),
              child: const Text('Back'),
            )
          else
            const SizedBox(width: 80),
          if (_currentPage < 5)
            ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: AppTheme.white,
              ),
              child: const Text('Next'),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}
