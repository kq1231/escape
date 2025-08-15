import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/onboarding_data.dart';
import '../templates/onboarding_page_template.dart';
import '../../profile/services/image_service.dart';
import 'package:escape/theme/app_theme.dart';

class ProfileImageScreen extends StatefulWidget {
  final OnboardingData data;
  final Function(OnboardingData) onNext;
  final VoidCallback onBack;

  const ProfileImageScreen({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ProfileImageScreen> createState() => _ProfileImageScreenState();
}

class _ProfileImageScreenState extends State<ProfileImageScreen> {
  File? _profileImage;
  String _profileImagePath = '';
  final ImageService _imageService = ImageService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingImage();
  }

  void _loadExistingImage() {
    if (widget.data.profilePicture.isNotEmpty) {
      _imageService
          .getFullImagePath(widget.data.profilePicture)
          .then((fullPath) {
            if (mounted) {
              setState(() {
                _profileImagePath = widget.data.profilePicture;
                _profileImage = File(fullPath);
              });
            }
          })
          .catchError((error) {
            // If there's an error loading the image, just don't show it
            debugPrint('Failed to load profile image: $error');
          });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Process and save the image using the image service
        final relativePath = await _imageService.processAndSaveImage(
          File(pickedFile.path),
        );

        // Clean up old images to ensure only the current one exists
        await _imageService.cleanupOldImages(relativePath);

        // Update state with the new image
        final fullPath = await _imageService.getFullImagePath(relativePath);
        if (mounted) {
          setState(() {
            _profileImage = File(fullPath);
            _profileImagePath = fullPath;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          String errorMessage = 'Failed to process image';
          if (e is ImageServiceException) {
            errorMessage = e.message;
          } else {
            debugPrint('Unexpected error in _pickImage: $e');
          }

          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorMessage)));
          }
        }
      }
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
      _profileImagePath = '';
    });
  }

  void _handleNext() {
    // Update the data with the profile picture path
    final updatedData = widget.data.copyWith(profilePicture: _profileImagePath);
    widget.onNext(updatedData);
  }

  void _handleSkip() {
    // Skip without setting a profile picture
    widget.onNext(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: 'Profile Picture',
      subtitle: 'Add a profile picture (optional)',
      currentStep: 3,
      totalSteps: 7,
      onBack: widget.onBack,
      onNext: _handleNext,
      nextButtonText: 'Continue',
      isNextEnabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Make your profile more personal by adding a profile picture. This step is completely optional.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXXL),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: AppTheme.lightGray,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 80,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          )
                        : null,
                  ),
                  if (_isLoading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _pickImage,
                child: const Text('Choose Photo'),
              ),
              if (_profileImage != null) ...[
                const SizedBox(width: AppTheme.spacingM),
                TextButton(
                  onPressed: _removeImage,
                  child: const Text('Remove'),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          TextButton(onPressed: _handleSkip, child: const Text('Skip for now')),
        ],
      ),
    );
  }
}
