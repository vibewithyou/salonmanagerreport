import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/customer_profile.dart';
import '../data/repositories/customer_repository.dart';

part 'customer_list_notifier.freezed.dart';

@freezed
class CustomerListState with _$CustomerListState {
  const factory CustomerListState.initial() = _Initial;
  const factory CustomerListState.loading() = _Loading;
  const factory CustomerListState.loaded(List<CustomerProfile> customers) = _Loaded;
  const factory CustomerListState.error(String message) = _Error;
}

class CustomerListNotifier extends StateNotifier<CustomerListState> {
  final CustomerRepository _repository;
  final String _salonId;
  
  List<CustomerProfile> _allCustomers = [];

  CustomerListNotifier(this._repository, this._salonId)
      : super(const CustomerListState.initial()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    print('[CustomerList] 🔄 Loading customers for salon: $_salonId');
    state = const CustomerListState.loading();
    try {
      _allCustomers = await _repository.getCustomers(_salonId);
      print('[CustomerList] ✅ Loaded ${_allCustomers.length} customers');
      state = CustomerListState.loaded(_allCustomers);
    } catch (e, stackTrace) {
      print('[CustomerList] ❌ Error loading customers: $e');
      print('[CustomerList] Stack trace: $stackTrace');
      state = CustomerListState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await loadCustomers();
  }

  Future<void> createCustomer(CustomerProfile profile) async {
    print('[CustomerList] 🆕 Creating customer: ${profile.firstName} ${profile.lastName}');
    try {
      await _repository.createCustomer(profile);
      print('[CustomerList] ✅ Customer created successfully');
      await loadCustomers(); // Reload list
    } catch (e, stackTrace) {
      print('[CustomerList] ❌ Error creating customer: $e');
      print('[CustomerList] Stack trace: $stackTrace');
      state = CustomerListState.error(e.toString());
    }
  }

  Future<void> updateCustomer(String customerId, Map<String, dynamic> updates) async {
    try {
      await _repository.updateCustomer(customerId, updates);
      await loadCustomers(); // Reload list
    } catch (e) {
      state = CustomerListState.error(e.toString());
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await _repository.deleteCustomer(customerId);
      await loadCustomers(); // Reload list
    } catch (e) {
      state = CustomerListState.error(e.toString());
    }
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      state = CustomerListState.loaded(_allCustomers);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filtered = _allCustomers.where((customer) {
      return customer.firstName.toLowerCase().contains(lowercaseQuery) ||
          customer.lastName.toLowerCase().contains(lowercaseQuery) ||
          (customer.email?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (customer.phone?.contains(query) ?? false);
    }).toList();

    state = CustomerListState.loaded(filtered);
  }
}
