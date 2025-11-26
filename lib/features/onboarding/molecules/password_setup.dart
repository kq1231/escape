import 'package:flutter/material.dart';
import '../atoms/input_field.dart';
import '../constants/onboarding_constants.dart';
import 'package:escape/theme/app_constants.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.password);
    _confirmPasswordController = TextEditingController(text: widget.confirmPassword);
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
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return OnboardingConstants.passwordsDoNotMatch;
    }
    return null;
  }

  TextStyle _exo(BuildContext context, TextStyle? style) {
    return (style ?? const TextStyle()).copyWith(fontFamily: 'Exo');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Header
            Text(
              OnboardingConstants.securityTitle,
              style: _exo(
                context,
                Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                      fontSize: 28,
                    ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              OnboardingConstants.securitySubtitle,
              style: _exo(
                context,
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppConstants.darkGray.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // 🧷 Password field
            InputField(
              controller: _passwordController,
              hintText: OnboardingConstants.passwordHint,
              obscureText: _obscurePassword,
              onChanged: (String str) {
                _formKey.currentState!.validate();
                widget.onPasswordChanged(str);
              },
              validator: _validatePassword,
              showError: widget.showErrors,
              errorText: widget.showErrors
                  ? _validatePassword(_passwordController.text)
                  : null,
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: AppConstants.mediumGray,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingM),

            // 🔒 Confirm password field
            InputField(
              controller: _confirmPasswordController,
              hintText: OnboardingConstants.confirmPasswordHint,
              obscureText: _obscureConfirmPassword,
              onChanged: (String str) {
                _formKey.currentState!.validate();
                widget.onConfirmPasswordChanged(str);
              },
              validator: _validateConfirmPassword,
              showError: widget.showErrors,
              errorText: widget.showErrors
                  ? _validateConfirmPassword(_confirmPasswordController.text)
                  : null,
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                child: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: AppConstants.mediumGray,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingL),

            // 📝 Privacy note
            Center(
              child: Text(
                OnboardingConstants.privacyNote,
                style: _exo(
                  context,
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.mediumGray,
                        fontSize: 13,
                      ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),
          ],
        ),
      ),
    );
  }
}
