import 'avatar_upload_payload.dart';
import 'avatar_picker_service_stub.dart'
    if (dart.library.html) 'avatar_picker_service_web.dart'
    if (dart.library.io) 'avatar_picker_service_io.dart';

Future<AvatarUploadPayload?> pickAvatarUploadPayload() {
  return pickAvatarUploadPayloadImpl();
}
