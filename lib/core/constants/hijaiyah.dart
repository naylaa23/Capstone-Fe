/// Tanda baris (harakat) yang dipakai di Iqro dan kuis.
class Harakat {
  Harakat._();
  static const fathah = '\u064E';
  static const kasrah = '\u0650';
  static const dhammah = '\u064F';
}

/// Satu huruf hijaiyah beserta data bunyi dan jumlah titiknya.
class HijaiyahLetter {
  final String arabic; // huruf polos, mis. ث
  final String name; // nama huruf, mis. tsa
  final String base; // konsonan untuk bunyi, mis. ts
  final int dots; // jumlah titik pada huruf (untuk penilaian tulisan)

  const HijaiyahLetter(this.arabic, this.name, this.base, this.dots);

  /// Huruf + harakat, mis. بَ
  String withHarakat(String harakat) => '$arabic$harakat';

  /// Bunyi latin dengan vokal a/i/u, mis. soundWith('i') => "bi"
  String soundWith(String vowel) => '$base$vowel';
}

class Hijaiyah {
  Hijaiyah._();

  /// 28 huruf hijaiyah sesuai urutan level menulis (Level 4 = ث / tsa).
  static const List<HijaiyahLetter> letters = [
    HijaiyahLetter('ا', 'alif', '', 0),
    HijaiyahLetter('ب', 'ba', 'b', 1),
    HijaiyahLetter('ت', 'ta', 't', 2),
    HijaiyahLetter('ث', 'tsa', 'ts', 3),
    HijaiyahLetter('ج', 'jim', 'j', 1),
    HijaiyahLetter('ح', 'ha', 'h', 0),
    HijaiyahLetter('خ', 'kho', 'kh', 1),
    HijaiyahLetter('د', 'dal', 'd', 0),
    HijaiyahLetter('ذ', 'dzal', 'dz', 1),
    HijaiyahLetter('ر', 'ro', 'r', 0),
    HijaiyahLetter('ز', 'zai', 'z', 1),
    HijaiyahLetter('س', 'sin', 's', 0),
    HijaiyahLetter('ش', 'syin', 'sy', 3),
    HijaiyahLetter('ص', 'shad', 'sh', 0),
    HijaiyahLetter('ض', 'dhad', 'dh', 1),
    HijaiyahLetter('ط', 'tha', 'th', 0),
    HijaiyahLetter('ظ', 'zha', 'zh', 1),
    HijaiyahLetter('ع', 'ain', '\'', 0),
    HijaiyahLetter('غ', 'ghain', 'gh', 1),
    HijaiyahLetter('ف', 'fa', 'f', 1),
    HijaiyahLetter('ق', 'qaf', 'q', 2),
    HijaiyahLetter('ك', 'kaf', 'k', 0),
    HijaiyahLetter('ل', 'lam', 'l', 0),
    HijaiyahLetter('م', 'mim', 'm', 0),
    HijaiyahLetter('ن', 'nun', 'n', 1),
    HijaiyahLetter('ه', 'ha', 'h', 0),
    HijaiyahLetter('و', 'wawu', 'w', 0),
    HijaiyahLetter('ي', 'ya', 'y', 2),
  ];

  static HijaiyahLetter byArabic(String arabic) =>
      letters.firstWhere((l) => l.arabic == arabic);
}
