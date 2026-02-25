import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:io';

/// Image utility for compression and EXIF removal
class ImageUtils {
  /// Compress image to max size
  static Future<Uint8List> compressImage({
    required Uint8List imageData,
    int maxWidth = 512,
    int maxHeight = 512,
    int quality = 85,
  }) async {
    try {
      // Decode image
      img.Image? image = img.decodeImage(imageData);

      if (image == null) {
        return imageData; // Return original if decode fails
      }

      // Resize if needed
      if (image.width > maxWidth || image.height > maxHeight) {
        image = img.copyResize(
          image,
          width: maxWidth,
          height: maxHeight,
          maintainAspect: true,
        );
      }

      // Encode as JPEG
      return Uint8List.fromList(img.encodeJpg(image, quality: quality));
    } catch (e) {
      // Return original image on error
      return imageData;
    }
  }

  /// Remove EXIF data from image (GDPR compliant)
  static Future<Uint8List> removeExifData({
    required Uint8List imageData,
  }) async {
    try {
      // Decode image
      img.Image? image = img.decodeImage(imageData);

      if (image == null) {
        return imageData;
      }

      // Re-encode without EXIF
      return Uint8List.fromList(img.encodeJpg(image));
    } catch (e) {
      // Return original image on error
      return imageData;
    }
  }

  /// Process image: compress + remove EXIF
  static Future<Uint8List> processImage({
    required Uint8List imageData,
    int maxWidth = 512,
    int maxHeight = 512,
    int quality = 85,
  }) async {
    // First remove EXIF
    var processed = await removeExifData(imageData: imageData);

    // Then compress
    processed = await compressImage(
      imageData: processed,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    );

    return processed;
  }

  /// Get image dimensions
  static Future<Size?> getImageDimensions(Uint8List imageData) async {
    try {
      final image = img.decodeImage(imageData);
      if (image != null) {
        return Size(image.width.toDouble(), image.height.toDouble());
      }
    } catch (e) {
      // Error getting dimensions
    }
    return null;
  }

  /// Validate image file
  static bool isValidImageFile(String path) {
    final validExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    final ext = path.split('.').last.toLowerCase();
    return validExtensions.contains(ext);
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    return file.lengthSync() / (1024 * 1024);
  }
}

class Size {
  final double width;
  final double height;

  Size(this.width, this.height);

  @override
  String toString() => 'Size($width, $height)';
}
