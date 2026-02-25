import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/customer_remote_datasource.dart';
import '../data/repositories/customer_repository.dart';
import 'customer_list_notifier.dart';

// Supabase client provider (should be defined globally, but included here for reference)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Datasource provider
final customerRemoteDatasourceProvider =
    Provider<CustomerRemoteDatasource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return CustomerRemoteDatasource(supabase);
});

// Repository provider
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final datasource = ref.watch(customerRemoteDatasourceProvider);
  return CustomerRepository(datasource);
});

// Customer List State Provider
final customerListProvider = StateNotifierProvider.autoDispose
    .family<CustomerListNotifier, CustomerListState, String>(
  (ref, salonId) {
    final repository = ref.watch(customerRepositoryProvider);
    return CustomerListNotifier(repository, salonId);
  },
);

// Search query provider
final customerSearchQueryProvider = StateProvider<String>((ref) => '');
