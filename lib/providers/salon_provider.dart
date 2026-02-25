import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/salon_model.dart';
import '../services/supabase_service.dart';

// Temporary salon data state for form
final tempSalonProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'name': '',
    'description': '',
    'phone': '',
    'email': '',
    'website': '',
    'instagram': '',
    'facebook': '',
    'street': '',
    'house_number': '',
    'postal_code': '',
    'city': '',
    'service_categories': [],
    'amenities': [],
  };
});

// Salon provider for fetching current user's salon
final userSalonProvider = FutureProvider<Salon?>((ref) async {
  final supabaseService = ref.watch(supabaseServiceProvider);
  try {
    final user = supabaseService.currentUser;
    if (user == null) return null;

    final response = await supabaseService.client
        .from('salons')
        .select()
        .eq('owner_id', user.id)
        .single();

    return Salon.fromJson(response);
  } catch (e) {
    return null; // User hasn't created salon yet
  }
});

// Salon notifier for CRUD operations
final salonNotifierProvider =
    StateNotifierProvider<SalonNotifier, AsyncValue<Salon?>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return SalonNotifier(supabaseService, ref);
});

class SalonNotifier extends StateNotifier<AsyncValue<Salon?>> {
  final SupabaseService _supabaseService;
  final Ref _ref;

  SalonNotifier(this._supabaseService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> createOrUpdateSalon(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final salonData = {
        'owner_id': user.id,
        'name': data['name'],
        'description': data['description'],
        'phone': data['phone'],
        'email': data['email'],
        'website': data['website'],
        'street': data['street'],
        'house_number': data['house_number'],
        'postal_code': data['postal_code'],
        'city': data['city'],
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Try upsert: update if exists, insert if not
      final response = await _supabaseService.client
          .from('salons')
          .upsert(salonData)
          .select()
          .single();

      final salon = Salon.fromJson(response);
      state = AsyncValue.data(salon);

      // Refresh the user salon provider
      _ref.invalidate(userSalonProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<Salon?> fetchSalon() async {
    state = const AsyncValue.loading();
    try {
      final salon = await _ref.read(userSalonProvider.future);
      state = AsyncValue.data(salon);
      return salon;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateSalonServices(
      String salonId, List<Map<String, dynamic>> services) async {
    state = const AsyncValue.loading();
    try {
      // Delete existing services for this salon
      await _supabaseService.client
          .from('salon_services')
          .delete()
          .eq('salon_id', salonId);

      // Insert new services
      if (services.isNotEmpty) {
        final servicesToInsert = services
            .map((service) => {
                  ...service,
                  'salon_id': salonId,
                  'created_at': DateTime.now().toIso8601String(),
                })
            .toList();

        await _supabaseService.client
            .from('salon_services')
            .insert(servicesToInsert);
      }

      // Fetch updated salon
      await fetchSalon();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> uploadLogo(String salonId, String imagePath) async {
    try {
      final fileName = 'salon_$salonId/logo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to storage - convert imagePath to File
      final file = File(imagePath);
      await _supabaseService.client.storage
          .from('salons')
          .upload(fileName, file);

      final publicUrl =
          _supabaseService.client.storage.from('salons').getPublicUrl(fileName);

      // Update salon with logo URL
      await _supabaseService.client
          .from('salons')
          .update({'logo': publicUrl}).eq('id', salonId);

      await fetchSalon();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
