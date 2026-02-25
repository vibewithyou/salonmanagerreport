import 'dart:typed_data';

import 'qr_export_result.dart';

Future<QrExportResult> exportQrPngImpl({
  required Uint8List bytes,
  required String fileName,
}) async {
  return QrExportResult.canceled;
}
