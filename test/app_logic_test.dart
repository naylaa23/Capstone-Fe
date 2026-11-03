import 'package:flutter_test/flutter_test.dart';
import 'package:qalamku/core/utils/validators.dart';
import 'package:qalamku/data/quiz_bank.dart';
import 'package:qalamku/data/writing_data.dart';
import 'package:qalamku/models/quiz_question.dart';
import 'package:qalamku/services/handwriting_scorer.dart';

void main() {
  group('RG_001 validasi registrasi', () {
    test('kata sandi < 8 karakter ditolak', () {
      expect(Validators.password('Qalam1'), isNotNull);
      expect(Validators.password('Qalamku123'), isNull);
    });
    test('ulangi kata sandi harus sama', () {
      expect(Validators.confirmPassword('beda', 'Qalamku123'), isNotNull);
      expect(Validators.confirmPassword('Qalamku123', 'Qalamku123'), isNull);
    });
    test('email valid', () {
      expect(Validators.email('ibu.aisyah@email.com'), isNull);
      expect(Validators.email('bukan-email'), isNotNull);
    });
  });

  group('KU_009 kuis level 7', () {
    final qs = QuizBank.questionsFor(7);
    test('5 soal dengan tipe sesuai test case', () {
      expect(qs.length, 5);
      expect(qs[0].type, QuizType.chooseLetter);
      expect(qs[1].type, QuizType.listenChoose);
      expect(qs[2].type, QuizType.match);
      expect(qs[3].correctLabel, 'kaf');
    });
    test('4 dari 5 benar = 2 bintang dan lulus', () {
      expect(QuizBank.starsFor(4, 5), 2);
      expect(QuizBank.passed(4), isTrue);
      expect(QuizBank.starsFor(5, 5), 3);
    });
  });

  group('MH_007 / MG_008 data menulis', () {
    test('Level 4 huruf satuan = tsa dengan 3 titik', () {
      final t = WritingData.single(4);
      expect(t.latin, 'tsa');
      expect(t.expectedDots, 3);
    });
    test('Level 1 gabungan = ba + ta = bat', () {
      final t = WritingData.compound(1);
      expect(t.latin, 'bat');
      expect(t.arabic, 'بت');
    });
    test('persentase -> bintang', () {
      expect(HandwritingResult.fromPercent(91, compound: true).stars, 3);
      final r = HandwritingResult.fromPercent(72, compound: false);
      expect(r.stars, 2);
      expect(r.title, 'Hampir benar!');
    });
  });
}
