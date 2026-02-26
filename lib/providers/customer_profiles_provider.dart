import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/crm/data/customer_profiles_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final customerProfilesRepositoryProvider = Provider<CustomerProfilesRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CustomerProfilesRepository(client);
});

final customerProfilesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, salonId) async {
  final repo = ref.watch(customerProfilesRepositoryProvider);
  return repo.listCustomers(salonId);
});

final customerDetailProvider = FutureProvider.family<Map<String, dynamic>?, Map<String, String>>((ref, params) async {
  final repo = ref.watch(customerProfilesRepositoryProvider);
  return repo.getCustomerDetail(params['salonId']!, params['customerId']!);
});

final customerBookingsProvider = FutureProvider.family<List<Map<String, dynamic>>, Map<String, String>>((ref, params) async {
  final repo = ref.watch(customerProfilesRepositoryProvider);
  return repo.listCustomerBookings(params['salonId']!, params['customerId']!);
});
