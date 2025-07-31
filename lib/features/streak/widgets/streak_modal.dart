import 'package:escape/models/streak_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/providers/streak_provider.dart';

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
                  child: _buildCustomButton(
                    context,
                    isSuccess == true,
                    'Yes, I succeeded',
                    AppTheme.successGreen,
                    () {
                      setState(() {
                        isSuccess = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildCustomButton(
                    context,
                    isSuccess == false,
                    'No, I relapsed',
                    AppTheme.errorRed,
                    () {
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
            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: emotions.map((emotion) {
                return ChoiceChip(
                  label: Text(
                    emotion, // Remove toUpperCase()
                    style: TextStyle(
                      color: selectedEmotion == emotion
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                  selected: selectedEmotion == emotion,
                  selectedColor: AppTheme.primaryGreen,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.black
                      : AppTheme.white, // Light grey background
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedEmotion = emotion;
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    side: BorderSide(
                      width: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.transparent
                          : Colors.grey[300]!,
                    ),
                  ),
                );
              }).toList(),
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
              child: ElevatedButton(
                onPressed: isSuccess == null
                    ? null
                    : () async {
                        // Handle submission based on success/relapse
                        if (widget.streak != null) {
                          // Update existing streak
                          // For updating, we need to preserve the count logic
                          if (isSuccess!) {
                            await ref
                                .read(todaysStreakProvider.notifier)
                                .markSuccess(
                                  emotion: selectedEmotion,
                                  moodIntensity: moodIntensity,
                                );
                          } else {
                            await ref
                                .read(todaysStreakProvider.notifier)
                                .markRelapse(
                                  emotion: selectedEmotion,
                                  moodIntensity: moodIntensity,
                                );
                          }
                        } else {
                          // Create new streak
                          if (isSuccess!) {
                            await ref
                                .read(todaysStreakProvider.notifier)
                                .markSuccess(
                                  emotion: selectedEmotion,
                                  moodIntensity: moodIntensity,
                                );
                          } else {
                            await ref
                                .read(todaysStreakProvider.notifier)
                                .markRelapse(
                                  emotion: selectedEmotion,
                                  moodIntensity: moodIntensity,
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  ),
                ),
                child: Text(widget.streak != null ? 'Update' : 'Save'),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],
        ),
      ),
    );
  }

  // Custom button widget similar to emergency button
  Widget _buildCustomButton(
    BuildContext context,
    bool isSelected,
    String text,
    Color selectedColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? selectedColor
            : Theme.of(context).brightness == Brightness.dark
            ? AppTheme.black
            : AppTheme.white,
        foregroundColor: isSelected
            ? AppTheme.white
            : Theme.of(context).brightness == Brightness.dark
            ? AppTheme.white
            : AppTheme.black,
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).brightness == Brightness.dark
                ? AppTheme.white
                : AppTheme.darkGreen,
            width: 2,
          ),
        ),
        elevation: isSelected ? 4 : 2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
