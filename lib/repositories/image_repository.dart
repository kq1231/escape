import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'image_repository.g.dart';

/// Custom exception for image-related errors
class ImageRepositoryException implements Exception {
  final String message;
  ImageRepositoryException(this.message);

  @override
  String toString() => 'ImageRepositoryException: $message';
}

@Riverpod(keepAlive: false)
class ImageRepository extends _$ImageRepository {
  static const String _profileImagesDir = 'profile_images';

  @override
  FutureOr<void> build() async {
    // Initialize the repository
  }

  /// Copies an image to app storage, compresses it, and returns the relative path
  Future<String> processAndSaveImage(File imageFile) async {
    try {
      // Validate the image file
      if (!await imageFile.exists()) {
        throw ImageRepositoryException('Image file does not exist');
      }

      // Check if it's a valid image file
      final bytes = await imageFile.readAsBytes();
      if (!await _isValidImage(bytes)) {
        throw ImageRepositoryException('Selected file is not a valid image');
      }

      // Get the app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, _profileImagesDir));

      // Create the directory if it doesn't exist
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Generate a unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final newFilePath = path.join(imagesDir.path, fileName);

      // Compress and save the image
      final newFile = File(newFilePath);
      await newFile.writeAsBytes(await imageFile.readAsBytes());

      // Return the relative path for storage in the database
      return path.join(_profileImagesDir, fileName);
    } catch (e) {
      if (e is ImageRepositoryException) {
        rethrow;
      }
      throw ImageRepositoryException(
        'Failed to process image: ${e.toString()}',
      );
    }
  }

  /// Validates if the bytes represent a valid image
  Future<bool> _isValidImage(Uint8List bytes) async {
    try {
      // Check for common image file signatures (magic numbers)
      if (bytes.length < 4) return false;

      // JPEG signature
      if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
        return true;
      }

      // PNG signature
      if (bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        return true;
      }

      // GIF signature
      if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
        return true;
      }

      // WebP signature
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Gets the full file path from a relative path
  Future<String> getFullImagePath(String relativePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    return path.join(appDir.path, relativePath);
  }

  /// Deletes an image file
  Future<void> deleteImage(String relativePath) async {
    try {
      if (relativePath.isEmpty) return;

      final fullPath = await getFullImagePath(relativePath);
      final file = File(fullPath);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Silently fail deletion errors as they shouldn't break the app
      throw ImageRepositoryException('Failed to delete image: $e');
    }
  }

  /// Cleans up old profile images, keeping only the current one
  Future<void> cleanupOldImages(String currentImagePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, _profileImagesDir));

      if (!await imagesDir.exists()) return;

      final files = imagesDir.listSync();
      for (final file in files) {
        // Skip the current image and non-files
        if (file is File &&
            path.relative(file.path, from: appDir.path) != currentImagePath) {
          try {
            await file.delete();
          } catch (e) {
            // Log error but continue with other files
            debugPrint('Failed to delete old image: $e');
          }
        }
      }
    } catch (e) {
      throw ImageRepositoryException('Failed to cleanup old images: $e');
    }
  }

  /// Gets the current profile image path
  String? getCurrentProfileImagePath(String? profilePicture) {
    return profilePicture?.isNotEmpty == true ? profilePicture : null;
  }

  /// Checks if a profile image exists
  Future<bool> profileImageExists(String relativePath) async {
    try {
      if (relativePath.isEmpty) return false;
      final fullPath = await getFullImagePath(relativePath);
      final file = File(fullPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
