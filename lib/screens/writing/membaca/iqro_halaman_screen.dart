/// Isi satu halaman Iqro.
class IqroHalaman {
  final String instruksi;
  final List<String> legend; // baris contoh di bawah instruksi
  final List<List<String>> baris; // urutan baca: dari kanan ke kiri

  /// true = baris pertama di [baris] adalah judul (tanpa garis tengah).
  final bool adaJudul;

  /// false = tidak ada garis antar huruf dan antar baris.
  final bool tampilkanGaris;

  /// Nomor baris (mulai dari 0, termasuk baris judul) yang tidak punya
  /// garis vertikal. Contoh: {6, 7} = dua baris terakhir tanpa garis.
  final Set<int> barisTanpaPembagi;

  /// Kalau diisi, garis vertikal muncul setiap N huruf.
  /// Contoh: 3 = satu baris 9 huruf dibagi jadi 3 balok berisi 3 huruf.
  /// Kalau kosong (null), garis hanya satu di tengah baris.
  final int? hurufPerBalok;

  const IqroHalaman({
    required this.instruksi,
    required this.legend,
    required this.baris,
    this.adaJudul = false,
    this.tampilkanGaris = true,
    this.barisTanpaPembagi = const {},
    this.hurufPerBalok,
  });
}