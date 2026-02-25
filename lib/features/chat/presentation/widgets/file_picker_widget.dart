import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FilePickerIntegration {
  static const int maxFileSizeMB = 50;
  static const int maxImageSizeMB = 10;

  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    bool compress = true,
  }) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: compress ? 85 : 100,
      );
      if (image == null) return null;

      final file = File(image.path);
      if (file.lengthSync() > maxImageSizeMB * 1024 * 1024) {
        throw Exception('Image size exceeds $maxImageSizeMB MB limit');
      }
      return file;
    } catch (_) {
      return null;
    }
  }

  static Future<File?> pickVideo({Duration? maxDuration}) async {
    try {
      final picker = ImagePicker();
      final video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: maxDuration,
      );
      if (video == null) return null;

      final file = File(video.path);
      if (file.lengthSync() > maxFileSizeMB * 1024 * 1024) {
        throw Exception('Video size exceeds $maxFileSizeMB MB limit');
      }
      return file;
    } catch (_) {
      return null;
    }
  }

  static Future<List<File>> pickMultipleImages({bool compress = true}) async {
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage(
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: compress ? 85 : 100,
      );
      if (images.isEmpty) return [];

      final files = <File>[];
      for (final image in images) {
        final file = File(image.path);
        if (file.lengthSync() <= maxImageSizeMB * 1024 * 1024) {
          files.add(file);
        }
      }
      return files;
    } catch (_) {
      return [];
    }
  }

  static Future<File?> pickFile({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return null;

      final path = result.files.single.path;
      if (path == null || path.isEmpty) return null;
      final file = File(path);
      if (file.lengthSync() > maxFileSizeMB * 1024 * 1024) {
        throw Exception('File size exceeds $maxFileSizeMB MB limit');
      }
      return file;
    } catch (_) {
      return null;
    }
  }

  static Future<File?> pickDocument() async {
    return pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );
  }

  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  static bool isImage(File file) {
    final ext = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  static bool isVideo(File file) {
    final ext = file.path.toLowerCase().split('.').last;
    return ['mp4', 'avi', 'mov', 'mkv', 'wmv', 'flv'].contains(ext);
  }

  static bool isDocument(File file) {
    final ext = file.path.toLowerCase().split('.').last;
    return ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].contains(ext);
  }
}

enum AttachmentType { image, video, document, audio }

class AdvancedFilePickerButton extends ConsumerStatefulWidget {
  final Function(File file, AttachmentType type) onFilePicked;
  final Function(List<File> files)? onMultipleFilesPicked;
  final bool allowMultiple;
  final bool allowCompressionToggle;

  const AdvancedFilePickerButton({
    super.key,
    required this.onFilePicked,
    this.onMultipleFilesPicked,
    this.allowMultiple = false,
    this.allowCompressionToggle = false,
  });

  @override
  ConsumerState<AdvancedFilePickerButton> createState() =>
      _AdvancedFilePickerButtonState();
}

class _AdvancedFilePickerButtonState
    extends ConsumerState<AdvancedFilePickerButton> {
  bool _isLoading = false;
  bool _enableCompression = true;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : PopupMenuButton<AttachmentType>(
            onSelected: _handleAttachmentType,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: AttachmentType.image,
                child: Text('Photo'),
              ),
              const PopupMenuItem(
                value: AttachmentType.video,
                child: Text('Video'),
              ),
              const PopupMenuItem(
                value: AttachmentType.document,
                child: Text('Document'),
              ),
            ],
            child: Icon(
              LucideIcons.paperclip,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
  }

  Future<void> _handleAttachmentType(AttachmentType type) async {
    setState(() => _isLoading = true);
    try {
      switch (type) {
        case AttachmentType.image:
          if (widget.allowMultiple) {
            final files = await FilePickerIntegration.pickMultipleImages(
              compress: _enableCompression,
            );
            if (files.isNotEmpty) {
              widget.onMultipleFilesPicked?.call(files);
            }
          } else {
            final file = await FilePickerIntegration.pickImage(
              compress: _enableCompression,
            );
            if (file != null) {
              widget.onFilePicked(file, AttachmentType.image);
            }
          }
          break;
        case AttachmentType.video:
          final video = await FilePickerIntegration.pickVideo();
          if (video != null) {
            widget.onFilePicked(video, AttachmentType.video);
          }
          break;
        case AttachmentType.document:
          final file = await FilePickerIntegration.pickDocument();
          if (file != null) {
            widget.onFilePicked(file, AttachmentType.document);
          }
          break;
        case AttachmentType.audio:
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class AdvancedAttachmentPreview extends StatelessWidget {
  final File file;
  final AttachmentType type;
  final VoidCallback onRemove;
  final bool showSize;

  const AdvancedAttachmentPreview({
    super.key,
    required this.file,
    required this.type,
    required this.onRemove,
    this.showSize = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        FilePickerIntegration.isImage(file)
            ? LucideIcons.image
            : FilePickerIntegration.isVideo(file)
                ? LucideIcons.video
                : LucideIcons.file,
      ),
      title: Text(file.path.split('/').last),
      subtitle: showSize
          ? Text(FilePickerIntegration.getFileSizeString(file.lengthSync()))
          : null,
      trailing: IconButton(
        icon: const Icon(LucideIcons.x),
        onPressed: onRemove,
      ),
    );
  }
}

class AttachmentUploadProgress extends StatelessWidget {
  final String fileName;
  final double progress;
  final bool isComplete;

  const AttachmentUploadProgress({
    super.key,
    required this.fileName,
    required this.progress,
    this.isComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: isComplete ? 1.0 : progress,
          minHeight: 6,
        ),
      ],
    );
  }
}
