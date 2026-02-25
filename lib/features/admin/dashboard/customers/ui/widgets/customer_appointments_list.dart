import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/customer_appointment.dart';

class CustomerAppointmentsList extends StatelessWidget {
  final List<CustomerAppointment> appointments;

  const CustomerAppointmentsList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appointments
          .map((appointment) => _AppointmentCard(appointment: appointment))
          .toList(),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final CustomerAppointment appointment;

  const _AppointmentCard({required this.appointment});

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

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
