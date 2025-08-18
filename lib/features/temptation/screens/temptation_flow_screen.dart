import 'package:escape/models/temptation.dart';
import 'package:escape/providers/temptation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import '../services/temptation_storage_service.dart';
import '../atoms/temptation_page_indicator.dart';
import '../atoms/countdown_timer.dart';
import '../molecules/motivation_card.dart';
import '../molecules/lust_cycle_diagram.dart';
import '../molecules/activity_selector.dart';
import 'package:escape/providers/streak_provider.dart';

class TemptationFlowScreen extends ConsumerStatefulWidget {
  const TemptationFlowScreen({super.key});

  @override
  ConsumerState<TemptationFlowScreen> createState() =>
      _TemptationFlowScreenState();
}

class _TemptationFlowScreenState extends ConsumerState<TemptationFlowScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Temptation? _currentTemptation;
  String? _selectedActivity;
  List<String> _selectedTriggers = [];
  List<String> _helpfulActivities = [];
  final TemptationStorageService _storageService = TemptationStorageService();

  // Helper method to get appropriate text color for dark mode
  Color _getTextColor(Color defaultColor) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.white : defaultColor;
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
    super.dispose();
  }

  Future<void> _initializeTemptation() async {
    await _storageService.initialize();

    if (_storageService.hasActiveTemptation()) {
      // Resume existing temptation
      setState(() {
        _selectedActivity = _storageService.getSelectedActivity();
      });
    } else {
      // Create new temptation
      final currentTemptation = await ref.read(createTemptationProvider.future);

      // Store in SharedPreferences
      await _storageService.storeActiveTemptation(
        temptationId: currentTemptation.id,
        startTime: currentTemptation.createdAt,
        intensityBefore: 5, // Default intensity
      );
    }
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
    if (_currentTemptation != null) {
      // Resolve the temptation
      await ref
          .read(activeTemptationsProvider.notifier)
          .resolveTemptation(
            _currentTemptation!.id,
            wasSuccessful: true,
            notes:
                'Successfully overcame temptation through activity: $_selectedActivity',
          );

      // Add triggers and helpful activities if any were selected
      for (final trigger in _selectedTriggers) {
        await ref
            .read(activeTemptationsProvider.notifier)
            .addTrigger(_currentTemptation!.id, trigger);
      }

      for (final activity in _helpfulActivities) {
        await ref
            .read(activeTemptationsProvider.notifier)
            .addHelpfulActivity(_currentTemptation!.id, activity);
      }
    }

    await _storageService.clearActiveTemptation();

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
    // Reset streak immediately
    await ref.read(todaysStreakProvider.notifier).resetStreakDueToRelapse();

    if (_currentTemptation != null) {
      await ref
          .read(activeTemptationsProvider.notifier)
          .resolveTemptation(
            _currentTemptation!.id,
            wasSuccessful: false,
            notes: 'Relapsed but made tawbah',
          );
    }

    await _storageService.clearActiveTemptation();

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('La hawla wa la quwwata illa billah 🌙'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPage == 0 ? 'I Need Help' : 'Temptation Support',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppTheme.white,
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
                ? 'Go do $_selectedActivity for 30 minutes'
                : 'Select an activity above for 30 minutes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTextColor(AppTheme.darkGreen),
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          CountdownTimer(
            minutes: 30,
            onComplete: _onCountdownComplete,
            primaryColor: AppTheme.primaryGreen,
            backgroundColor: AppTheme.lightGreen,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Text(
            'Come back when you\'re done or time is up',
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
                icon: const Icon(Icons.refresh, color: AppTheme.white),
                label: const Text(
                  'I need to\ntry again',
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
              color: AppTheme.lightGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Column(
              children: [
                Text(
                  'Optional: Help us understand better',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(AppTheme.darkGreen),
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
                        color: _getTextColor(AppTheme.darkGreen),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Wrap(
                      spacing: AppTheme.spacingS,
                      runSpacing: AppTheme.spacingS,
                      children: [
                        _buildTriggerChip('Boredom'),
                        _buildTriggerChip('Stress'),
                        _buildTriggerChip('Loneliness'),
                        _buildTriggerChip('Anger'),
                        _buildTriggerChip('Anxiety'),
                        _buildTriggerChip('Social Media'),
                        _buildTriggerChip('Other'),
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
                        color: _getTextColor(AppTheme.darkGreen),
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
    return FilterChip(
      label: Text(trigger),
      selected: isSelected,
      onSelected: (selected) {
        _onTriggerSelected(trigger);
      },
      backgroundColor: AppTheme.lightGreen.withValues(alpha: 0.3),
      selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.5),
      checkmarkColor: AppTheme.white,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.white : _getTextColor(AppTheme.darkGreen),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildHelpfulActivityChip(String activity) {
    final isSelected = _helpfulActivities.contains(activity);
    return FilterChip(
      label: Text(activity),
      selected: isSelected,
      onSelected: (selected) {
        _onHelpfulActivitySelected(activity);
      },
      backgroundColor: AppTheme.lightGreen.withValues(alpha: 0.3),
      selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.5),
      checkmarkColor: AppTheme.white,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.white : _getTextColor(AppTheme.darkGreen),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.white,
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
              child: const Text('Next'),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}
