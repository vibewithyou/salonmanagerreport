import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salonmanager/core/platform/qr_export/qr_export_result.dart';
import 'package:salonmanager/core/platform/qr_export/qr_export_service.dart';
import 'package:salonmanager/features/salon_booking_link/state/salon_booking_link_provider.dart';
import 'package:salonmanager/core/constants/app_colors.dart';

/// Card Widget zur Anzeige des Buchungslinks mit QR-Code
///
/// Zeigt:
/// - Den Buchungslink (mit truncate)
/// - QR-Code für den Link
/// - 3 Buttons: Kopieren, Teilen, Download
class SalonBookingLinkCard extends ConsumerStatefulWidget {
  final String salonId;
  final String basePath;

  const SalonBookingLinkCard({
    required this.salonId,
    required this.basePath,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SalonBookingLinkCard> createState() =>
      _SalonBookingLinkCardState();
}

class _SalonBookingLinkCardState extends ConsumerState<SalonBookingLinkCard> {
  bool _linkCopied = false;

  @override
  Widget build(BuildContext context) {
    final bookingLinkAsync = ref.watch(
      salonBookingLinkProvider(
        (salonId: widget.salonId, basePath: widget.basePath),
      ),
    );

    return bookingLinkAsync.when(
      data: (bookingLink) => _buildCard(context, bookingLink.bookingLink, bookingLink.salonName ?? 'Salon'),
      loading: () => _buildLoadingCard(),
      error: (error, stackTrace) => _buildErrorCard(error.toString()),
    );
  }

  Widget _buildCard(BuildContext context, String bookingLink, String salonName) {
    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Icon und Title
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.share2,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buchungslink teilen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Link antippen oder kopieren',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Direkt kopierbarer Link
            Material(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _copyToClipboard(bookingLink),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          bookingLink,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _linkCopied ? Icons.check_circle : Icons.copy,
                        size: 18,
                        color: _linkCopied ? AppColors.success : AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // QR-Code mit weißer Umrandung
            Center(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: RepaintBoundary(
                  child: QrImageView(
                    data: bookingLink,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons (Wrap verhindert Überlagerungen auf kleinen Breiten)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(bookingLink),
                  icon: Icon(
                    _linkCopied ? Icons.check : Icons.copy,
                    size: 18,
                  ),
                  label: Text(_linkCopied ? 'Kopiert!' : 'Kopieren'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _shareLink(bookingLink),
                  icon: Icon(LucideIcons.share2, size: 18),
                  label: const Text('Teilen'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _downloadQRCode(salonName, bookingLink),
                  icon: Icon(LucideIcons.download, size: 18),
                  label: const Text('QR herunterladen'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            const Text('Buchungslink wird geladen...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fehler beim Laden: $error',
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(String link) async {
    try {
      await Clipboard.setData(ClipboardData(text: link));
      setState(() {
        _linkCopied = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _linkCopied = false;
          });
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Buchungslink kopiert!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Kopieren: $e')),
      );
    }
  }

  Future<void> _shareLink(String link) async {
    try {
      await Share.share(
        link,
        subject: 'Buchungslink für meinen Salon',
      );
    } catch (e) {
      await _copyToClipboard(link);
    }
  }

  Future<void> _downloadQRCode(String salonName, String link) async {
    try {
      final qrPainter = QrPainter(
        data: link,
        version: QrVersions.auto,
        emptyColor: Colors.white,
        color: Colors.black,
      );

      final picData = await qrPainter.toImageData(
        220,
        format: ui.ImageByteFormat.png,
      );

      if (picData != null) {
        final bytes = picData.buffer.asUint8List();
        final fileName = '${salonName.toLowerCase().replaceAll(' ', '-')}-qr-code.png';

        final result = await exportQrPng(bytes: bytes, fileName: fileName);
        if (!mounted) return;

        switch (result) {
          case QrExportResult.saved:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR-Code gespeichert!')),
            );
            break;
          case QrExportResult.shared:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR-Code bereit zum Teilen.')),
            );
            break;
          case QrExportResult.canceled:
            break;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Downloaden: $e')),
      );
    }
  }
}
