/// Isi satu halaman Iqro.
class IqroHalaman {
  final String instruksi;
  final List<String> legend; // baris contoh di bawah instruksi
  final List<List<String>> baris; // urutan baca: dari kanan ke kiri

  /// true = baris pertama di [baris] adalah judul (tanpa garis tengah).
  final bool adaJudul;

  /// false = tidak ada garis antar huruf dan antar baris.
  final bool tampilkanGaris;

  const IqroHalaman({
    required this.instruksi,
    required this.legend,
    required this.baris,
    this.adaJudul = false,
    this.tampilkanGaris = true,
  });
}