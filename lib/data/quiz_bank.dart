import 'dart:math' as math;

import '../core/constants/hijaiyah.dart';
import '../models/quiz_question.dart';

class QuizBank {
  QuizBank._();

  static const int totalLevels = 20;
  static const int questionsPerLevel = 5;
  static const int passMinCorrect = 3;

  /// Aturan bintang: 5/5 = 3, 4/5 = 2, 3/5 = 1, selain itu 0.
  static int starsFor(int correct, int total) {
    if (correct >= total) return 3;
    if (correct >= total - 1) return 2;
    if (correct >= passMinCorrect) return 1;
    return 0;
  }

  static bool passed(int correct) => correct >= passMinCorrect;

  static List<QuizQuestion> questionsFor(int level) {
    if (level == 7) return _level7;
    return _generated(level);
  }

  // Level 7 sesuai test case KU_009: soal 4 (ka) adalah soal yang dijawab salah.
  static const List<QuizQuestion> _level7 = [
    QuizQuestion(
      type: QuizType.chooseLetter,
      prompt: 'Mana huruf yang bunyinya bi',
      options: ['\u062A\u064E', '\u0646\u064E', '\u0628\u0650', '\u062B\u064F'],
      correctIndex: 2,
      correctLabel: 'ba (bi)',
    ),
    QuizQuestion(
      type: QuizType.listenChoose,
      prompt: 'Dengarkan, lalu pilih hurufnya',
      options: ['\u0628\u064E', '\u062A\u064E', '\u0646\u064E', '\u062B\u064E'],
      correctIndex: 1,
      correctLabel: 'ta',
      speakText: '\u062A\u064E',
    ),
    QuizQuestion(
      type: QuizType.match,
      prompt: 'Cocokkan huruf dengan bunyinya',
      correctLabel: 'ba - ta - na - ma',
      pairs: [
        MatchPair('\u0628\u064E', 'ba'),
        MatchPair('\u062A\u064E', 'ta'),
        MatchPair('\u0646\u064E', 'na'),
        MatchPair('\u0645\u064E', 'ma'),
      ],
    ),
    QuizQuestion(
      type: QuizType.chooseLetter,
      prompt: 'Mana huruf yang bunyinya ka',
      options: ['\u0642\u064E', '\u0643\u064E', '\u0641\u064E', '\u0644\u064E'],
      correctIndex: 1,
      correctLabel: 'kaf',
    ),
    QuizQuestion(
      type: QuizType.chooseLetter,
      prompt: 'Mana huruf yang bunyinya ma',
      options: ['\u0646\u064E', '\u0645\u064E', '\u0644\u064E', '\u0628\u064E'],
      correctIndex: 1,
      correctLabel: 'mim',
    ),
  ];

  /// Soal otomatis untuk level lain (acak tetap per level).
  static List<QuizQuestion> _generated(int level) {
    final rnd = math.Random(level * 97);
    final pool = Hijaiyah.letters
        .where((l) => l.base.isNotEmpty)
        .take(math.min(8 + level, 27))
        .toList();
    final vowels = [
      ['i', Harakat.kasrah],
      ['a', Harakat.fathah],
      ['u', Harakat.dhammah],
    ];

    QuizQuestion choose({required bool listen}) {
      final picks = (List<HijaiyahLetter>.from(pool)..shuffle(rnd)).take(4).toList();
      final v = vowels[rnd.nextInt(vowels.length)];
      final correct = rnd.nextInt(4);
      final target = picks[correct];
      final options = picks.map((l) => l.withHarakat(v[1])).toList();
      return QuizQuestion(
        type: listen ? QuizType.listenChoose : QuizType.chooseLetter,
        prompt: listen
            ? 'Dengarkan, lalu pilih hurufnya'
            : 'Mana huruf yang bunyinya ${target.soundWith(v[0])}',
        options: options,
        correctIndex: correct,
        correctLabel: listen ? target.soundWith(v[0]) : target.name,
        speakText: listen ? options[correct] : null,
      );
    }

    QuizQuestion matching() {
      final picks = (List<HijaiyahLetter>.from(pool)..shuffle(rnd)).take(4).toList();
      return QuizQuestion(
        type: QuizType.match,
        prompt: 'Cocokkan huruf dengan bunyinya',
        correctLabel: picks.map((l) => l.soundWith('a')).join(' - '),
        pairs: picks
            .map((l) => MatchPair(l.withHarakat(Harakat.fathah), l.soundWith('a')))
            .toList(),
      );
    }

    return [
      choose(listen: false),
      choose(listen: true),
      matching(),
      choose(listen: false),
      choose(listen: false),
    ];
  }
}
