import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kLanguageSharedPrefKey = 'selected_language_code';

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  return null;
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (prefs != null) {
      final savedCode = prefs.getString(kLanguageSharedPrefKey);
      if (savedCode != null && isSupported(savedCode)) {
        return Locale(savedCode);
      }
    } else {
      _loadFromDisk();
    }
    return const Locale('en');
  }

  Future<void> _loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(kLanguageSharedPrefKey);
      if (savedCode != null && isSupported(savedCode)) {
        state = Locale(savedCode);
      }
    } catch (e) {
      debugPrint('Error loading saved locale: ');
    }
  }

  bool isSupported(String code) {
    return code == 'en' || code == 'hi' || code == 'mr';
  }

  Future<void> setLocale(String languageCode) async {
    if (!isSupported(languageCode)) {
      return;
    }

    state = Locale(languageCode);

    try {
      final prefs = ref.read(sharedPreferencesProvider) ??
          await SharedPreferences.getInstance();
      await prefs.setString(kLanguageSharedPrefKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: ');
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
