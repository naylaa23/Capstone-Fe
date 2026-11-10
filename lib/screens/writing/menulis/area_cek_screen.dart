import 'package:flutter/material.dart';

/// Pilihan yang dikirim balik ke Area Menulis.
enum HasilCek { selesai, cobaLagi, gantiHuruf }

/// Layar hasil setelah anak menulis. Menutup layar dengan
/// Navigator.pop(context, HasilCek.xxx) sesuai tombol yang ditekan.
class AreaCekScreen extends StatelessWidget {
  /// Kata yang ditulis anak (huruf Arab).
  final String kata;

  /// Nilai kerapian 0..100.
  final int skor;

  /// Nomor huruf (1, 2, 3) yang paling perlu dirapikan. Boleh kosong.
  final int? hurufTerlemah;

  const AreaCekScreen({
    super.key,
    required this.kata,
    required this.skor,
    this.hurufTerlemah,
  });

  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _purpleDark = Color(0xFF4A2BB8);
  static const Color _purpleSoft = Color(0xFFB9A6EE);
  static const Color _hijau = Color(0xFF1FA64A);
  static const Color _orange = Color(0xFFFF7A00);
  static const Color _bintang = Color(0xFFFFB800);
  static const Color _bintangMati = Color(0xFFE4DEF3);
  static const Color _track = Color(0xFFE4DEF3);

  int get _nilai => skor.clamp(0, 100);

  // Tiga tingkat hasil
  bool get _rapi => _nilai >= 80;
  bool get _hampir => _nilai >= 60 && _nilai < 80;

  Color get _warnaHasil => _rapi ? _hijau : _orange;

  // Jumlah bintang dari nilai
  int get _jumlahBintang {
    if (_nilai >= 90) return 3;
    if (_nilai >= 70) return 2;
    if (_nilai >= 50) return 1;
    return 0;
  }

  String get _judul {
    if (_rapi) return 'Tulisanmu rapi!';
    if (_hampir) return 'Hampir benar!';
    return 'Ayo coba lagi!';
  }

  String get _pesan {
    if (_rapi) return 'Hebat! Urutan dan bentuk hurufnya sudah tepat.';
    if (_hampir) {
      final bagian = hurufTerlemah != null
          ? 'Rapikan huruf ke-$hurufTerlemah sedikit lagi.'
          : 'Rapikan sedikit lagi.';
      return 'Bentuknya sudah mirip. $bagian';
    }
    return 'Jangan menyerah, ikuti garis panduan pelan-pelan.';
  }

  // Isi lingkaran: centang, tanda "~", atau ikon ulang
  Widget _isiLingkaran() {
    if (_rapi) {
      return const Icon(Icons.check_rounded, size: 46, color: Colors.white);
    }
    if (_hampir) {
      return const Text(
        '~',
        style: TextStyle(
          fontSize: 48,
          height: 1.1,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      );
    }
    return const Icon(Icons.refresh_rounded, size: 44, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context),
              const SizedBox(height: 20),

              // Kartu hasil
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Kamu menulis',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Kata yang ditulis
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        kata,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 52,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Lingkaran hasil
                    Container(
                      width: 76,
                      height: 76,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _warnaHasil,
                        shape: BoxShape.circle,
                      ),
                      child: _isiLingkaran(),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      _judul,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pesan,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Kerapian + persen
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Kerapian',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                        ),
                        Text(
                          '$_nilai%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _warnaHasil,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _nilai / 100,
                        minHeight: 10,
                        backgroundColor: _track,
                        valueColor: AlwaysStoppedAnimation<Color>(_warnaHasil),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bintang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(
                              i < _jumlahBintang
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 32,
                              color: i < _jumlahBintang
                                  ? _bintang
                                  : _bintangMati,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Tombol: rapi = Selesai; selain itu = Coba Lagi + Ganti Huruf
              if (_rapi)
                _tombolIsi(
                  'Selesai',
                  () => Navigator.pop(context, HasilCek.selesai),
                )
              else ...[
                _tombolIsi(
                  'Coba Lagi',
                  () => Navigator.pop(context, HasilCek.cobaLagi),
                ),
                const SizedBox(height: 12),
                _tombolGaris(
                  'Ganti Huruf',
                  () => Navigator.pop(context, HasilCek.gantiHuruf),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Tombol ungu penuh
  Widget _tombolIsi(String teks, VoidCallback onTap) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purpleDark,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  // Tombol putih dengan garis ungu
  Widget _tombolGaris(String teks, VoidCallback onTap) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _purpleDark,
          side: const BorderSide(color: _purpleSoft, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.maybePop(context),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.chevron_left, size: 24, color: _navy),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Susun & Tulis',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _purple,
          ),
        ),
      ],
    );
  }
}