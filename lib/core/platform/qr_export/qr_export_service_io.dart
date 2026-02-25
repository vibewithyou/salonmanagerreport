import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'qr_export_result.dart';

Future<QrExportResult> exportQrPngImpl({
  required Uint8List bytes,
  required String fileName,
}) async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final selectedPath = await FilePicker.platform.saveFile(
      dialogTitle: 'QR-Code speichern',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: const ['png'],
    );

    if (selectedPath == null || selectedPath.isEmpty) {
      return QrExportResult.canceled;
    }

    await File(selectedPath).writeAsBytes(bytes, flush: true);
    return QrExportResult.saved;
  }

  final shareResult = await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          bytes,
          mimeType: 'image/png',
          name: fileName,
        ),
      ],
      text: 'QR-Code für Buchungslink',
      subject: 'QR-Code',
    ),
  );

  if (shareResult.status == ShareResultStatus.dismissed) {
    return QrExportResult.canceled;
  }

  return QrExportResult.shared;
}
