import 'package:escape/models/streak_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/providers/streak_provider.dart';
import 'package:escape/widgets/custom_button.dart';
import 'package:escape/widgets/choice_chip_group.dart';

class StreakModal extends ConsumerStatefulWidget {
  final Streak? streak;

  const StreakModal({super.key, this.streak});

  @override
  ConsumerState<StreakModal> createState() => _StreakModalState();
}

class _StreakModalState extends ConsumerState<StreakModal> {
  // Emotion options
  final List<String> emotions = [
    'happy',
    'sad',
    'anxious',
    'grateful',
    'angry',
    'neutral',
  ];

  // Selected emotion
  late String selectedEmotion;

  // Mood intensity (1-10)
  late int moodIntensity;

  // Success or relapse
  late bool? isSuccess;

  @override
  void initState() {
    super.initState();
    // Initialize with streak data if provided, otherwise use defaults
    if (widget.streak != null) {
      selectedEmotion = widget.streak!.emotion;
      moodIntensity = widget.streak!.moodIntensity;
      isSuccess = widget.streak!.isSuccess;
    } else {
      selectedEmotion = 'neutral';
      moodIntensity = 5;
      isSuccess = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXXL),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.streak != null
                      ? 'Update Daily Check-in'
                      : 'Daily Check-in',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Question
            Text(
              'Did you resist temptations today?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Success/Relapse buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton.success(
                    isSelected: isSuccess == true,
                    text: 'Yes, I succeeded',
                    onPressed: () {
                      setState(() {
                        isSuccess = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: CustomButton.error(
                    isSelected: isSuccess == false,
                    text: 'No, I relapsed',
                    onPressed: () {
                      setState(() {
                        isSuccess = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Mood selection
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Emotion chips
            ChoiceChipGroup(
              options: emotions,
              selectedOption: selectedEmotion,
              onSelected: (emotion) {
                setState(() {
                  selectedEmotion = emotion;
                });
              },
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Mood intensity slider
            Text(
              'Mood Intensity: $moodIntensity',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: moodIntensity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: moodIntensity.toString(),
              onChanged: (value) {
                setState(() {
                  moodIntensity = value.toInt();
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Save button
            SizedBox(
              width: double.infinity,
              child: CustomButton.filled(
                text: widget.streak != null ? 'Update' : 'Save',
                onPressed: isSuccess == null
                    ? () {
                        // Do nothing if success/relapse is not selected
                      }
                    : () {
                        // Update already existing streak
                        if (widget.streak != null) {
                          // If changed to success from relapse, increment count
                          if (widget.streak!.isSuccess == false && isSuccess!) {
                            ref
                                .read(todaysStreakProvider.notifier)
                                .markSuccess(
                                  widget.streak!.copyWith(
                                    emotion: selectedEmotion,
                                    moodIntensity: moodIntensity,
                                    isSuccess: isSuccess,
                                  ),
                                );
                          }
                          // If changed to relapse from success, reset count
                          else if (widget.streak!.isSuccess == true &&
                              isSuccess == false) {
                            ref
                                .read(todaysStreakProvider.notifier)
                                .markRelapse(
                                  widget.streak!.copyWith(
                                    emotion: selectedEmotion,
                                    moodIntensity: moodIntensity,
                                    isSuccess: isSuccess,
                                  ),
                                );
                          } else {
                            // If success did not change, just update the streak
                            ref
                                .read(todaysStreakProvider.notifier)
                                .updateStreak(
                                  widget.streak!.copyWith(
                                    emotion: selectedEmotion,
                                    moodIntensity: moodIntensity,
                                    isSuccess: isSuccess,
                                  ),
                                );
                          }
                        } else {
                          // Create new streak
                          if (isSuccess!) {
                            ref
                                .read(todaysStreakProvider.notifier)
                                .markSuccess(
                                  Streak(
                                    emotion: selectedEmotion,
                                    moodIntensity: moodIntensity,
                                  ),
                                );
                          } else {
                            ref
                                .read(todaysStreakProvider.notifier)
                                .markRelapse(
                                  Streak(
                                    emotion: selectedEmotion,
                                    moodIntensity: moodIntensity,
                                  ),
                                );
                          }
                        }

                        // Close the modal
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }

                        // Show a snackbar confirmation
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isSuccess!
                                    ? 'Great job! Your streak has been updated.'
                                    : 'Don\'t worry, you can try again tomorrow.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.white),
                              ),
                              backgroundColor: isSuccess!
                                  ? AppTheme.successGreen
                                  : AppTheme.errorRed,
                            ),
                          );
                        }
                      },
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],
        ),
      ),
    );
  }
}
