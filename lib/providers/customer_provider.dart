import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer_model.dart';
import '../services/supabase_service.dart';

// Supabase Service Provider
final customerSupabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

// All customers for current salon
final customersProvider = FutureProvider<List<Customer>>((ref) async {
  final supabaseService = ref.watch(customerSupabaseServiceProvider);

  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];

    // Get salon ID
    final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();

    final salonId = salonResponse['id'];

    // Get all customers
    final response = await supabaseService.client
        .from('customers')
        .select()
        .eq('salon_id', salonId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => Customer.fromJson(e))
        .toList();
  } catch (e) {
    return [];
  }
});

// Search customers
final searchCustomersProvider = FutureProvider.family<List<Customer>, String>((ref, query) async {
  if (query.isEmpty) {
    return ref.watch(customersProvider).maybeWhen(
          data: (customers) => customers,
          orElse: () => [],
        );
  }

  final supabaseService = ref.watch(customerSupabaseServiceProvider);

  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];

    // Get salon ID
    final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();

    final salonId = salonResponse['id'];

    // Search by name or phone
    final response = await supabaseService.client
        .from('customers')
        .select()
        .eq('salon_id', salonId)
        .or('first_name.ilike.%$query%,last_name.ilike.%$query%,phone.ilike.%$query%')
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => Customer.fromJson(e))
        .toList();
  } catch (e) {
    return [];
  }
});

// Single customer detail
final customerDetailProvider = FutureProvider.family<Customer?, String>((ref, customerId) async {
  final supabaseService = ref.watch(customerSupabaseServiceProvider);

  try {
    final response = await supabaseService.client
        .from('customers')
        .select()
        .eq('id', customerId)
        .single();

    return Customer.fromJson(response);
  } catch (e) {
    return null;
  }
});

// Customer statistics
final customerSummaryProvider = FutureProvider<CustomerSummary>((ref) async {
  final supabaseService = ref.watch(customerSupabaseServiceProvider);

  try {
    final user = supabaseService.currentUser;
    if (user == null) {
      return const CustomerSummary(
        totalCustomers: 0,
        vipCustomers: 0,
        newCustomersThisMonth: 0,
        avgVisitsPerCustomer: 0,
        avgMonthlySpend: 0,
      );
    }

    // Get salon ID
    final salonResponse = await supabaseService.client
        .from('salons')
        .select('id')
        .eq('owner_id', user.id)
        .single();

    final salonId = salonResponse['id'];

    // Get all customers
    final allCustomers = await supabaseService.client
        .from('customers')
        .select()
        .eq('salon_id', salonId);

    final total = allCustomers.length;
    int vipCount = 0;
    int newThisMonth = 0;
    double totalVisits = 0;
    double totalSpent = 0;

    final now = DateTime.now();
    final monthAgo = DateTime(now.year, now.month - 1, now.day);

    for (var customer in allCustomers) {
      if (customer['is_vip'] == true) vipCount++;
      
      final createdAt = DateTime.parse(customer['created_at'] ?? '');
      if (createdAt.isAfter(monthAgo)) newThisMonth++;

      totalVisits += customer['total_visits'] ?? 0;
      totalSpent += (customer['total_spent'] ?? 0.0) as double;
    }

    return CustomerSummary(
      totalCustomers: total,
      vipCustomers: vipCount,
      newCustomersThisMonth: newThisMonth,
      avgVisitsPerCustomer: total > 0 ? totalVisits / total : 0,
      avgMonthlySpend: total > 0 ? totalSpent / total : 0,
    );
  } catch (e) {
    return const CustomerSummary(
      totalCustomers: 0,
      vipCustomers: 0,
      newCustomersThisMonth: 0,
      avgVisitsPerCustomer: 0,
      avgMonthlySpend: 0,
    );
  }
});

// Customer transactions (visit history)
final customerTransactionsProvider = FutureProvider.family<List<CustomerTransaction>, String>((ref, customerId) async {
  final supabaseService = ref.watch(customerSupabaseServiceProvider);

  try {
    final response = await supabaseService.client
        .from('customer_transactions')
        .select()
        .eq('customer_id', customerId)
        .order('date', ascending: false)
        .limit(50);

    return (response as List)
        .map((e) => CustomerTransaction.fromJson(e))
        .toList();
  } catch (e) {
    return [];
  }
});

// Customer notifier for CRUD operations
final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<void>>((ref) {
  final supabaseService = ref.watch(customerSupabaseServiceProvider);
  return CustomerNotifier(supabaseService, ref);
});

class CustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;

  CustomerNotifier(this._supabaseService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> createCustomer(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get salon ID
      final salonResponse = await _supabaseService.client
          .from('salons')
          .select('id')
          .eq('owner_id', user.id)
          .single();

      data['salon_id'] = salonResponse['id'];
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('customers')
          .insert([data]);

      state = const AsyncValue.data(null);
      _ref.invalidate(customersProvider);
      _ref.invalidate(customerSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateCustomer(String customerId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('customers')
          .update(data)
          .eq('id', customerId);

      state = const AsyncValue.data(null);
      _ref.invalidate(customersProvider);
      _ref.invalidate(customerDetailProvider(customerId));
      _ref.invalidate(customerSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('customers')
          .delete()
          .eq('id', customerId);

      state = const AsyncValue.data(null);
      _ref.invalidate(customersProvider);
      _ref.invalidate(customerSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> toggleVIP(String customerId, bool isVIP) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client
          .from('customers')
          .update({'is_vip': isVIP}).eq('id', customerId);

      state = const AsyncValue.data(null);
      _ref.invalidate(customersProvider);
      _ref.invalidate(customerDetailProvider(customerId));
      _ref.invalidate(customerSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> addTransaction(String customerId, Map<String, dynamic> transaction) async {
    state = const AsyncValue.loading();
    try {
      transaction['customer_id'] = customerId;
      transaction['date'] = DateTime.now().toIso8601String();
      transaction['created_at'] = DateTime.now().toIso8601String();
      transaction['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('customer_transactions')
          .insert([transaction]);

      state = const AsyncValue.data(null);
      _ref.invalidate(customerTransactionsProvider(customerId));
      _ref.invalidate(customerSummaryProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
