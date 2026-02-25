import 'package:image_picker/image_picker.dart';

import 'avatar_upload_payload.dart';

Future<AvatarUploadPayload?> pickAvatarUploadPayloadImpl() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 2048,
    maxHeight: 2048,
    imageQuality: 90,
  );

  if (picked == null) {
    return null;
  }

  final bytes = await picked.readAsBytes();
  const maxBytes = 5 * 1024 * 1024;
  if (bytes.length > maxBytes) {
    throw Exception('file-too-large');
  }

  final fileName = picked.name.toLowerCase();
  final dotIndex = fileName.lastIndexOf('.');
  final extension = dotIndex > -1 ? fileName.substring(dotIndex + 1) : 'jpg';

  String contentType;
  switch (extension) {
    case 'png':
      contentType = 'image/png';
      break;
    case 'jpeg':
    case 'jpg':
      contentType = 'image/jpeg';
      break;
    case 'webp':
      contentType = 'image/webp';
      break;
    default:
      throw Exception('invalid-file-type');
  }

  return AvatarUploadPayload(
    bytes: bytes.toList(),
    extension: extension,
    contentType: contentType,
  );
}
