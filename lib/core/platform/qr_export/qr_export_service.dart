import 'dart:typed_data';

import 'qr_export_result.dart';
import 'qr_export_service_stub.dart'
    if (dart.library.html) 'qr_export_service_web.dart'
    if (dart.library.io) 'qr_export_service_io.dart';

Future<QrExportResult> exportQrPng({
  required Uint8List bytes,
  required String fileName,
}) {
  return exportQrPngImpl(bytes: bytes, fileName: fileName);
}
