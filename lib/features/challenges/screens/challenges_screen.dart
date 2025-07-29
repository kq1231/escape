import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/challenge_badge.dart';
import '../molecules/challenge_card.dart';
import '../molecules/streak_milestone_card.dart';
import '../templates/challenges_grid.dart';
import '../../../services/local_storage_service.dart';
import '../../../models/app_data.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  int _currentStreak = 0;
  int _totalPoints = 0;
  int _challengesCompleted = 0;
  final List<bool> _achievementBadges = [true, true, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadChallengeData();
  }

  Future<void> _loadChallengeData() async {
    try {
      final appData = await LocalStorageService.loadAppData();
      if (appData != null) {
        setState(() {
          _currentStreak = appData.streak;
          _totalPoints = appData.totalDays * 10; // Simple points calculation
          _challengesCompleted = appData.challengesCompleted;
        });
      }
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading challenge data: $e');
    }
  }

  // Method to refresh data
  // void _refreshData() {
  //   _loadChallengeData();
  // }

  // Check if prayer challenge is completed
  Future<bool> _isPrayerChallengeCompleted() async {
    try {
      final appData = await LocalStorageService.loadAppData();
      return appData?.isPrayerCompleted ?? false;
    } catch (e) {
      // Handle error silently
      debugPrint('Error checking prayer challenge completion: $e');
      return false;
    }
  }

  // Complete a challenge and update app data
  Future<void> _completeChallenge(String challengeName) async {
    try {
      // Load current app data
      final appData = await LocalStorageService.loadAppData() ?? AppData();

      // Update challenges completed count
      final updatedAppData = appData.copyWith(
        challengesCompleted: appData.challengesCompleted + 1,
      );

      // Save updated app data
      await LocalStorageService.saveAppData(updatedAppData);

      // Reload challenge data to update UI
      _loadChallengeData();
    } catch (e) {
      // Handle error silently
      debugPrint('Error completing challenge: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with user stats
            _buildHeaderSection(),
            const SizedBox(height: AppTheme.spacingL),
            // Daily challenges section
            FutureBuilder<bool>(
              future: _isPrayerChallengeCompleted(),
              builder: (context, snapshot) {
                final isPrayerCompleted = snapshot.data ?? false;
                return ChallengesGrid(
                  title: 'Daily Challenges',
                  subtitle: 'Complete these challenges to earn rewards',
                  showViewAllButton: true,
                  onViewAllPressed: () {
                    // Handle view all daily challenges
                  },
                  challengeItems: [
                    ChallengeCard(
                      title: 'Morning Reflection',
                      description: 'Spend 10 minutes in morning reflection',
                      progress: 0.5,
                      rating: 4.5,
                      difficulty: 'Easy',
                      onTap: () {
                        // Handle challenge tap and mark as completed
                        _completeChallenge('Morning Reflection');
                      },
                    ),
                    ChallengeCard(
                      title: 'Complete All Prayers',
                      description: 'Perform all five daily prayers',
                      progress: isPrayerCompleted ? 1.0 : 0.0,
                      rating: 4.9,
                      isCompleted: isPrayerCompleted,
                      difficulty: 'Medium',
                      onTap: () {
                        // Handle challenge tap
                        if (!isPrayerCompleted) {
                          // This challenge is automatically completed when all prayers are done
                          // We don't need to manually complete it
                        }
                      },
                    ),
                    ChallengeCard(
                      title: 'Gratitude Journal',
                      description: 'Write down 3 things you are grateful for',
                      progress: 1.0,
                      rating: 4.8,
                      isCompleted: true,
                      difficulty: 'Easy',
                      onTap: () {
                        // Handle challenge tap
                        _completeChallenge('Gratitude Journal');
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppTheme.spacingL),
            // Streak milestones section
            ChallengesGrid(
              title: 'Streak Milestones',
              subtitle: 'Achieve these milestones to unlock special rewards',
              showViewAllButton: true,
              onViewAllPressed: () {
                // Handle view all streak milestones
              },
              challengeItems: [
                StreakMilestoneCard(
                  streakCount: 7,
                  title: 'Week Warrior',
                  description: 'Maintain a 7-day streak',
                  currentStreak: _currentStreak,
                  rewards: ['Special Badge', '100 Points'],
                  isAchieved: _currentStreak >= 7,
                  onTap: () {
                    // Handle milestone tap
                  },
                ),
                StreakMilestoneCard(
                  streakCount: 30,
                  title: 'Monthly Master',
                  description: 'Maintain a 30-day streak',
                  currentStreak: _currentStreak,
                  rewards: ['Premium Badge', '500 Points'],
                  isAchieved: _currentStreak >= 30,
                  onTap: () {
                    // Handle milestone tap
                  },
                ),
                StreakMilestoneCard(
                  streakCount: 90,
                  title: 'Quarterly Champion',
                  description: 'Maintain a 90-day streak',
                  currentStreak: _currentStreak,
                  rewards: ['Elite Badge', '1000 Points'],
                  isAchieved: _currentStreak >= 90,
                  onTap: () {
                    // Handle milestone tap
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
            // Achievement badges section
            _buildAchievementsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Ahmad!',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppTheme.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: AppTheme.white,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Current Streak', '$_currentStreak days'),
                _buildStatItem('Total Points', '$_totalPoints'),
                _buildStatItem('Completed', '$_challengesCompleted'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Wrap(
          spacing: AppTheme.spacingM,
          runSpacing: AppTheme.spacingM,
          children: [
            ChallengeBadge(
              title: 'A',
              isCompleted: _achievementBadges[0],
              size: 50,
            ),
            ChallengeBadge(
              title: 'B',
              isCompleted: _achievementBadges[1],
              size: 50,
            ),
            ChallengeBadge(
              title: 'C',
              isCompleted: _achievementBadges[2],
              size: 50,
            ),
            ChallengeBadge(
              title: 'D',
              isCompleted: _achievementBadges[3],
              size: 50,
            ),
            ChallengeBadge(
              title: 'E',
              isCompleted: _achievementBadges[4],
              size: 50,
            ),
          ],
        ),
      ],
    );
  }
}
