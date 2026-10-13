import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NavigationTtsService {
  FlutterTts? _engine;
  Future<void>? _initializing;
  bool _initialized = false;
  bool muted = false;

  Future<void> initialize() {
    if (_initialized) {
      return Future<void>.value();
    }

    return _initializing ??= _initialize();
  }

  Future<void> _initialize() async {
    try {
      _engine ??= FlutterTts();

      await _engine!.setSpeechRate(0.48);
      await _engine!.setVolume(1.0);
      await _engine!.setPitch(1.05);

      if (!kIsWeb) {
        try {
          await _engine!.setSharedInstance(true);
        } catch (e) {
          debugPrint('[NavigationTts] Shared audio unavailable: $e');
        }
      }

      _initialized = true;
      debugPrint('[NavigationTts] Engine initialized.');
    } catch (e) {
      _engine = null;
      _initialized = false;
      _initializing = null;
      debugPrint('[NavigationTts] Initialization failed: $e');
    }
  }

  Future<void> speakNavigationStarted({required String locale}) async {
    final phrase = switch (locale) {
      'hi' => 'नेविगेशन शुरू हो गया है। रास्ते का पालन करें।',
      'mr' => 'नेव्हिगेशन सुरू झाले आहे. दिलेल्या मार्गाने जा.',
      _ => 'Navigation started. Follow the route.',
    };

    await _speak(phrase, locale);
  }

  Future<void> speakInstruction({
    required String maneuverKey,
    required String locale,
    required double distanceMeters,
  }) async {
    final distance = _formatDistance(distanceMeters, locale);
    final phrase = _advancePhrase(
      maneuverKey: maneuverKey,
      locale: locale,
      distanceText: distance,
    );

    await _speak(phrase, locale);
  }

  Future<void> speakNow({
    required String maneuverKey,
    required String locale,
  }) async {
    await _speak(_nowPhrase(maneuverKey, locale), locale);
  }

  Future<void> speakArrived({required String locale}) async {
    final phrase = switch (locale) {
      'hi' => 'आप अपने गंतव्य पर पहुँच गए हैं।',
      'mr' => 'तुम्ही तुमच्या गंतव्यस्थानी पोहोचला आहात.',
      _ => 'You have arrived at your destination.',
    };

    await _speak(phrase, locale);
  }

  Future<void> _speak(String text, String locale) async {
    if (muted) return;

    await initialize();

    if (!_initialized || _engine == null || muted) {
      debugPrint('[NavigationTts] Speech unavailable.');
      return;
    }

    final languageCode = switch (locale) {
      'hi' => 'hi-IN',
      'mr' => 'mr-IN',
      _ => 'en-IN',
    };

    try {
      await _engine!.setLanguage(languageCode);
      await _selectFemaleVoice(languageCode);
      await _engine!.speak(text);
      debugPrint('[NavigationTts] Speaking [$languageCode]: $text');
    } catch (e) {
      debugPrint('[NavigationTts] Speech failed: $e');
    }
  }

  Future<void> _selectFemaleVoice(String languageCode) async {
    if (_engine == null) return;

    try {
      final result = await _engine!.getVoices;

      if (result is! List) return;

      final voices = result.whereType<Map>().map((voice) {
        return voice.map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }).toList();

      final matchingVoices = voices.where((voice) {
        final voiceLocale =
            (voice['locale'] ?? '').toString().toLowerCase();

        return voiceLocale == languageCode.toLowerCase();
      }).toList();

      const femaleHints = [
        'female',
        'woman',
        'samantha',
        'zira',
        'susan',
        'heera',
        'priya',
        'lekha',
      ];

      for (final voice in matchingVoices) {
        final name = (voice['name'] ?? '').toString().toLowerCase();
        final gender = (voice['gender'] ?? '').toString().toLowerCase();

        if (gender == 'female' ||
            femaleHints.any((hint) => name.contains(hint))) {
          final voiceName = voice['name']?.toString();
          final voiceLocale = voice['locale']?.toString();

          if (voiceName != null && voiceLocale != null) {
            await _engine!.setVoice({
              'name': voiceName,
              'locale': voiceLocale,
            });

            debugPrint('[NavigationTts] Female voice selected: $voiceName');
            return;
          }
        }
      }

      debugPrint(
        '[NavigationTts] No identifiable female voice for $languageCode. '
        'Using the phone default voice.',
      );
    } catch (e) {
      debugPrint('[NavigationTts] Voice selection failed: $e');
    }
  }

  String _formatDistance(double meters, String locale) {
    if (meters < 1000) {
      final rounded = (meters / 50).round() * 50;

      return switch (locale) {
        'hi' => '$rounded मीटर',
        'mr' => '$rounded मीटर',
        _ => '$rounded metres',
      };
    }

    final km = (meters / 1000).toStringAsFixed(1);

    return switch (locale) {
      'hi' => '$km किलोमीटर',
      'mr' => '$km किलोमीटर',
      _ => '$km kilometres',
    };
  }

  String _advancePhrase({
    required String maneuverKey,
    required String locale,
    required String distanceText,
  }) {
    if (locale == 'hi') {
      return _advancePhraseHi(maneuverKey, distanceText);
    }

    if (locale == 'mr') {
      return _advancePhraseMr(maneuverKey, distanceText);
    }

    return switch (maneuverKey) {
      'turn_right' => 'In $distanceText, turn right',
      'turn_left' => 'In $distanceText, turn left',
      'slight_right' => 'In $distanceText, bear right',
      'slight_left' => 'In $distanceText, bear left',
      'sharp_right' => 'In $distanceText, turn sharp right',
      'sharp_left' => 'In $distanceText, turn sharp left',
      'u_turn' => 'In $distanceText, make a U-turn',
      'continue_straight' => 'In $distanceText, continue straight',
      _ => 'In $distanceText, continue',
    };
  }

  String _advancePhraseHi(String key, String distance) {
    return switch (key) {
      'turn_right' => '$distance में दाएँ मुड़ें',
      'turn_left' => '$distance में बाएँ मुड़ें',
      'slight_right' => '$distance में थोड़ा दाएँ जाएँ',
      'slight_left' => '$distance में थोड़ा बाएँ जाएँ',
      'sharp_right' => '$distance में तेज़ दाएँ मुड़ें',
      'sharp_left' => '$distance में तेज़ बाएँ मुड़ें',
      'u_turn' => '$distance में यू-टर्न लें',
      'continue_straight' => '$distance तक सीधे जाएँ',
      _ => '$distance तक आगे बढ़ें',
    };
  }

  String _advancePhraseMr(String key, String distance) {
    return switch (key) {
      'turn_right' => '$distance नंतर उजवीकडे वळा',
      'turn_left' => '$distance नंतर डावीकडे वळा',
      'slight_right' => '$distance नंतर थोडे उजवीकडे जा',
      'slight_left' => '$distance नंतर थोडे डावीकडे जा',
      'sharp_right' => '$distance नंतर तीव्र उजवीकडे वळा',
      'sharp_left' => '$distance नंतर तीव्र डावीकडे वळा',
      'u_turn' => '$distance नंतर यू-टर्न घ्या',
      'continue_straight' => '$distance पर्यंत सरळ जा',
      _ => '$distance पर्यंत पुढे जा',
    };
  }

  String _nowPhrase(String key, String locale) {
    if (locale == 'hi') {
      return switch (key) {
        'turn_right' => 'अभी दाएँ मुड़ें',
        'turn_left' => 'अभी बाएँ मुड़ें',
        'slight_right' => 'थोड़ा दाएँ जाएँ',
        'slight_left' => 'थोड़ा बाएँ जाएँ',
        'sharp_right' => 'तेज़ दाएँ मुड़ें',
        'sharp_left' => 'तेज़ बाएँ मुड़ें',
        'u_turn' => 'यू-टर्न लें',
        'continue_straight' => 'सीधे जाएँ',
        _ => 'आगे बढ़ें',
      };
    }

    if (locale == 'mr') {
      return switch (key) {
        'turn_right' => 'आता उजवीकडे वळा',
        'turn_left' => 'आता डावीकडे वळा',
        'slight_right' => 'थोडे उजवीकडे जा',
        'slight_left' => 'थोडे डावीकडे जा',
        'sharp_right' => 'तीव्र उजवीकडे वळा',
        'sharp_left' => 'तीव्र डावीकडे वळा',
        'u_turn' => 'यू-टर्न घ्या',
        'continue_straight' => 'सरळ जा',
        _ => 'पुढे जा',
      };
    }

    return switch (key) {
      'turn_right' => 'Turn right now',
      'turn_left' => 'Turn left now',
      'slight_right' => 'Bear right',
      'slight_left' => 'Bear left',
      'sharp_right' => 'Turn sharp right',
      'sharp_left' => 'Turn sharp left',
      'u_turn' => 'Make a U-turn',
      'continue_straight' => 'Continue straight',
      _ => 'Continue',
    };
  }

  Future<void> stop() async {
    await _engine?.stop();
  }

  Future<void> dispose() async {
    await _engine?.stop();
    _engine = null;
    _initialized = false;
    _initializing = null;
    debugPrint('[NavigationTts] Engine disposed.');
  }
}