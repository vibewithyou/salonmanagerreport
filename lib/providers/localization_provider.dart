import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider für die aktuelle Sprache
final currentLocaleProvider = StateProvider<Locale>((ref) {
  return const Locale('de');
});

/// Provider für Sprach-Wechsel
final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, Locale>(
      (ref) => LocalizationNotifier(const Locale('de')),
    );

/// StateNotifier für Sprachverwaltung
class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier(Locale initialLocale) : super(initialLocale);

  /// Verfügbare Sprachen
  static const List<Locale> supportedLocales = [Locale('de'), Locale('en')];

  /// Sprache wechseln und speichern
  Future<void> setLocale(Locale locale) async {
    // Validiere dass die Sprache unterstützt wird
    if (!supportedLocales.contains(locale)) {
      return;
    }

    // Aktualisiere State
    state = locale;
  }

  /// Deutsche Sprache setzen
  Future<void> setGerman() => setLocale(const Locale('de'));

  /// Englische Sprache setzen
  Future<void> setEnglish() => setLocale(const Locale('en'));

  /// Aktuelle Sprache als String
  String get currentLanguageName {
    return state.languageCode == 'de' ? 'Deutsch' : 'English';
  }

  /// Aktuelle Sprache zurückgeben
  String get currentLanguageCode => state.languageCode;

  /// Ist Deutsch die aktuelle Sprache?
  bool get isGerman => state.languageCode == 'de';

  /// Ist Englisch die aktuelle Sprache?
  bool get isEnglish => state.languageCode == 'en';
}

/// Einfacher Provider für das aktuelle Locale
final currentLocaleProProvider = Provider<Locale>((ref) {
  return ref.watch(localizationProvider);
});
