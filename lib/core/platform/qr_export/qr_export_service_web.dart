import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

import 'qr_export_result.dart';

Future<QrExportResult> exportQrPngImpl({
  required Uint8List bytes,
  required String fileName,
}) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = fileName;

  html.document.body!.children.add(anchor);
  anchor.click();
  html.Url.revokeObjectUrl(url);
  anchor.remove();

  return QrExportResult.saved;
}
