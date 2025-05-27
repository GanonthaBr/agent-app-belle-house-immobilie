import 'dart:io';
import 'package:agent_app_belle_house_immobilier/services/api_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  // Pick single image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      return image;
    } on PlatformException catch (e) {
      throw Exception('Erreur lors de la sélection de l\'image: ${e.message}');
    }
  }

  // Pick single image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      return image;
    } on PlatformException catch (e) {
      throw Exception('Erreur lors de la prise de photo: ${e.message}');
    }
  }

  // Pick multiple images from gallery
  Future<List<XFile>> pickMultipleImages({int maxImages = 10}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (images.length > maxImages) {
        return images.take(maxImages).toList();
      }

      return images;
    } on PlatformException catch (e) {
      throw Exception('Erreur lors de la sélection des images: ${e.message}');
    }
  }

  // Show image source selection dialog
  Future<XFile?> showImageSourceDialog() async {
    // This would typically show a dialog to choose between camera and gallery
    // For now, we'll default to gallery
    return await pickImageFromGallery();
  }

  // Upload image to server
  Future<String?> uploadImage(File imageFile, String token) async {
    try {
      final response = await _apiService.uploadImage(imageFile, token);

      if (response.success && response.data != null) {
        return response.data;
      } else {
        throw Exception(response.message ?? 'Erreur lors de l\'upload');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image: $e');
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
      List<File> imageFiles, String token) async {
    List<String> uploadedUrls = [];

    for (File imageFile in imageFiles) {
      try {
        final url = await uploadImage(imageFile, token);
        if (url != null) {
          uploadedUrls.add(url);
        }
      } catch (e) {
        print('Erreur lors de l\'upload de ${imageFile.path}: $e');
        // Continue with other images even if one fails
      }
    }

    return uploadedUrls;
  }

  // Validate image file
  bool isValidImageFile(File file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif');
  }

  // Get image file size in MB
  double getImageSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  // Check if image is within size limit
  bool isImageSizeValid(File file, {double maxSizeMB = 10.0}) {
    return getImageSizeInMB(file) <= maxSizeMB;
  }

  // Get image dimensions (would require additional package like image)
  // For now, we'll skip this functionality
}
