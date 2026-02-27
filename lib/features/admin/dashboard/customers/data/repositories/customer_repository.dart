import '../datasources/customer_remote_datasource.dart';
import '../models/customer_profile.dart';
import '../models/customer_appointment.dart';
import '../models/booking_media.dart';

class CustomerRepository {
  final CustomerRemoteDatasource _remoteDatasource;

  CustomerRepository(this._remoteDatasource);

  Future<List<CustomerProfile>> getCustomers(String salonId) async {
    print('[CustomerRepo] 📡 Fetching customers for salon: $salonId');
    try {
      final customers = await _remoteDatasource.getCustomers(salonId);
      print('[CustomerRepo] ✅ Fetched ${customers.length} customers');
      return customers;
    } catch (e, stackTrace) {
      print('[CustomerRepo] ❌ Error fetching customers: $e');
      print('[CustomerRepo] Stack trace: $stackTrace');
      throw Exception('Failed to load customers: $e');
    }
  }

  Future<CustomerProfile> createCustomer(CustomerProfile profile) async {
    try {
      return await _remoteDatasource.createCustomer(profile);
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  Future<CustomerProfile> updateCustomer(
      String customerId, Map<String, dynamic> updates) async {
    try {
      return await _remoteDatasource.updateCustomer(customerId, updates);
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await _remoteDatasource.deleteCustomer(customerId);
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }

  Future<void> hardDeleteCustomer(String customerId) async {
    try {
      await _remoteDatasource.hardDeleteCustomer(customerId);
    } catch (e) {
      throw Exception('Failed to permanently delete customer: $e');
    }
  }

  Future<List<CustomerAppointment>> getCustomerAppointments(
      String customerId) async {
    try {
      return await _remoteDatasource.getCustomerAppointments(customerId);
    } catch (e) {
      throw Exception('Failed to load customer appointments: $e');
    }
  }

  Future<List<BookingMedia>> getBookingMediaForCustomer(String customerId) {
    return _remoteDatasource.getBookingMediaForCustomer(customerId);
  }

  Future<List<BookingMedia>> getBookingMediaForAppointment(String appointmentId) {
    return _remoteDatasource.getBookingMediaForAppointment(appointmentId);
  }

  Future<void> uploadBookingMedia({
    required String salonId,
    required String customerId,
    required String appointmentId,
    required String mediaType,
    required List<int> fileBytes,
    required String fileName,
    required String mimeType,
  }) async {
    await _remoteDatasource.validateUpload(
      fileName: fileName,
      mimeType: mimeType,
      fileSize: fileBytes.length,
    );

    await _remoteDatasource.uploadBookingMedia(
      salonId: salonId,
      customerId: customerId,
      appointmentId: appointmentId,
      mediaType: mediaType,
      fileBytes: fileBytes,
      fileName: fileName,
      mimeType: mimeType,
    );
  }
}
