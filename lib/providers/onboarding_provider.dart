import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

// Temporary onboarding data state
final tempOnboardingProvider = StateProvider<Map<String, String>>((ref) {
  return {
    'first_name': '',
    'last_name': '',
    'phone': '',
    'street': '',
    'house_number': '',
    'postal_code': '',
    'city': '',
  };
});

// Onboarding completion notifier
final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return OnboardingNotifier(supabaseService);
});

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;

  OnboardingNotifier(this._supabaseService) : super(const AsyncValue.data(null));

  Future<void> completeOnboarding(Map<String, String> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Ensure profile exists and update with onboarding data
      final profile = {
        'user_id': user.id,
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'phone': data['phone'],
        'street': data['street'],
        'house_number': data['house_number'],
        'postal_code': data['postal_code'],
        'city': data['city'],
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Try to update existing profile, if not found create new one
      final response = await _supabaseService.client
          .from('profiles')
          .upsert(profile)
          .select();

      if (response.isEmpty) {
        throw Exception('Failed to save onboarding data');
      }

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

// Provider untuk supabase service
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});
