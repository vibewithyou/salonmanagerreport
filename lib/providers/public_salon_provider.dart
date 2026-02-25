import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/public_salon_model.dart';
import '../services/supabase_service.dart';

final publicSalonSupabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService());

final publicSalonDataProvider = FutureProvider.family<PublicSalonData?, String>((ref, salonId) async {
  final supabaseService = ref.watch(publicSalonSupabaseServiceProvider);
  try {
    final response = await supabaseService.client.from('salons').select().eq('id', salonId).single();
    
    // Fetch services
    final servicesResponse = await supabaseService.client.from('services').select().eq('salon_id', salonId);
    final services = (servicesResponse as List).map((e) => PublicService.fromJson(e)).toList();
    
    return PublicSalonData.fromJson({
      ...response,
      'services': services.map((e) => e.toJson()).toList(),
    });
  } catch (e) {
    return null;
  }
});
