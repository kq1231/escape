import 'package:flutter/material.dart';
import '../constants/onboarding_constants.dart';
import 'package:escape/theme/app_theme.dart';

class HobbyGrid extends StatefulWidget {
  final List<String> selectedHobbies;
  final ValueChanged<List<String>> onHobbiesChanged;
  final bool showError;

  const HobbyGrid({
    super.key,
    required this.selectedHobbies,
    required this.onHobbiesChanged,
    this.showError = false,
  });

  @override
  State<HobbyGrid> createState() => _HobbyGridState();
}

class _HobbyGridState extends State<HobbyGrid> {
  late List<String> _selectedHobbies;

  @override
  void initState() {
    super.initState();
    _selectedHobbies = List.from(widget.selectedHobbies);
  }

  void _toggleHobby(String hobby) {
    setState(() {
      if (_selectedHobbies.contains(hobby)) {
        _selectedHobbies.remove(hobby);
      } else {
        _selectedHobbies.add(hobby);
      }
      widget.onHobbiesChanged(_selectedHobbies);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OnboardingConstants.hobbiesTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 32, // Increased from default headlineMedium size
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                OnboardingConstants.hobbiesSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20, // Increased from default bodyLarge size
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              childAspectRatio: 2.5,
            ),
            itemCount: OnboardingConstants.hobbies.length,
            itemBuilder: (context, index) {
              final hobby = OnboardingConstants.hobbies[index];
              final isSelected = _selectedHobbies.contains(hobby);

              return GestureDetector(
                onTap: () => _toggleHobby(hobby),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                        : AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : AppTheme.mediumGray,
                      width: 1,
                    ),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingS),
                      child: Text(
                        hobby,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.darkGray,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize:
                              18, // Increased from default bodyMedium size
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.showError && _selectedHobbies.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
            child: Text(
              OnboardingConstants.selectAtLeastOne,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
