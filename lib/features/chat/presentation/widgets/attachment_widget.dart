import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';

class AttachmentUploadWidget extends ConsumerStatefulWidget {
  final Function(File file, AttachmentType type) onFilePicked;

  const AttachmentUploadWidget({
    super.key,
    required this.onFilePicked,
  });

  @override
  ConsumerState<AttachmentUploadWidget> createState() => _AttachmentUploadWidgetState();
}

enum AttachmentType { image, video, file }

class _AttachmentUploadWidgetState extends ConsumerState<AttachmentUploadWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AttachmentType>(
      onSelected: (type) => _handleAttachmentType(type),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: AttachmentType.image,
          child: Row(
            children: [
              const Icon(LucideIcons.image, size: 18),
              const SizedBox(width: 8),
              const Text('Photo'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AttachmentType.video,
          child: Row(
            children: [
              const Icon(LucideIcons.video, size: 18),
              const SizedBox(width: 8),
              const Text('Video'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AttachmentType.file,
          child: Row(
            children: [
              const Icon(LucideIcons.file, size: 18),
              const SizedBox(width: 8),
              const Text('Document'),
            ],
          ),
        ),
      ],
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(LucideIcons.paperclip),
    );
  }

  Future<void> _handleAttachmentType(AttachmentType type) async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implementiere File Picker basierend auf Plattform
      // For now, zeige einen Dialog als Placeholder
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Select ${type.name}'),
          content: const Text('File picker integration coming soon'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class AttachmentPreviewWidget extends StatelessWidget {
  final File file;
  final AttachmentType type;
  final VoidCallback onRemove;

  const AttachmentPreviewWidget({
    super.key,
    required this.file,
    required this.type,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildPreviewIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.path.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 18),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewIcon() {
    switch (type) {
      case AttachmentType.image:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        );
      case AttachmentType.video:
        return Icon(
          LucideIcons.video,
          size: 32,
          color: Colors.blue,
        );
      case AttachmentType.file:
        return Icon(
          LucideIcons.file,
          size: 32,
          color: Colors.orange,
        );
    }
  }
}

class AttachmentUploadProgressWidget extends StatelessWidget {
  final String fileName;
  final double progress;
  final VoidCallback onCancel;

  const AttachmentUploadProgressWidget({
    super.key,
    required this.fileName,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(value: progress),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 18),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
