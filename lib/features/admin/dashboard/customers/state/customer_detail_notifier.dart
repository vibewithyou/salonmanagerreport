import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/customer_appointment.dart';
import '../data/repositories/customer_repository.dart';
import 'customer_providers.dart';

part 'customer_detail_notifier.freezed.dart';

@freezed
class CustomerDetailState with _$CustomerDetailState {
  const factory CustomerDetailState.initial() = _Initial;
  const factory CustomerDetailState.loading() = _Loading;
  const factory CustomerDetailState.loaded(
      List<CustomerAppointment> appointments) = _Loaded;
  const factory CustomerDetailState.error(String message) = _Error;
}

class CustomerDetailNotifier extends StateNotifier<CustomerDetailState> {
  final CustomerRepository _repository;
  final String _customerId;

  CustomerDetailNotifier(this._repository, this._customerId)
      : super(const CustomerDetailState.initial()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    state = const CustomerDetailState.loading();
    try {
      final appointments =
          await _repository.getCustomerAppointments(_customerId);
      state = CustomerDetailState.loaded(appointments);
    } catch (e) {
      state = CustomerDetailState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await loadAppointments();
  }
}

// Provider for customer appointments
final customerAppointmentsProvider = StateNotifierProvider.autoDispose
    .family<CustomerDetailNotifier, CustomerDetailState, String>(
  (ref, customerId) {
    final repository = ref.watch(customerRepositoryProvider);
    return CustomerDetailNotifier(repository, customerId);
  },
);

