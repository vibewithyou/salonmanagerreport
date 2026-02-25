import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/identity_provider.dart';
import '../../services/auth_service.dart';

/// ChangeNotifier that tells GoRouter when to refresh redirects
/// This is used instead of rebuilding the entire router
class RouterRefreshNotifier extends ChangeNotifier {
  final Ref _ref;
  
  RouterRefreshNotifier(this._ref) {
    // Listen to auth and identity changes
    _ref.listen(authServiceProvider, (_, __) {
      print('[RouterRefresh] Auth changed, notifying router...');
      notifyListeners();
    });
    
    _ref.listen(identityProvider, (_, __) {
      print('[RouterRefresh] Identity changed, notifying router...');
      notifyListeners();
    });
  }
}

/// Provider for RouterRefreshNotifier  
final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>((ref) {
  return RouterRefreshNotifier(ref);
});
