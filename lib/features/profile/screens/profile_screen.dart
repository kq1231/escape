import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../providers/user_profile_provider.dart';
import '../../../theme/app_theme.dart';
import '../services/image_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _goalsController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _triggersController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _profileImage;
  String _profileImagePath = ''; // Stores the relative path
  bool _isEditing = false;
  final ImageService _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    // Load user profile data when available
    final profileAsync = ref.read(userProfileProvider);
    profileAsync.whenData((profile) {
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name;
          _goalsController.text = profile.goals.join(', ');
          _hobbiesController.text = profile.hobbies.join(', ');
          _triggersController.text = profile.triggers.join(', ');

          // Load profile picture if available
          if (profile.profilePicture.isNotEmpty) {
            _profileImagePath = profile.profilePicture;
            // Get the full path for display
            _getFullImagePath(profile.profilePicture)
                .then((fullPath) {
                  if (mounted) {
                    setState(() {
                      _profileImage = File(fullPath);
                    });
                  }
                })
                .catchError((error) {
                  // If there's an error loading the image, just don't show it
                  debugPrint('Failed to load profile image: $error');
                });
          }
        });
      }
    });
  }

  /// Gets the full path for a relative image path
  Future<String> _getFullImagePath(String relativePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    return path.join(appDir.path, relativePath);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Process and save the image using the image service
        final relativePath = await _imageService.processAndSaveImage(
          File(pickedFile.path),
        );

        // Delete the old image if there was one
        if (_profileImagePath.isNotEmpty) {
          await _imageService.deleteImage(_profileImagePath);
        }

        // Update state with the new image
        final fullPath = await _getFullImagePath(relativePath);
        if (mounted) {
          setState(() {
            _profileImage = File(fullPath);
            _profileImagePath = relativePath;
          });
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Failed to process image';
          if (e is ImageServiceException) {
            errorMessage = e.message;
          } else {
            debugPrint('Unexpected error in _pickImage: $e');
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileAsync = ref.read(userProfileProvider);
      profileAsync.whenData((profile) async {
        if (profile != null) {
          final updatedProfile = profile.copyWith(
            name: _nameController.text.trim(),
            goals: _goalsController.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList(),
            hobbies: _hobbiesController.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList(),
            triggers: _triggersController.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList(),
            profilePicture: _profileImagePath,
            lastUpdated: DateTime.now(),
          );

          await ref
              .read(userProfileProvider.notifier)
              .saveProfile(updatedProfile);

          if (mounted) {
            setState(() {
              _isEditing = false;
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully')),
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalsController.dispose();
    _hobbiesController.dispose();
    _triggersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _isEditing ? _saveProfile : _toggleEdit,
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading profile: $error')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  if (_isEditing) ...[
                    Center(
                      child: TextButton(
                        onPressed: _pickImage,
                        child: const Text('Change Profile Picture'),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Goals Field
                  TextFormField(
                    controller: _goalsController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Goals (comma separated)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Hobbies Field
                  TextFormField(
                    controller: _hobbiesController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Hobbies (comma separated)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Triggers Field
                  TextFormField(
                    controller: _triggersController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Triggers (comma separated)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Streak Goal
                  Text(
                    'Streak Goal: ${profile.streakGoal} days',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Created At
                  Text(
                    'Member since: ${profile.createdAt.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppTheme.spacingM),

                  // Last Updated
                  Text(
                    'Last updated: ${profile.lastUpdated.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
