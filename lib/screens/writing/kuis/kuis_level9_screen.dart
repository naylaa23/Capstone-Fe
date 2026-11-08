import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kuis Level 9 (Suara -> Teks): anak mendengar sebuah kata, lalu memilih
/// tulisan yang benar dari 4 pilihan. Menutup layar dengan
/// Navigator.pop(context, true) saat "Selesai" ditekan.
class KuisLevel9Screen extends StatefulWidget {
  const KuisLevel9Screen({super.key});

  @override
  State<KuisLevel9Screen> createState() => _KuisLevel9ScreenState();
}

class _Opsi {
  final String kata;
  final Color warna;
  final String label;

  const _Opsi({
    required this.kata,
    required this.warna,
    required this.label,
  });
}

class _KuisLevel9ScreenState extends State<KuisLevel9Screen> {
  static const Color _background = Color(0xFFFFF4D1);
  static const Color _navy = Color(0xFF231A4A);
  static const Color _tagPink = Color(0xFFFF8DB8); // Kata sambung
  static const Color _tagUngu = Color(0xFF7047E6);
  static const Color _tagOrange = Color(0xFFFF9E42); // warna teks "Ketuk"
  static const Color _progressDone = Color(0xFFF0558B);
  static const Color _progressOn = Color(0xFF7047E6);
  static const Color _progressOff = Color(0xFFFCD6E6);
  static const Color _musicBlue = Color(0xFF1F75E6);
  static const Color _benar = Color(0xFF4CD787);
  static const Color _salahWarna = Color(0xFFFF8A8A);
  static const Color _bintangWarna = Color(0xFFFFBD1B);

  // Data soal Level 9
  static const int _level = 9;
  static const int _totalLevel = 10;
  static const String _bentukLabel = 'Kata sambung';
  static const String _jenis = 'Suara → Teks';
  static const String _perintah = 'Dengarkan, lalu pilih tulisan';
  static const String _suaraSoal = 'كتب'; // kata yang diputar tombol musik
  static const int _indexBenar = 0; // posisi jawaban benar di _opsi

  static const List<_Opsi> _opsi = [
    _Opsi(kata: 'كتب', warna: Color(0xFFFFD43B), label: 'kata'),
    _Opsi(kata: 'كبت', warna: Color(0xFF6BB8FF), label: 'kata'),
    _Opsi(kata: 'تكب', warna: Color(0xFFFF8DB8), label: 'kata'),
    _Opsi(kata: 'بكت', warna: Color(0xFF4CD787), label: 'kata'),
  ];

  final FlutterTts _tts = FlutterTts();

  final Set<int> _salahDipilih = {}; // pilihan yang sudah salah
  bool _adaSalah = false; // jawaban terakhir salah
  bool _selesai = false; // sudah menjawab benar
  int _bintang = 0;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _putarSuara() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.4);
      await _tts.speak(_suaraSoal);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Suara belum bisa diputar di perangkat ini')),
      );
    }
  }

  void _pilih(int index) {
    if (_selesai || _salahDipilih.contains(index)) return;
    setState(() {
      if (index == _indexBenar) {
        _selesai = true;
        _adaSalah = false;
        _bintang = _salahDipilih.isEmpty ? 1 : 0; // bintang jika sekali jalan
      } else {
        _salahDipilih.add(index);
        _adaSalah = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 12),
              _progress(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _kartuSoal(),
                      const SizedBox(height: 12),
                      for (int i = 0; i < _opsi.length; i++) ...[
                        _kartuOpsi(i),
                        if (i < _opsi.length - 1) const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 14),
                      if (_adaSalah && !_selesai)
                        _pesan('Belum tepat, coba lagi ya', _salahWarna),
                      if (_selesai)
                        _pesan(
                          _bintang > 0
                              ? 'Benar! Kamu dapat 1 bintang'
                              : 'Benar! Lain kali coba sekali jalan ya',
                          _benar,
                        ),
                    ],
                  ),
                ),
              ),
              if (_selesai) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _progressOn,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Tombol tutup, judul level, jumlah bintang
  Widget _header() {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close_rounded, size: 22, color: _navy),
              ),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Level $_level dari $_totalLevel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 72,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 16, color: _bintangWarna),
                  const SizedBox(width: 5),
                  Text(
                    '$_bintang',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Bar progress bersegmen: pink = level lewat, ungu = level sekarang,
  // pink muda = level berikutnya.
  Widget _progress() {
    return Row(
      children: List.generate(_totalLevel, (i) {
        final Color warna;
        if (i < _level - 1) {
          warna = _progressDone;
        } else if (i == _level - 1) {
          warna = _progressOn;
        } else {
          warna = _progressOff;
        }
        return Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: i == _totalLevel - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: warna,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _kartuSoal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _tag(_bentukLabel, _tagPink),
                    _tag(_jenis, _tagUngu),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  _perintah,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 8),
                // Petunjuk "Ketuk" + ikon musik
                Text.rich(
                  TextSpan(
                    children: const [
                      TextSpan(text: 'Ketuk '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(Icons.music_note_rounded,
                            size: 30, color: _tagOrange),
                      ),
                    ],
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    height: 1.3,
                    fontWeight: FontWeight.w800,
                    color: _tagOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Tombol bulat biru untuk memutar suara
          Material(
            color: _musicBlue,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _putarSuara,
              child: const SizedBox(
                width: 58,
                height: 58,
                child: Icon(Icons.music_note_rounded,
                    size: 28, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String teks, Color warna) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  // Satu baris pilihan kata (memanjang penuh)
  Widget _kartuOpsi(int index) {
    final o = _opsi[index];
    final salah = _salahDipilih.contains(index);
    final benar = _selesai && index == _indexBenar;

    // Pilihan yang salah dipudarkan; jawaban benar diberi garis navy
    return Opacity(
      opacity: salah ? 0.35 : 1,
      child: Material(
        color: o.warna,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _pilih(index),
          child: Container(
            height: 84,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: benar ? Border.all(color: _navy, width: 3) : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      o.label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    o.kata,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontSize: 56,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                ),
                if (benar)
                  const Positioned(
                    right: 10,
                    top: 10,
                    child: Icon(Icons.check_circle_rounded,
                        size: 22, color: _navy),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pesan(String teks, Color warna) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        teks,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: _navy,
        ),
      ),
    );
  }
}