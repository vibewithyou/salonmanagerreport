import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonmanager/features/salon_booking_link/state/salon_booking_link_provider.dart';
import 'package:salonmanager/core/constants/app_colors.dart';

/// Widget für das Booking-Enable/Disable Toggle in den Saloneinstellungen
///
/// Wird in SalonSettingsTab eingebettet und erlaubt dem Admin,
/// die öffentliche Buchung zu aktivieren/deaktivieren
class SalonBookingEnabledToggle extends ConsumerStatefulWidget {
  final String salonId;
  final VoidCallback? onChanged;

  const SalonBookingEnabledToggle({
    required this.salonId,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SalonBookingEnabledToggle> createState() =>
      _SalonBookingEnabledToggleState();
}

class _SalonBookingEnabledToggleState
    extends ConsumerState<SalonBookingEnabledToggle> {
  bool _isSaving = false;
  bool? _pendingValue;

  Future<void> _updateBookingEnabled(bool newValue, bool previousValue) async {
    setState(() {
      _isSaving = true;
      _pendingValue = newValue;
    });

    try {
      final repository = ref.read(salonBookingLinkRepositoryProvider);
      await repository.updateBookingEnabled(widget.salonId, newValue);

      ref.invalidate(salonBookingEnabledProvider(widget.salonId));
      await ref.read(salonBookingEnabledProvider(widget.salonId).future);

      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _pendingValue = null;
      });

      widget.onChanged?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newValue
                ? 'Öffentliche Buchung aktiviert'
                : 'Öffentliche Buchung deaktiviert',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _pendingValue = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingEnabledAsync =
        ref.watch(salonBookingEnabledProvider(widget.salonId));

    final serverValue = bookingEnabledAsync.asData?.value;
    final currentValue = _isSaving
        ? (_pendingValue ?? serverValue ?? true)
        : (serverValue ?? _pendingValue ?? true);

    if (bookingEnabledAsync.isLoading && serverValue == null && _pendingValue == null) {
      return _buildLoadingState();
    }

    if (bookingEnabledAsync.hasError && serverValue == null && _pendingValue == null) {
      return _buildErrorState(bookingEnabledAsync.error.toString());
    }

    return _buildToggle(context, currentValue);
  }

  Widget _buildToggle(
    BuildContext context,
    bool currentValue,
  ) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Öffentliche Buchung aktivieren',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentValue
                        ? 'Kunden können über den Link, die Karte und die Listenbuchung einen Termin buchen'
                        : 'Nur Mitarbeiter und Admin können Termine buchen',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: currentValue,
              onChanged: _isSaving
                  ? null
                  : (newValue) => _updateBookingEnabled(newValue, currentValue),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            const Text('Einstellung wird geladen...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
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
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
