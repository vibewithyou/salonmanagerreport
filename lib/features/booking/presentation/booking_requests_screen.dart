import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({Key? key}) : super(key: key);

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {
  bool _loading = false;
  // TODO: Replace with real provider
  List<Map<String, String>> bookings = [
    {
      'id': '1',
      'customer': 'Anna',
      'status': 'pending',
      'service': 'Haircut',
      'time': '2026-02-27 10:00',
    },
    {
      'id': '2',
      'customer': 'Ben',
      'status': 'pending',
      'service': 'Color',
      'time': '2026-02-27 11:00',
    },
  ];

  Future<void> _updateStatus(int index, String newStatus) async {
    setState(() => _loading = true);
    final booking = bookings[index];
    try {
      // TODO: Call BookingRepository().updateBookingStatus(booking['id'], newStatus)
      // TODO: Call NotificationRepository().createNotification(...)
      await Future.delayed(const Duration(seconds: 1)); // Simulate network
      setState(() {
        bookings[index]['status'] = newStatus;
      });
      // TODO: Invalidate provider
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Requests')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: _StatusBadge(status: booking['status']!),
                    title: Text('${booking['customer']} - ${booking['service']}'),
                    subtitle: Text(booking['time']!),
                    trailing: booking['status'] == 'pending'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: _loading
                                    ? null
                                    : () => _updateStatus(index, 'accepted'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: _loading
                                    ? null
                                    : () => _updateStatus(index, 'declined'),
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.amber;
        break;
      case 'accepted':
        color = Colors.green;
        break;
      case 'declined':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
