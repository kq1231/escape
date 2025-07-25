import 'package:flutter/material.dart';
import '../atoms/input_field.dart';
import '../constants/onboarding_constants.dart';
import '../constants/onboarding_theme.dart';

class PasswordSetup extends StatefulWidget {
  final String password;
  final String confirmPassword;
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final ValueChanged<bool> onBiometricChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final bool showErrors;

  const PasswordSetup({
    super.key,
    required this.password,
    required this.confirmPassword,
    required this.biometricEnabled,
    required this.notificationsEnabled,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onBiometricChanged,
    required this.onNotificationsChanged,
    this.showErrors = false,
  });

  @override
  State<PasswordSetup> createState() => _PasswordSetupState();
}

class _PasswordSetupState extends State<PasswordSetup> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.password);
    _confirmPasswordController = TextEditingController(
      text: widget.confirmPassword,
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return OnboardingConstants.passwordRequired;
    }
    if (value.length < 6) {
      return OnboardingConstants.passwordTooShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return OnboardingConstants.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: OnboardingTheme.spacingXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OnboardingConstants.securityTitle,
            style: OnboardingTheme.headlineMedium,
          ),
          const SizedBox(height: OnboardingTheme.spacingS),
          Text(
            OnboardingConstants.securitySubtitle,
            style: OnboardingTheme.bodyLarge,
          ),
          const SizedBox(height: OnboardingTheme.spacingL),
          InputField(
            controller: _passwordController,
            hintText: OnboardingConstants.passwordHint,
            obscureText: _obscurePassword,
            onChanged: widget.onPasswordChanged,
            validator: _validatePassword,
            showError: widget.showErrors,
            errorText: _validatePassword(_passwordController.text),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: OnboardingTheme.mediumGray,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(height: OnboardingTheme.spacingM),
          InputField(
            controller: _confirmPasswordController,
            hintText: OnboardingConstants.confirmPasswordHint,
            obscureText: _obscureConfirmPassword,
            onChanged: widget.onConfirmPasswordChanged,
            validator: _validateConfirmPassword,
            showError: widget.showErrors,
            errorText: _validateConfirmPassword(
              _confirmPasswordController.text,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: OnboardingTheme.mediumGray,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          const SizedBox(height: OnboardingTheme.spacingL),
          _buildToggleOption(
            title: OnboardingConstants.enableBiometric,
            value: widget.biometricEnabled,
            onChanged: widget.onBiometricChanged,
          ),
          const SizedBox(height: OnboardingTheme.spacingS),
          _buildToggleOption(
            title: OnboardingConstants.enableNotifications,
            value: widget.notificationsEnabled,
            onChanged: widget.onNotificationsChanged,
          ),
          const SizedBox(height: OnboardingTheme.spacingM),
          Text(
            OnboardingConstants.privacyNote,
            style: OnboardingTheme.bodySmall.copyWith(
              color: OnboardingTheme.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: OnboardingTheme.white,
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
        border: Border.all(
          color: OnboardingTheme.mediumGray.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: SwitchListTile(
        title: Text(title, style: OnboardingTheme.bodyMedium),
        value: value,
        onChanged: onChanged,
        activeColor: OnboardingTheme.primaryGreen,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: OnboardingTheme.spacingM,
        ),
      ),
    );
  }
}
