import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/iqro_data.dart';
import '../data/quiz_bank.dart';
import '../data/writing_data.dart';
import '../models/writing_target.dart';

/// Menyimpan progres belajar per akun: bintang, level menulis, kuis, Iqro.
class ProgressProvider extends ChangeNotifier {
  /// Isi progres awal akun baru agar sesuai data uji (12 bintang, menulis
  /// Level 4, kuis Level 7). Ubah ke `false` untuk akun yang benar-benar baru.
  static const bool seedDemoProgress = true;

  String? _email;
  int totalStars = 0;
  Map<int, int> singleStars = {}; // level -> bintang terbaik
  Map<int, int> compoundStars = {};
  Map<int, int> quizStars = {};
  Map<int, Set<int>> iqroDone = {1: <int>{}, 2: <int>{}};

  // ---------- Muat & simpan ----------
  String _key(String email) => 'qalamku_progress_$email';

  Future<void> load(String email) async {
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(email));
    if (raw == null) {
      _reset();
      if (seedDemoProgress) _seed();
      await _save();
    } else {
      _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    notifyListeners();
  }

  void clear() {
    _email = null;
    _reset();
    notifyListeners();
  }

  void _reset() {
    totalStars = 0;
    singleStars = {};
    compoundStars = {};
    quizStars = {};
    iqroDone = {1: <int>{}, 2: <int>{}};
  }

  void _seed() {
    totalStars = 12;
    singleStars = {1: 3, 2: 3, 3: 3}; // 3 level menulis selesai
    quizStars = {for (var i = 1; i <= 6; i++) i: 2}; // 6 level kuis selesai
  }

  Future<void> _save() async {
    final email = _email;
    if (email == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(email), jsonEncode(_toJson()));
  }

  Map<String, dynamic> _toJson() => {
        'totalStars': totalStars,
        'single': singleStars.map((k, v) => MapEntry('$k', v)),
        'compound': compoundStars.map((k, v) => MapEntry('$k', v)),
        'quiz': quizStars.map((k, v) => MapEntry('$k', v)),
        'iqro': iqroDone.map((k, v) => MapEntry('$k', v.toList())),
      };

  Map<int, int> _intMap(dynamic raw) => raw == null
      ? {}
      : (raw as Map).map((k, v) => MapEntry(int.parse('$k'), v as int));

  void _fromJson(Map<String, dynamic> j) {
    totalStars = (j['totalStars'] as int?) ?? 0;
    singleStars = _intMap(j['single']);
    compoundStars = _intMap(j['compound']);
    quizStars = _intMap(j['quiz']);
    iqroDone = {1: <int>{}, 2: <int>{}};
    final iq = j['iqro'];
    if (iq is Map) {
      iq.forEach((k, v) {
        iqroDone[int.parse('$k')] =
            (v as List).map((e) => e as int).toSet();
      });
    }
  }

  // ---------- Menulis ----------
  Map<int, int> _writingMap(WritingKind kind) =>
      kind == WritingKind.single ? singleStars : compoundStars;

  int writingDone(WritingKind kind) => _writingMap(kind).length;

  int _writingTotal(WritingKind kind) => kind == WritingKind.single
      ? WritingData.singleLevels
      : WritingData.compoundLevels;

  /// Level yang sedang dikerjakan (selesai + 1, maksimal total level).
  int writingCurrentLevel(WritingKind kind) {
    final done = _writingMap(kind).keys.fold<int>(0, (a, b) => a > b ? a : b);
    final next = done + 1;
    final total = _writingTotal(kind);
    return next > total ? total : next;
  }

  bool isWritingUnlocked(WritingKind kind, int level) {
    final done = _writingMap(kind).keys.fold<int>(0, (a, b) => a > b ? a : b);
    return level <= done + 1;
  }

  bool isWritingCompleted(WritingKind kind, int level) =>
      _writingMap(kind).containsKey(level);

  int writingStarsOf(WritingKind kind, int level) =>
      _writingMap(kind)[level] ?? 0;

  /// Catat level menulis selesai. Bintang hanya bertambah jika lebih baik.
  Future<void> completeWriting(WritingKind kind, int level, int stars) async {
    final map = _writingMap(kind);
    final old = map[level] ?? 0;
    if (stars > old) {
      totalStars += stars - old;
      map[level] = stars;
    } else if (!map.containsKey(level)) {
      map[level] = old;
    }
    await _save();
    notifyListeners();
  }

  // ---------- Kuis ----------
  int get quizDone => quizStars.length;

  int get quizCurrentLevel {
    final done = quizStars.keys.fold<int>(0, (a, b) => a > b ? a : b);
    final next = done + 1;
    return next > QuizBank.totalLevels ? QuizBank.totalLevels : next;
  }

  bool isQuizUnlocked(int level) => level <= quizCurrentLevel;
  bool isQuizCompleted(int level) => quizStars.containsKey(level);
  int quizStarsOf(int level) => quizStars[level] ?? 0;

  Future<void> completeQuiz(int level, int stars) async {
    final old = quizStars[level] ?? 0;
    if (stars > old) {
      totalStars += stars - old;
      quizStars[level] = stars;
    } else if (!quizStars.containsKey(level)) {
      quizStars[level] = old;
    }
    await _save();
    notifyListeners();
  }

  // ---------- Iqro ----------
  bool isIqroPageDone(int jilid, int page) =>
      iqroDone[jilid]?.contains(page) ?? false;

  int iqroDoneCount(int jilid) => iqroDone[jilid]?.length ?? 0;

  /// Halaman yang disarankan: setelah halaman terakhir yang selesai.
  int iqroNextPage(int jilid) {
    final done = iqroDone[jilid] ?? <int>{};
    if (done.isEmpty) return 1;
    final last = done.reduce((a, b) => a > b ? a : b);
    final total = IqroData.jilid(jilid).totalPages;
    return last + 1 > total ? total : last + 1;
  }

  Future<void> markIqroDone(int jilid, int page) async {
    iqroDone.putIfAbsent(jilid, () => <int>{}).add(page);
    await _save();
    notifyListeners();
  }

  // ---------- Dashboard ----------
  static const int starsPerLevel = 10;

  /// Level belajar keseluruhan: naik tiap 10 bintang (12 bintang => Level 2).
  int get learnerLevel => 1 + totalStars ~/ starsPerLevel;

  String get learnerLevelName {
    switch (learnerLevel) {
      case 1:
        return 'Pengenalan Huruf';
      case 2:
        return 'Huruf Dasar';
      case 3:
        return 'Huruf Sambung';
      default:
        return 'Mahir Membaca';
    }
  }

  int get starsIntoLevel => totalStars % starsPerLevel;
  double get levelProgress => starsIntoLevel / starsPerLevel;
}
