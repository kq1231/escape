import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/services/auth_service.dart';
import 'package:escape/providers/user_profile_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onAuthenticated;

  const LoginScreen({super.key, required this.onAuthenticated});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadUserPreferences();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await AuthService.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _isBiometricAvailable = isAvailable;
      });
    }
  }

  Future<void> _loadUserPreferences() async {
    final userProfile = ref.read(userProfileProvider).value;
    if (userProfile != null) {
      setState(() {
        _isBiometricEnabled = userProfile.biometricEnabled;
      });

      // Auto-trigger biometric authentication if enabled and available
      if (_isBiometricEnabled && _isBiometricAvailable) {
        _authenticateWithBiometrics();
      }
    }
  }

  Future<void> _authenticateWithPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProfile = ref.read(userProfileProvider).value;
      if (userProfile == null) {
        setState(() {
          _errorMessage = 'User profile not found';
          _isLoading = false;
        });
        return;
      }

      final isValid = await AuthService.authenticateWithPassword(
        _passwordController.text,
        userProfile.passwordHash,
      );

      if (isValid) {
        widget.onAuthenticated();
      } else {
        setState(() {
          _errorMessage = 'Invalid password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isAuthenticated = await AuthService.authenticateWithBiometrics();

      if (isAuthenticated) {
        widget.onAuthenticated();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric authentication failed: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen,
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                ),
                child: const Icon(
                  Icons.security,
                  size: 60,
                  color: AppConstants.white,
                ),
              ),

              const SizedBox(height: AppConstants.spacingXXL),

              // Welcome back text
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.darkGreen,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.spacingM),

              Text(
                'Please authenticate to continue',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppConstants.mediumGray),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.spacingXXL),

              // Password form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusL,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _authenticateWithPassword(),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: AppConstants.spacingM),
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingM),
                        decoration: BoxDecoration(
                          color: AppConstants.errorRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                          border: Border.all(
                            color: AppConstants.errorRed.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppConstants.errorRed,
                              size: 20,
                            ),
                            const SizedBox(width: AppConstants.spacingS),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: AppConstants.errorRed,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _authenticateWithPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryGreen,
                    foregroundColor: AppConstants.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingL,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppConstants.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              // Biometric authentication button
              if (_isBiometricAvailable && _isBiometricEnabled) ...[
                const SizedBox(height: AppConstants.spacingL),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingM,
                      ),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingL),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _authenticateWithBiometrics,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Use Biometric'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingL,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusL,
                        ),
                      ),
                      side: BorderSide(color: AppConstants.primaryGreen),
                      foregroundColor: AppConstants.primaryGreen,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
