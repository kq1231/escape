import 'dart:io';

import 'package:escape/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../profile/services/image_service.dart';
import '../models/onboarding_data.dart';
import '../templates/onboarding_page_template.dart';

class ProfileImageScreen extends StatefulWidget {
  final OnboardingData data;
  final Function(OnboardingData) onNext;
  final VoidCallback onBack;

  const ProfileImageScreen({super.key, required this.data, required this.onNext, required this.onBack});

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
        final relativePath = await _imageService.processAndSaveImage(File(pickedFile.path));

        await _imageService.cleanupOldImages(relativePath);

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

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
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
    final updatedData = widget.data.copyWith(profilePicture: _profileImagePath);
    widget.onNext(updatedData);
  }

  void _handleSkip() {
    widget.onNext(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: 'Profile Picture',
      subtitle: 'Add a profile picture (optional)',
      currentStep: 2,
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppConstants.mediumGray, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXXL),

          // 👇 Avatar with green border & + button
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppConstants.primaryGreen, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: AppConstants.lightGray,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/muslim_icon.png') as ImageProvider,
                    child: _isLoading ? const CircularProgressIndicator() : null,
                  ),
                ),

                // ✨ Add image button at bottom-right
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryGreen.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.spacingM),

          // 🧽 Remove image (optional)
          if (_profileImage != null) TextButton(onPressed: _removeImage, child: const Text('Remove')),

          TextButton(
            onPressed: _handleSkip,
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.darkGreen,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Exo', // 👈 Exo font family
                decoration: TextDecoration.none, // 👈 removes underline
              ),
            ),
            child: const Text('SKIP FOR NOW'),
          ),
        ],
      ),
    );
  }
}
