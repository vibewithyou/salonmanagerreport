import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

import 'avatar_upload_payload.dart';

Future<AvatarUploadPayload?> pickAvatarUploadPayloadImpl() async {
  final input = html.FileUploadInputElement()
    ..accept = 'image/png,image/jpeg,image/jpg,image/webp'
    ..multiple = false;

  input.click();
  await input.onChange.first;

  final file = input.files?.isNotEmpty == true ? input.files!.first : null;
  if (file == null) {
    return null;
  }

  const maxBytes = 5 * 1024 * 1024;
  if (file.size > maxBytes) {
    throw Exception('file-too-large');
  }

  final mimeType = file.type.toLowerCase();
  if (!(mimeType == 'image/png' ||
      mimeType == 'image/jpeg' ||
      mimeType == 'image/jpg' ||
      mimeType == 'image/webp')) {
    throw Exception('invalid-file-type');
  }

  final reader = html.FileReader();
  reader.readAsArrayBuffer(file);
  await reader.onLoad.first;

  final buffer = reader.result as ByteBuffer;
  final bytes = Uint8List.view(buffer).toList();

  final fileName = file.name.toLowerCase();
  final dotIndex = fileName.lastIndexOf('.');
  final extension = dotIndex > -1 ? fileName.substring(dotIndex + 1) : 'jpg';

  return AvatarUploadPayload(
    bytes: bytes,
    extension: extension,
    contentType: mimeType,
  );
}
