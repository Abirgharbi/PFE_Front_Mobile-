import 'dart:io';
import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  static const String cloudName = 'dbkivxzek';
  static const String uploadPreset = 'ARkea-dashboard';
  static const String folder = 'ARkea';

  final Cloudinary cloudinary;

  CloudinaryService()
      : cloudinary = Cloudinary.unsignedConfig(cloudName: cloudName);

  Future<CloudinaryResponse> unsignedUpload({
    required String path,
    ProgressCallback? progressCallback,
  }) async {
    try {
      final fileBytes = await File(path).readAsBytes();

      final response = await cloudinary.unsignedUpload(
        fileBytes: fileBytes,
        resourceType: CloudinaryResourceType.image,
        uploadPreset: uploadPreset,
        folder: folder,
        fileName: path.split('/').last,
        progressCallback: progressCallback,
      );

      return response;
    } catch (e) {
      throw Exception('Erreur lors de l’upload : $e');
    }
  }
}
