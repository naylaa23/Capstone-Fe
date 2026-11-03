import '../core/constants/hijaiyah.dart';
import '../models/writing_target.dart';

class WritingData {
  WritingData._();

  static const int singleLevels = 28;
  static const int compoundLevels = 10;

  /// Huruf satuan: level n = huruf ke-n (Level 4 = ث).
  static WritingTarget single(int level) {
    final l = Hijaiyah.letters[level - 1];
    return WritingTarget(
      kind: WritingKind.single,
      level: level,
      totalLevels: singleLevels,
      parts: [l.arabic],
      arabic: l.arabic,
      latin: l.name,
      expectedDots: l.dots,
    );
  }

  // Pasangan huruf gabungan: [huruf1, huruf2, bunyi latin hasil].
  static const List<List<String>> _pairs = [
    ['ب', 'ت', 'bat'],
    ['ت', 'ب', 'tab'],
    ['ن', 'م', 'nam'],
    ['م', 'ب', 'mab'],
    ['س', 'ر', 'sar'],
    ['ك', 'ت', 'kat'],
    ['ل', 'ب', 'lab'],
    ['ج', 'م', 'jam'],
    ['ه', 'د', 'had'],
    ['ف', 'ت', 'fat'],
  ];

  /// Huruf gabungan: Level 1 = ب + ت = بت (bat).
  static WritingTarget compound(int level) {
    final p = _pairs[level - 1];
    final a = Hijaiyah.byArabic(p[0]);
    final b = Hijaiyah.byArabic(p[1]);
    return WritingTarget(
      kind: WritingKind.compound,
      level: level,
      totalLevels: compoundLevels,
      parts: [p[0], p[1]],
      arabic: '${p[0]}${p[1]}',
      latin: p[2],
      expectedDots: a.dots + b.dots,
    );
  }

  static WritingTarget of(WritingKind kind, int level) =>
      kind == WritingKind.single ? single(level) : compound(level);
}
