import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/customer_profile.dart';
import '../state/customer_detail_notifier.dart';
import '../state/customer_providers.dart';
import 'customer_form_dialog.dart';
import 'widgets/customer_info_card.dart';
import 'widgets/customer_appointments_list.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final CustomerProfile customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsState = ref.watch(
      customerAppointmentsProvider(customer.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Bearbeiten',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomerFormDialog(
                  salonId: customer.salonId,
                  existingCustomer: customer,
                  onSave: (updatedCustomer) async {
                    await ref
                        .read(customerRepositoryProvider)
                        .updateCustomer(customer.id, updatedCustomer.toJson());
                    if (context.mounted) {
                      Navigator.pop(context);
                      // Refresh the detail view
                      ref
                          .read(customerAppointmentsProvider(customer.id).notifier)
                          .refresh();
                    }
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Aktualisieren',
            onPressed: () {
              ref
                  .read(customerAppointmentsProvider(customer.id).notifier)
                  .refresh();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Info Card
            CustomerInfoCard(customer: customer),
            const SizedBox(height: 24),

            // Action Button: Create New Appointment
            Card(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: InkWell(
                onTap: () {
                  // Navigate to appointment creation
                  // TODO: Implement navigation to appointment creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Termin erstellen - Coming soon'),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Neuen Termin erstellen',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Erstellen Sie einen neuen Termin für ${customer.firstName}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Appointments Section
            Row(
              children: [
                const Icon(Icons.event, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Vergangene Buchungen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                appointmentsState.maybeWhen(
                  loaded: (appointments) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${appointments.length} ${appointments.length == 1 ? "Buchung" : "Buchungen"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            appointmentsState.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (appointments) {
                if (appointments.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Keine Buchungen in den letzten 5 Jahren',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Navigate to appointment creation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Termin erstellen - Coming soon'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Ersten Termin erstellen'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return CustomerAppointmentsList(appointments: appointments);
              },
              error: (message) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Fehler beim Laden der Buchungen:\n$message',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref
                              .read(customerAppointmentsProvider(customer.id).notifier)
                              .refresh();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
