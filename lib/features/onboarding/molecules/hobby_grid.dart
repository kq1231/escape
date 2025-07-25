import 'package:flutter/material.dart';
import '../constants/onboarding_constants.dart';
import '../constants/onboarding_theme.dart';

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
          padding: const EdgeInsets.symmetric(
            horizontal: OnboardingTheme.spacingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OnboardingConstants.hobbiesTitle,
                style: OnboardingTheme.headlineMedium,
              ),
              const SizedBox(height: OnboardingTheme.spacingS),
              Text(
                OnboardingConstants.hobbiesSubtitle,
                style: OnboardingTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: OnboardingTheme.spacingL),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingTheme.spacingXL,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: OnboardingTheme.spacingM,
              mainAxisSpacing: OnboardingTheme.spacingM,
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
                        ? OnboardingTheme.primaryGreen.withValues(alpha: 0.1)
                        : OnboardingTheme.white,
                    borderRadius: BorderRadius.circular(
                      OnboardingTheme.radiusL,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? OnboardingTheme.primaryGreen
                          : OnboardingTheme.mediumGray,
                      width: 1,
                    ),
                    boxShadow: OnboardingTheme.cardShadow,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(OnboardingTheme.spacingS),
                      child: Text(
                        hobby,
                        style: OnboardingTheme.bodyMedium.copyWith(
                          color: isSelected
                              ? OnboardingTheme.primaryGreen
                              : OnboardingTheme.darkGray,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
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
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingTheme.spacingXL,
            ),
            child: Text(
              OnboardingConstants.selectAtLeastOne,
              style: OnboardingTheme.bodySmall.copyWith(
                color: OnboardingTheme.errorRed,
              ),
            ),
          ),
      ],
    );
  }
}
