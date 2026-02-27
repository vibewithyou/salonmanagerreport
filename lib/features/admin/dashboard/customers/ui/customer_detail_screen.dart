import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/booking_media.dart';
import '../data/models/customer_profile.dart';
import '../state/customer_detail_notifier.dart';
import '../state/customer_providers.dart';
import 'customer_form_dialog.dart';
import 'widgets/customer_appointments_list.dart';
import 'widgets/customer_info_card.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final CustomerProfile customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsState = ref.watch(customerAppointmentsProvider(customer.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                        ref.read(customerAppointmentsProvider(customer.id).notifier).refresh();
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
                ref.read(customerAppointmentsProvider(customer.id).notifier).refresh();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Buchungen', icon: Icon(Icons.event)),
              Tab(text: 'Bilder', icon: Icon(Icons.photo_library_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomerInfoCard(customer: customer),
                  const SizedBox(height: 24),
                  appointmentsState.when(
                    initial: () => const Center(child: CircularProgressIndicator()),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (appointments) {
                      if (appointments.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text('Keine Buchungen in den letzten 5 Jahren'),
                            ),
                          ),
                        );
                      }

                      return CustomerAppointmentsList(
                        appointments: appointments,
                        salonId: customer.salonId,
                        customerId: customer.id,
                      );
                    },
                    error: (message) => Text('Fehler beim Laden der Buchungen: $message'),
                  ),
                ],
              ),
            ),
            _CustomerBookingMediaTab(customerId: customer.id),
          ],
        ),
      ),
    );
  }
}

class _CustomerBookingMediaTab extends ConsumerWidget {
  final String customerId;

  const _CustomerBookingMediaTab({required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<BookingMedia>>(
      future: ref.read(customerRepositoryProvider).getBookingMediaForCustomer(customerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Fehler beim Laden der Bilder: ${snapshot.error}'));
        }

        final media = snapshot.data ?? const <BookingMedia>[];
        if (media.isEmpty) {
          return const Center(child: Text('Keine Vorher/Nachher Bilder vorhanden'));
        }

        final grouped = <String, List<BookingMedia>>{};
        for (final item in media) {
          grouped.putIfAbsent(item.appointmentId, () => []).add(item);
        }

        final bookingIds = grouped.keys.toList();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookingIds.length,
          itemBuilder: (context, index) {
            final bookingId = bookingIds[index];
            final entries = grouped[bookingId] ?? const <BookingMedia>[];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buchung: $bookingId', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entries
                          .map(
                            (media) => SizedBox(
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      media.fileUrl,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(media.mediaType == 'before' ? 'Vorher' : 'Nachher'),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
