import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

final privacyRepositoryProvider = Provider<PrivacyRepository>((ref) {
  return PrivacyRepository(ref.watch(supabaseServiceProvider).client);
});

class PrivacyRepository {
  PrivacyRepository(this._client);

  final SupabaseClient _client;

  Future<void> logConsent({
    required String userId,
    required String type,
    required bool granted,
    String version = 'v1',
  }) async {
    await _client.from('consents').insert({
      'user_id': userId,
      'type': type,
      'granted': granted,
      'version': version,
    });
  }

  Future<void> createGdprRequest({
    required String userId,
    required String type,
  }) async {
    await _client.from('gdpr_requests').insert({
      'user_id': userId,
      'type': type,
      'status': 'pending',
    });
  }

  Future<FunctionResponse> invokeExport() {
    return _client.functions.invoke('gdpr_export');
  }

  Future<FunctionResponse> invokeDelete() {
    return _client.functions.invoke('gdpr_delete');
  }
}
