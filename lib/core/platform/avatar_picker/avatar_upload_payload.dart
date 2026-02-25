class AvatarUploadPayload {
  final List<int> bytes;
  final String extension;
  final String contentType;

  const AvatarUploadPayload({
    required this.bytes,
    required this.extension,
    required this.contentType,
  });
}
