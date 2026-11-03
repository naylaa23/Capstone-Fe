enum WritingKind { single, compound }

/// Sasaran tulisan pada satu level menulis (huruf satuan / gabungan).
class WritingTarget {
  final WritingKind kind;
  final int level;
  final int totalLevels;
  final List<String> parts; // huruf-huruf penyusun, mis. [ب, ت]
  final String arabic; // hasil akhir, mis. بت atau ث
  final String latin; // mis. bat atau tsa
  final int expectedDots; // jumlah titik yang diharapkan pada tulisan

  const WritingTarget({
    required this.kind,
    required this.level,
    required this.totalLevels,
    required this.parts,
    required this.arabic,
    required this.latin,
    required this.expectedDots,
  });

  bool get isCompound => kind == WritingKind.compound;
}
