import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/supabase_service.dart';

class ProfileExtraSettings {
  final String preferredLanguage;
  final bool cookieConsent;
  final bool privacyConsent;
  final bool termsConsent;

  const ProfileExtraSettings({
    required this.preferredLanguage,
    required this.cookieConsent,
    required this.privacyConsent,
    required this.termsConsent,
  });
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Profile?>>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return ProfileNotifier(supabaseService);
});

final profileExtraSettingsProvider = Provider<ProfileExtraSettings>((ref) {
  ref.watch(profileProvider);
  return ref.read(profileProvider.notifier).extraSettings;
});

class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final SupabaseService _supabaseService;
  ProfileExtraSettings _extraSettings = const ProfileExtraSettings(
    preferredLanguage: 'de',
    cookieConsent: false,
    privacyConsent: false,
    termsConsent: false,
  );

  ProfileExtraSettings get extraSettings => _extraSettings;

  ProfileNotifier(this._supabaseService) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final response = await _supabaseService.client
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        // Create profile if it doesn't exist
        final newProfile = {
          'user_id': user.id,
          'email': user.email,
          'first_name': '',
          'last_name': '',
          'phone': '',
          'street': '',
          'house_number': '',
          'postal_code': '',
          'city': '',
          'preferred_language': 'de',
          'cookie_consent': false,
          'privacy_consent': false,
          'terms_consent': false,
        };
        await _supabaseService.client.from('profiles').insert(newProfile);
        _setExtraSettingsFromRow(newProfile);
        state = AsyncValue.data(
          _profileFromRow({...newProfile, 'created_at': DateTime.now().toIso8601String()}),
        );
      } else {
        _setExtraSettingsFromRow(response);
        state = AsyncValue.data(_profileFromRow(response));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void _setExtraSettingsFromRow(Map<String, dynamic> row) {
    _extraSettings = ProfileExtraSettings(
      preferredLanguage: (row['preferred_language'] as String?) ?? 'de',
      cookieConsent: (row['cookie_consent'] as bool?) ?? false,
      privacyConsent: (row['privacy_consent'] as bool?) ?? false,
      termsConsent: (row['terms_consent'] as bool?) ?? false,
    );
  }

  Profile _profileFromRow(Map<String, dynamic> row) {
    return Profile(
      userId: row['user_id'] as String? ?? '',
      firstName: row['first_name'] as String?,
      lastName: row['last_name'] as String?,
      phone: row['phone'] as String?,
      street: row['street'] as String?,
      houseNumber: row['house_number'] as String?,
      postalCode: row['postal_code'] as String?,
      city: row['city'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null,
      updatedAt: row['updated_at'] != null
          ? DateTime.tryParse(row['updated_at'].toString())
          : null,
    );
  }

  Future<void> updateProfile(
    Profile profile, {
    String? preferredLanguage,
    bool? cookieConsent,
    bool? privacyConsent,
    bool? termsConsent,
  }) async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabaseService.client
          .from('profiles')
          .update({
            'first_name': profile.firstName,
            'last_name': profile.lastName,
            'phone': profile.phone,
            'street': profile.street,
            'house_number': profile.houseNumber,
            'postal_code': profile.postalCode,
            'city': profile.city,
            'avatar_url': profile.avatarUrl,
            'preferred_language': preferredLanguage ?? _extraSettings.preferredLanguage,
            'cookie_consent': cookieConsent ?? _extraSettings.cookieConsent,
            'privacy_consent': privacyConsent ?? _extraSettings.privacyConsent,
            'terms_consent': termsConsent ?? _extraSettings.termsConsent,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id);

      _extraSettings = ProfileExtraSettings(
        preferredLanguage: preferredLanguage ?? _extraSettings.preferredLanguage,
        cookieConsent: cookieConsent ?? _extraSettings.cookieConsent,
        privacyConsent: privacyConsent ?? _extraSettings.privacyConsent,
        termsConsent: termsConsent ?? _extraSettings.termsConsent,
      );

      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> uploadAvatar(String filePath) async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // In a real app, you would upload the file to Supabase Storage
      // For now, we just update the avatar_url
      final currentProfile = state.value;
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(avatarUrl: filePath);
        await updateProfile(updatedProfile);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> uploadAvatarBytes({
    required List<int> bytes,
    required String extension,
    required String contentType,
  }) async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final ext = extension.toLowerCase();
      final path = '${user.id}/avatar.$ext';

      await _supabaseService.client.storage.from('avatars').uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: FileOptions(
              upsert: true,
              contentType: contentType,
            ),
          );

      final publicUrl = _supabaseService.client.storage
          .from('avatars')
          .getPublicUrl(path);

      final currentProfile = state.value;
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          avatarUrl: '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}',
        );
        await updateProfile(updatedProfile);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> refresh() => _loadProfile();
}
