import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/models/booking_media.dart';
import '../../data/models/customer_appointment.dart';
import '../../state/customer_providers.dart';

class CustomerAppointmentsList extends StatelessWidget {
  final List<CustomerAppointment> appointments;
  final String salonId;
  final String customerId;

  const CustomerAppointmentsList({
    super.key,
    required this.appointments,
    required this.salonId,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appointments
          .map(
            (appointment) => _AppointmentCard(
              appointment: appointment,
              salonId: salonId,
              customerId: customerId,
            ),
          )
          .toList(),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  final CustomerAppointment appointment;
  final String salonId;
  final String customerId;

  const _AppointmentCard({
    required this.appointment,
    required this.salonId,
    required this.customerId,
  });

  Color _getStatusColor() {
    switch (appointment.status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (appointment.status.toLowerCase()) {
      case 'confirmed':
        return 'Bestätigt';
      case 'completed':
        return 'Abgeschlossen';
      case 'cancelled':
        return 'Storniert';
      case 'pending':
        return 'Ausstehend';
      default:
        return appointment.status;
    }
  }

  Future<void> _openBookingDetail(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _BookingMediaSheet(
        appointment: appointment,
        salonId: salonId,
        customerId: customerId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Date and Status
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(appointment.startTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${appointment.displayDate})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor()),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Service Information
            if (appointment.service != null) ...[
              Row(
                children: [
                  Icon(Icons.cut, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.service!.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  if (appointment.service!.durationMinutes != null)
                    Text(
                      '${appointment.service!.durationMinutes} min',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Price
            if (appointment.price != null) ...[
              Row(
                children: [
                  Icon(Icons.euro, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    appointment.formattedPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Notes
            if (appointment.notes != null &&
                appointment.notes!.isNotEmpty) ...[
              const Divider(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.notes!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Appointment Number
            if (appointment.appointmentNumber != null) ...[
              const SizedBox(height: 8),
              Text(
                'Buchungsnummer: ${appointment.appointmentNumber}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontFamily: 'monospace',
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => _openBookingDetail(context, ref),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Booking Detail'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingMediaSheet extends ConsumerStatefulWidget {
  final CustomerAppointment appointment;
  final String salonId;
  final String customerId;

  const _BookingMediaSheet({
    required this.appointment,
    required this.salonId,
    required this.customerId,
  });

  @override
  ConsumerState<_BookingMediaSheet> createState() => _BookingMediaSheetState();
}

class _BookingMediaSheetState extends ConsumerState<_BookingMediaSheet> {
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;

  Future<void> _upload(String mediaType) async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;

    setState(() => _uploading = true);
    try {
      final mimeType = _mimeType(file.name);
      await ref.read(customerRepositoryProvider).uploadBookingMedia(
            salonId: widget.salonId,
            customerId: widget.customerId,
            appointmentId: widget.appointment.id,
            mediaType: mediaType,
            fileBytes: bytes,
            fileName: file.name,
            mimeType: mimeType,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${mediaType == 'before' ? 'Vorher' : 'Nachher'} Bild hochgeladen')),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload fehlgeschlagen: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
      }
    }
  }

  String _mimeType(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Detail – Medien',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _uploading ? null : () => _upload('before'),
                  icon: const Icon(Icons.upload),
                  label: const Text('Vorher hochladen'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _uploading ? null : () => _upload('after'),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Nachher hochladen'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<BookingMedia>>(
            future: ref
                .read(customerRepositoryProvider)
                .getBookingMediaForAppointment(widget.appointment.id),
            builder: (context, snapshot) {
              final media = snapshot.data ?? const <BookingMedia>[];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ));
              }
              if (media.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Noch keine Vorher/Nachher Bilder für diese Buchung.'),
                );
              }
              return SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = media[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.fileUrl,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(item.mediaType == 'before' ? 'Vorher' : 'Nachher'),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
