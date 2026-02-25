import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gallery_model.dart';
import '../services/supabase_service.dart';

final gallerySupabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService());

final galleryImagesProvider = FutureProvider<List<GalleryImage>>((ref) async {
  final supabaseService = ref.watch(gallerySupabaseServiceProvider);
  try {
    final user = supabaseService.currentUser;
    if (user == null) return [];
    final salonResponse = await supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
    final salonId = salonResponse['id'];
    final response = await supabaseService.client.from('gallery_images').select().eq('salon_id', salonId).order('created_at', ascending: false);
    return (response as List).map((e) => GalleryImage.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
});

final galleryNotifierProvider = StateNotifierProvider<GalleryNotifier, AsyncValue<void>>((ref) {
  return GalleryNotifier(ref.watch(gallerySupabaseServiceProvider), ref);
});

class GalleryNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseService _supabaseService;
  final Ref _ref;
  GalleryNotifier(this._supabaseService, this._ref) : super(const AsyncValue.data(null));

  Future<void> uploadImage(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final salonResponse = await _supabaseService.client.from('salons').select('id').eq('owner_id', user.id).single();
      data['salon_id'] = salonResponse['id'];
      data['likes'] = 0;
      data['created_at'] = DateTime.now().toIso8601String();
      await _supabaseService.client.from('gallery_images').insert([data]);
      state = const AsyncValue.data(null);
      _ref.invalidate(galleryImagesProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteImage(String imageId) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.client.from('gallery_images').delete().eq('id', imageId);
      state = const AsyncValue.data(null);
      _ref.invalidate(galleryImagesProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
