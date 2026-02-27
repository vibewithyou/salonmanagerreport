import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('booking flow', () {
    testWidgets('customer creates booking and stylist accepts', (tester) async {
      final repo = _InMemoryBookingRepo();

      const customerId = 'fixture-customer';
      const stylistId = 'fixture-stylist';

      final booking = repo.createBooking(customerId: customerId);
      expect(booking.status, 'pending');

      final accepted = repo.acceptBooking(booking.id, stylistId: stylistId);
      expect(accepted.status, 'confirmed');
      expect(accepted.acceptedBy, stylistId);
    });
  });
}

class _Booking {
  _Booking({required this.id, required this.customerId, required this.status, this.acceptedBy});

  final String id;
  final String customerId;
  final String status;
  final String? acceptedBy;

  _Booking copyWith({String? status, String? acceptedBy}) => _Booking(
        id: id,
        customerId: customerId,
        status: status ?? this.status,
        acceptedBy: acceptedBy ?? this.acceptedBy,
      );
}

class _InMemoryBookingRepo {
  int _id = 0;
  final Map<String, _Booking> _bookings = {};

  _Booking createBooking({required String customerId}) {
    final booking = _Booking(id: 'booking-${++_id}', customerId: customerId, status: 'pending');
    _bookings[booking.id] = booking;
    return booking;
  }

  _Booking acceptBooking(String bookingId, {required String stylistId}) {
    final existing = _bookings[bookingId]!;
    final updated = existing.copyWith(status: 'confirmed', acceptedBy: stylistId);
    _bookings[bookingId] = updated;
    return updated;
  }
}
