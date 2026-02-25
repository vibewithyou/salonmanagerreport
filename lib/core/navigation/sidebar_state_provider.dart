import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier for sidebar collapsed state with persistence
class SidebarStateNotifier extends StateNotifier<bool> {
  static const String _key = 'sidebar_collapsed';

  SidebarStateNotifier() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collapsed = prefs.getBool(_key) ?? false;
      state = collapsed;
    } catch (e) {
      // If loading fails, default to not collapsed
      state = false;
    }
  }

  Future<void> toggle() async {
    state = !state;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, state);
    } catch (e) {
      // Error saving state, but continue with in-memory state
    }
  }

  Future<void> setCollapsed(bool collapsed) async {
    state = collapsed;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, state);
    } catch (e) {
      // Error saving state, but continue with in-memory state
    }
  }
}

/// Provider for sidebar collapsed state with persistence
final sidebarCollapsedProvider = StateNotifierProvider<SidebarStateNotifier, bool>((ref) {
  return SidebarStateNotifier();
});
