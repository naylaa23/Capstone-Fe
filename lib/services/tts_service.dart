import 'package:flutter_tts/flutter_tts.dart';

/// Pemutar suara contoh huruf memakai Text-to-Speech perangkat (bahasa Arab).
/// Jika kelak ada rekaman suara guru, ganti isi `speak` dengan audio player.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.35);
      await _tts.setPitch(1.1);
    } catch (_) {}
    _ready = true;
  }

  Future<void> speak(String text) async {
    try {
      await _init();
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Abaikan: aplikasi tetap jalan walau suara tidak tersedia.
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
