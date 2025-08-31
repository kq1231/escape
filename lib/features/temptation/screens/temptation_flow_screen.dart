import 'dart:async';
import 'package:escape/models/temptation_model.dart';
import 'package:escape/providers/current_active_temptation_provider.dart';
import 'package:escape/providers/user_profile_provider.dart';
import 'package:escape/providers/xp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import '../services/temptation_storage_service.dart';
import '../atoms/temptation_page_indicator.dart';
import '../atoms/countdown_timer.dart';
import '../molecules/motivation_card.dart';
import '../molecules/lust_cycle_diagram.dart';
import '../molecules/activity_selector.dart';
import '../atoms/xp_confirmation_dialog.dart';
import '../screens/success_screen.dart';
import '../screens/tawbah_screen.dart';
import 'package:escape/widgets/xp_badge.dart';

class TemptationFlowScreen extends ConsumerStatefulWidget {
  const TemptationFlowScreen({super.key});

  @override
  ConsumerState<TemptationFlowScreen> createState() =>
      _TemptationFlowScreenState();
}

class _TemptationFlowScreenState extends ConsumerState<TemptationFlowScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _selectedTriggers = [];
  final List<String> _helpfulActivities = [];
  final TemptationStorageService _storageService = TemptationStorageService();
  Timer? _timerRefresh;
  bool _isInitialized = false;

  // Activity selection state
  String? _selectedActivity;
  final TextEditingController _customActivityController =
      TextEditingController();
  bool _showCustomActivityField = false;

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
    _customActivityController.dispose();
    _timerRefresh?.cancel();
    super.dispose();
  }

  Future<void> _initializeTemptation() async {
    await _storageService.initialize();

    if (_storageService.hasActiveTemptation()) {
      // Resume existing temptation - let the provider handle loading
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
      // Create new temptation using the provider
      await ref
          .read(currentActiveTemptationProvider.notifier)
          .startTemptation(intensityBefore: 5); // Default intensity
    }

    setState(() {
      _isInitialized = true;
    });
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
    try {
      // Stop timer first
      await _storageService.stopTimer();

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Show confirmation dialog
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => XPConfirmationDialog(
          title: 'Confirm Success',
          content:
              'Are you sure you successfully overcame this temptation? '
              'This will award you 1,000 XP for your victory.',
          xpAmount: 1000,
          xpDescription: 'Successfully overcame temptation',
          onConfirm: () async {
            // Get current temptation from provider and update it
            final currentTemptation = ref
                .read(currentActiveTemptationProvider)
                .value;
            if (currentTemptation != null) {
              final updatedTemptation = currentTemptation.copyWith(
                wasSuccessful: true,
                resolutionNotes:
                    'Successfully overcame temptation through activity: ${currentTemptation.selectedActivity}',
                triggers: _selectedTriggers,
                helpfulActivities: _helpfulActivities,
              );

              await ref
                  .read(currentActiveTemptationProvider.notifier)
                  .completeTemptation(temptation: updatedTemptation);
            }

            // Award XP
            await ref
                .read(xPControllerProvider.notifier)
                .createXP(
                  1000,
                  'Successfully overcame temptation',
                  context: (context.mounted) ? context : null,
                );

            // Pop the dialog
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      );

      // Navigate to success screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      }
    } catch (e) {
      // Handle errors gracefully
      // print('Error in _onSuccess: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
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

  Future<void> _onRelapse() async {
    try {
      // Stop timer first
      await _storageService.stopTimer();

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Show confirmation dialog
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => XPConfirmationDialog(
          title: 'Confirm Relapse',
          content:
              'Are you sure you relapsed? '
              'Don\'t worry - Allah is The Most Merciful! '
              'This will guide you through tawbah and award 200 XP.',
          xpAmount: 200,
          xpDescription: 'Made sincere tawbah',
          onConfirm: () async {
            // Get current temptation from provider and update it
            final currentTemptation = ref
                .read(currentActiveTemptationProvider)
                .value;
            if (currentTemptation != null) {
              final updatedTemptation = currentTemptation.copyWith(
                wasSuccessful: false,
                resolutionNotes: 'Relapsed but made tawbah',
                triggers: _selectedTriggers,
                helpfulActivities: _helpfulActivities,
              );

              await ref
                  .read(currentActiveTemptationProvider.notifier)
                  .completeTemptation(temptation: updatedTemptation);
            }

            // Award XP for tawbah
            await ref
                .read(xPControllerProvider.notifier)
                .createXP(
                  200,
                  'Made sincere tawbah',
                  context: (context.mounted) ? context : null,
                );

            // Pop the dialog
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      );

      // Navigate to tawbah screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TawbahScreen()),
        );
      }
    } catch (e) {
      // Handle errors gracefully
      // print('Error in _onRelapse: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
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
      try {
        // Stop timer first
        await _storageService.stopTimer();

        // Use the currentActiveTemptation provider to cancel temptation
        await ref
            .read(currentActiveTemptationProvider.notifier)
            .cancelTemptation();

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // print('Error in _onCancelSession: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred while canceling.'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  void _onActivitySelected(String activity) {
    setState(() {
      _selectedActivity = activity;
      _showCustomActivityField = activity == 'Something Else';

      // Clear custom activity controller when not "Something Else"
      if (!_showCustomActivityField) {
        _customActivityController.clear();
      }
    });
  }

  Future<void> _startTimerAndProceed() async {
    try {
      String finalActivity;

      if (_selectedActivity == 'Something Else') {
        finalActivity = _customActivityController.text.trim();
      } else {
        finalActivity = _selectedActivity!;
      }

      // Get current temptation from provider and update it with selected activity
      final currentTemptation = ref.read(currentActiveTemptationProvider).value;
      if (currentTemptation != null) {
        final updatedTemptation = currentTemptation.copyWith(
          selectedActivity: finalActivity,
        );

        // Update the temptation using the provider's updateTemptation method
        await ref
            .read(currentActiveTemptationProvider.notifier)
            .updateTemptation(updatedTemptation);

        // Start timer when moving to next page
        _storageService.startTimer(durationMinutes: 30);

        // Start timer refresh to update UI in real-time
        _startTimerRefresh();

        // Navigate to timer page
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      // print('Error in _startTimerAndProceed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while starting timer.'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  bool _canProceedFromActivityPage() {
    if (_selectedActivity == null) return false;

    if (_selectedActivity == 'Something Else') {
      return _customActivityController.text.trim().isNotEmpty;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while initializing
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Watch the current active temptation
    final currentTemptationAsync = ref.watch(currentActiveTemptationProvider);

    return currentTemptationAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: AppTheme.errorRed),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(currentActiveTemptationProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (currentTemptation) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onCancelSession,
            tooltip: 'Cancel Session',
          ),
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
                      return _buildActivityPage(currentTemptation);
                    case 4:
                      return _buildActionPage(currentTemptation);
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

  Widget _buildActivityPage(Temptation? currentTemptation) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose an activity to distract yourself',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTextColor(AppTheme.darkGreen),
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXL),

          ActivitySelector(
            predefinedActivities: [
              ...PredefinedActivities.activityNames,
              'Something Else',
            ],
            selectedActivity: _selectedActivity,
            onActivitySelected: _onActivitySelected,
          ),

          if (_showCustomActivityField) ...[
            const SizedBox(height: AppTheme.spacingL),
            TextField(
              controller: _customActivityController,
              decoration: InputDecoration(
                labelText: 'Enter your custom activity',
                hintText: 'e.g., Call a friend, Read a book...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to update button state
              },
            ),
          ],

          if (_selectedActivity != null) ...[
            const SizedBox(height: AppTheme.spacingL),
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
                    'Selected Activity:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    _selectedActivity == 'Something Else'
                        ? _customActivityController.text.trim()
                        : _selectedActivity!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _getTextColor(AppTheme.darkGreen),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionPage(Temptation? currentTemptation) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentTemptation?.selectedActivity != null
                ? 'Go ${currentTemptation!.selectedActivity!.toLowerCase()} for 30 minutes'
                : 'Select an activity to start timer',
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
              'Timer will start once you proceed from activity selection',
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
                  'Alhamdulillah,\nI destroyed it!',
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
              ).withXPBadge(xpAmount: 1000, badgeColor: AppTheme.primaryGreen),
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
              ).withXPBadge(xpAmount: 200, badgeColor: AppTheme.errorRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerChip(String trigger) {
    final isSelected = _selectedTriggers.contains(trigger);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      side: BorderSide.none,

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
      side: BorderSide.none,
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
              onPressed: _currentPage == 3 && !_canProceedFromActivityPage()
                  ? null // Disable button if can't proceed from activity page
                  : _currentPage == 3
                  ? _startTimerAndProceed // Special handler for activity page
                  : () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: AppTheme.white,
                disabledBackgroundColor: AppTheme.mediumGray,
                disabledForegroundColor: AppTheme.white.withValues(alpha: 0.6),
              ),
              child: Text(_currentPage == 3 ? 'Start Timer' : 'Next'),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}
