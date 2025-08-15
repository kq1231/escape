import 'package:flutter/material.dart';
import '../molecules/password_setup.dart';
import '../models/onboarding_data.dart';
import '../templates/onboarding_page_template.dart';

class SecurityScreen extends StatefulWidget {
  final OnboardingData data;
  final Function(OnboardingData) onNext;
  final VoidCallback onBack;

  const SecurityScreen({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  late String _password;
  late String _confirmPassword;
  late bool _biometricEnabled;
  late bool _notificationsEnabled;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _password = widget.data.password;
    _confirmPassword = widget.data.password;
    _biometricEnabled = widget.data.biometricEnabled;
    _notificationsEnabled = widget.data.notificationsEnabled;
  }

  void _handlePasswordChanged(String password) {
    setState(() {
      _password = password;
      _showErrors = false;
    });
  }

  void _handleConfirmPasswordChanged(String confirmPassword) {
    setState(() {
      _confirmPassword = confirmPassword;
      _showErrors = false;
    });
  }

  void _handleBiometricChanged(bool enabled) {
    setState(() {
      _biometricEnabled = enabled;
    });
  }

  void _handleNotificationsChanged(bool enabled) {
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  String? _getPasswordError() {
    if (_password.isEmpty) {
      return 'Password is required';
    }
    if (_password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!_password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!_password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _getConfirmPasswordError() {
    if (_confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (_password != _confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool _isValid() {
    return _getPasswordError() == null && _getConfirmPasswordError() == null;
  }

  void _handleNext() {
    if (!_isValid()) {
      setState(() {
        _showErrors = true;
      });
      return;
    }

    // Update the parent with the security data
    final updatedData = widget.data.copyWith(
      password: _password,
      biometricEnabled: _biometricEnabled,
      notificationsEnabled: _notificationsEnabled,
    );
    widget.onNext(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: '',
      currentStep: 6,
      totalSteps: 7,
      onBack: widget.onBack,
      onNext: _handleNext,
      nextButtonText: 'Complete Setup',
      isNextEnabled: _isValid(),
      child: PasswordSetup(
        password: _password,
        confirmPassword: _confirmPassword,
        biometricEnabled: _biometricEnabled,
        notificationsEnabled: _notificationsEnabled,
        onPasswordChanged: _handlePasswordChanged,
        onConfirmPasswordChanged: _handleConfirmPasswordChanged,
        onBiometricChanged: _handleBiometricChanged,
        onNotificationsChanged: _handleNotificationsChanged,
        showErrors: _showErrors,
      ),
    );
  }
}
