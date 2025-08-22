// Onboarding Constants - Islamic and App-specific text constants
class OnboardingConstants {
  // Welcome Screen
  static const String islamicGreeting =
      'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللهِ وَبَرَكَاتُهُ';
  static const String welcomeTitle = 'Welcome to Your Journey of Healing';
  static const String welcomeSubtitle =
      'May Allah guide you towards purity and righteousness';
  static const String welcomeDescription =
      'You\'ve taken the best step towards destroying harmful habits! '
      'Get ready to transform your life!';
  static const String letsGoButton = 'Let\'s Begin This Journey';

  // Goals Screen
  static const String goalsTitle = 'What Are Your Goals?';
  static const String goalsSubtitle =
      'Help us understand what you want to achieve';
  static const List<String> goals = [
    'Get rid of pornography',
    'Build stronger willpower',
    'Strengthen my faith',
    'Improve mental health',
    'Better relationships',
    'Increase productivity',
    'Feel more confident',
  ];

  // Hobbies Screen
  static const String hobbiesTitle = 'What Do You Enjoy?';
  static const String hobbiesSubtitle =
      'We\'ll suggest healthy alternatives based on your interests';
  static const List<String> hobbies = [
    'Reading Quran',
    'Sports & Exercise',
    'Learning new skills',
    'Creative arts',
    'Nature walks',
    'Meditation & Prayer',
    'Social activities',
    'Listenting to Nasheeds',
    'Cooking',
    'Writing',
    'Photography',
    'Volunteering',
  ];

  // Triggers Screen
  static const String triggersTitle = 'What Are Your Triggers?';
  static const String triggersSubtitle =
      'Understanding your triggers helps us provide better support';
  static const List<String> triggers = [
    'Late night browsing',
    'Being alone',
    'Stress & anxiety',
    'Boredom',
    'Social media',
    'Certain websites',
    'Specific locations',
    'Emotional distress',
    'Relationship issues',
    'Work pressure',
  ];

  // Security Screen
  static const String securityTitle = 'Set Up Your Security';
  static const String securitySubtitle =
      'Keep your progress private and secure';
  static const String passwordHint = 'Create a secure password';
  static const String confirmPasswordHint = 'Confirm your password';
  static const String privacyNote = 'Your data is encrypted and never shared';

  // Progress indicators
  static const String step1 = 'Welcome';
  static const String step2 = 'Name';
  static const String step3 = 'Profile';
  static const String step4 = 'Goals';
  static const String step5 = 'Hobbies';
  static const String step6 = 'Triggers';
  static const String step7 = 'Security';
  static const List<String> steps = [
    step1,
    step2,
    step3,
    step4,
    step5,
    step6,
    step7,
  ];

  // Validation messages
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String selectAtLeastOne = 'Please select at least one option';
}
