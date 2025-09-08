import 'package:flutter/material.dart';
import '../atoms/emergency_button.dart';
import '../atoms/tip_card.dart';
import '../molecules/contact_selector.dart';
import '../molecules/tips_carousel.dart';
import '../../temptation/screens/temptation_flow_screen.dart';
import 'package:escape/theme/app_constants.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      ContactOption(
        name: 'Call Trusted Friend',
        icon: Icons.person,
        phoneNumber: '123-456-7890',
      ),
      ContactOption(
        name: 'Call Family Member',
        icon: Icons.family_restroom,
        phoneNumber: '098-765-4321',
      ),
      ContactOption(
        name: 'Call Helpline',
        icon: Icons.phone,
        phoneNumber: '988',
      ),
    ];

    final tips = [
      TipItem(
        title: 'Breathe Deeply',
        content:
            'Take 10 deep breaths slowly. Inhale for 4 counts, hold for 4, exhale for 4.',
        icon: Icons.air,
      ),
      TipItem(
        title: 'Distract Yourself',
        content:
            'Engage in an activity that requires focus like a puzzle or reading.',
        icon: Icons.games,
      ),
      TipItem(
        title: 'Pray or Meditate',
        content:
            'Connect with your faith through prayer or meditation for inner peace.',
        icon: Icons.favorite,
      ),
      TipItem(
        title: 'Go for a Walk',
        content:
            'Physical movement can help reduce tension and clear your mind.',
        icon: Icons.directions_walk,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Help',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
        // backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppConstants.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'In a moment of weakness?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26, // Increased from default headlineSmall size
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re not alone. Reach out for support or try these techniques.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18, // Increased from default bodyMedium size
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: EmergencyButton(
                text: 'I Need Help',
                icon: Icons.favorite,
                onPressed: () {
                  // Navigate to temptation flow screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TemptationFlowScreen(),
                    ),
                  );
                },
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 32),
            ContactSelector(
              contacts: contacts,
              onContactSelected: (contact) {
                // Handle contact selection by showing a snackbar with contact info
                String contactInfo = contact.phoneNumber != null
                    ? 'Calling ${contact.name} at ${contact.phoneNumber}'
                    : 'Contacting ${contact.name}';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(contactInfo),
                    backgroundColor: AppConstants.primaryGreen,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            TipsCarousel(tips: tips, title: 'Coping Strategies'),
            const SizedBox(height: 32),
            Text(
              'Remember',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26, // Increased from default headlineSmall size
              ),
            ),
            const SizedBox(height: 16),
            const TipCard(
              title: 'Strength in Faith',
              content:
                  'Allah is with those who restrain themselves. (Quran 65:3)',
              icon: Icons.lightbulb,
            ),
          ],
        ),
      ),
    );
  }
}
