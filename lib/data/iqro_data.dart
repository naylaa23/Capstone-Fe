import 'dart:math' as math;

import '../core/constants/hijaiyah.dart';

class IqroJilid {
  final int number;
  final String subtitle;
  final bool active;
  final int totalPages;
  const IqroJilid(this.number, this.subtitle, this.active, this.totalPages);
}

/// Satu kotak pada halaman baca.
class IqroCell {
  final String arabic; // huruf berharakat
  final String latin; // bunyi latin
  const IqroCell(this.arabic, this.latin);
}

class IqroPage {
  final int jilid;
  final int page;
  final String exampleArabic;
  final String exampleLatin; // untuk bar "Suara: ..."
  final String? rule; // aturan singkat (Jilid 2)
  final String? exampleFormula; // mis. "ب + ت = بت" (Jilid 2)
  final List<IqroCell> cells;

  const IqroPage({
    required this.jilid,
    required this.page,
    required this.exampleArabic,
    required this.exampleLatin,
    required this.cells,
    this.rule,
    this.exampleFormula,
  });
}

class IqroData {
  IqroData._();

  static const List<IqroJilid> jilidList = [
    IqroJilid(1, 'Huruf fathah', true, 30),
    IqroJilid(2, 'Huruf sambung', true, 20),
    IqroJilid(3, 'Segera hadir', false, 0),
    IqroJilid(4, 'Segera hadir', false, 0),
    IqroJilid(5, 'Segera hadir', false, 0),
    IqroJilid(6, 'Segera hadir', false, 0),
  ];

  static IqroJilid jilid(int n) => jilidList[n - 1];

  static IqroPage page(int jilid, int page) =>
      jilid == 1 ? _jilid1(page) : _jilid2(page);

  /// Jilid 1: huruf berfathah. Halaman n berfokus pada huruf ke-n.
  /// Halaman 1 berfokus pada "ba" dan semua huruf (termasuk alif) berfathah.
  static IqroPage _jilid1(int page) {
    final letters = Hijaiyah.letters;
    final focus = letters[page % letters.length];
    final pool = letters.take(math.min(page + 2, letters.length)).toList();

    final cells = List<IqroCell>.generate(18, (i) {
      final l = pool[(i * 7 + page) % pool.length];
      return IqroCell(l.withHarakat(Harakat.fathah), l.soundWith('a'));
    });

    final ex = focus.soundWith('a');
    return IqroPage(
      jilid: 1,
      page: page,
      exampleArabic: focus.withHarakat(Harakat.fathah),
      exampleLatin: ex,
      cells: cells,
    );
  }

  /// Jilid 2: huruf sambung. Halaman 1 memakai contoh ba + ta = bat.
  static IqroPage _jilid2(int page) {
    if (page == 1) {
      return const IqroPage(
        jilid: 2,
        page: 1,
        exampleArabic: '\u0628\u064E\u062A',
        exampleLatin: 'ba - ta - bat',
        rule: 'Dua huruf lepas = satu huruf sambung',
        exampleFormula: '\u0628 + \u062A = \u0628\u062A  (ba + ta = bat)',
        cells: [
          IqroCell('\u0628\u064E\u062A', 'bat'),
          IqroCell('\u0628\u064E\u0648', 'baw'),
          IqroCell('\u0628\u064E\u0631', 'bar'),
          IqroCell('\u062A\u064E\u062F', 'tad'),
          IqroCell('\u062A\u064E\u062A', 'tat'),
          IqroCell('\u0628\u064E\u0630', 'badz'),
        ],
      );
    }
    final letters = Hijaiyah.letters;
    final cells = <IqroCell>[];
    for (var i = 0; i < 6; i++) {
      final a = letters[(page + i) % letters.length];
      final b = letters[(page * 2 + i + 1) % letters.length];
      if (a.base.isEmpty || b.base.isEmpty) {
        continue;
      }
      cells.add(IqroCell(
        '${a.withHarakat(Harakat.fathah)}${b.arabic}',
        '${a.base}a${b.base}',
      ));
    }
    final first = cells.first;
    return IqroPage(
      jilid: 2,
      page: page,
      exampleArabic: first.arabic,
      exampleLatin: first.latin,
      rule: 'Dua huruf lepas = satu huruf sambung',
      exampleFormula: first.arabic,
      cells: cells,
    );
  }
}
