import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';

class QRCheckInWidget extends ConsumerStatefulWidget {
  const QRCheckInWidget({super.key});

  @override
  ConsumerState<QRCheckInWidget> createState() => _QRCheckInWidgetState();
}

class _QRCheckInWidgetState extends ConsumerState<QRCheckInWidget> {
  final TextEditingController _pinController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QR-Code Check-in',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Scanne den QR-Code am Salon-Eingang oder nutze die PIN-Eingabe',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // QR Scanner Card
        _buildQRScannerCard(context),

        const SizedBox(height: 24),

        // Divider with text
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ODER',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: 24),

        // PIN Entry Card
        _buildPINEntryCard(context),

        const SizedBox(height: 32),

        // Info Card
        _buildInfoCard(context),
      ],
    );
  }

  Widget _buildQRScannerCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: _isScanning
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
              child: _isScanning
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Scanner aktiv...',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    )
                  : Icon(
                      LucideIcons.qrCode,
                      size: 80,
                      color: Colors.grey[400],
                    ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _startQRScanner,
                icon: Icon(
                  _isScanning ? LucideIcons.loader : LucideIcons.camera,
                ),
                label: Text(
                  _isScanning ? 'Scanner läuft...' : 'QR-Code scannen',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPINEntryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.keyRound, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'PIN-Eingabe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'Salon-PIN eingeben',
                hintText: '1234',
                prefixIcon: const Icon(LucideIcons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pinController.text.length == 4 ? _checkInWithPIN : null,
                icon: const Icon(LucideIcons.check),
                label: const Text('Mit PIN einchecken'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: AppColors.info.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.info, color: AppColors.info, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'So funktioniert\'s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Scanne den QR-Code am Salon-Eingang\n'
                    '2. Oder gib die 4-stellige Salon-PIN ein\n'
                    '3. Deine Arbeitszeit wird automatisch erfasst',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startQRScanner() async {
    setState(() => _isScanning = true);

    try {
      // TODO: Implement QR scanner with mobile_scanner package
      // For now, simulate scanning
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('QR-Scanner noch nicht implementiert'),
            backgroundColor: AppColors.warning,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  Future<void> _checkInWithPIN() async {
    final pin = _pinController.text;

    if (pin.isEmpty || pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bitte gib eine 4-stellige PIN ein'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // TODO: Verify PIN and check in
    // For now, simulate check-in
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PIN-Check-in erfolgreich'),
          backgroundColor: AppColors.success,
        ),
      );
      _pinController.clear();
    }
  }
}
