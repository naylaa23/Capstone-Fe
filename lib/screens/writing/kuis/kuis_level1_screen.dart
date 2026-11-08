import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kuis Level 1 (Suara -> Teks): anak mendengar suara, lalu memilih huruf.
/// Menutup layar dengan Navigator.pop(context, true) saat "Selesai" ditekan.
class KuisLevel1Screen extends StatefulWidget {
  const KuisLevel1Screen({super.key});

  @override
  State<KuisLevel1Screen> createState() => _KuisLevel1ScreenState();
}

class _KuisLevel1ScreenState extends State<KuisLevel1Screen> {
  // Warna diambil dari pixel desain.
  static const Color _background = Color(0xFFFFF4D1);
  static const Color _navy = Color(0xFF231A4A);
  static const Color _ketukOrange = Color(0xFFF2711C);
  static const Color _tagOrange = Color(0xFFFF9E42);
  static const Color _tagPurple = Color(0xFF6C4DF0);
  static const Color _progressOn = Color(0xFF7047E6);
  static const Color _progressOff = Color(0xFFFCD6E6);
  static const Color _musicBlue = Color(0xFF1F75E6);
  static const Color _kuning = Color(0xFFFFD43B);
  static const Color _biru = Color(0xFF6BB8FF);
  static const Color _benar = Color(0xFF4CD787);
  static const Color _salahWarna = Color(0xFFFF8A8A);
  static const Color _bintangWarna = Color(0xFFFFBD1B);

  // Data soal Level 1
  static const int _level = 1;
  static const int _totalLevel = 10;
  static const String _suara = 'با'; // teks Arab yang diucapkan
  static const String _bentuk = 'awal'; // label kecil di kartu pilihan
  static const String _bentukLabel = 'Bentuk awal';
  static const String _caption = 'yang kamu dengar di awal kata';
  static const List<String> _pilihan = ['بـ', 'مـ'];
  static const int _indexBenar = 0;

  final FlutterTts _tts = FlutterTts();

  int _salah = 0; // berapa kali salah
  int? _salahIndex; // pilihan salah yang terakhir diketuk
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
      await _tts.speak(_suara);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Suara belum bisa diputar di perangkat ini')),
      );
    }
  }

  void _pilih(int i) {
    if (_selesai) return;
    if (i == _indexBenar) {
      setState(() {
        _selesai = true;
        _salahIndex = null;
        _bintang = _salah == 0 ? 1 : 0; // bintang jika benar di percobaan pertama
      });
    } else {
      setState(() {
        _salah++;
        _salahIndex = i;
      });
    }
  }

  Color _warnaPilihan(int i) {
    if (_selesai && i == _indexBenar) return _benar;
    if (_salahIndex == i) return _salahWarna;
    return i == 0 ? _kuning : _biru;
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
              _kartuSoal(),
              const SizedBox(height: 14),
              _kartuPilihanRow(),
              const SizedBox(height: 14),
              if (_salahIndex != null && !_selesai)
                _pesan('Belum tepat, coba lagi ya', _salahWarna),
              if (_selesai)
                _pesan(
                  _bintang > 0
                      ? 'Benar! Kamu dapat 1 bintang'
                      : 'Benar! Lain kali coba sekali jalan ya',
                  _benar,
                ),
              const Spacer(),
              if (_selesai)
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

  // Bar progress bersegmen: 10 segmen, yang terisi = level sekarang (1)
  Widget _progress() {
    return Row(
      children: List.generate(_totalLevel, (i) {
        final terisi = i < _level;
        return Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: i == _totalLevel - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: terisi ? _progressOn : _progressOff,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap: kalau layar sempit, tag otomatis turun ke baris bawah
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _tag(_bentukLabel, _tagOrange),
              _tag('Suara → Teks', _tagPurple),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Dengarkan, lalu pilih huruf',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _putarSuara,
                  child: const Text(
                    'Ketuk ♪',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: _ketukOrange,
                    ),
                  ),
                ),
              ),
              Material(
                color: _musicBlue,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _putarSuara,
                  child: const SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.music_note_rounded,
                        size: 28, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Font sama persis dengan "Dengarkan, lalu pilih huruf"
          const Text(
            _caption,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _navy,
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

  Widget _kartuPilihanRow() {
    return Row(
      children: [
        for (int i = 0; i < _pilihan.length; i++) ...[
          if (i > 0) const SizedBox(width: 13),
          Expanded(child: _kartuPilihan(i)),
        ],
      ],
    );
  }

  Widget _kartuPilihan(int i) {
    final terpilihBenar = _selesai && i == _indexBenar;

    return AspectRatio(
      aspectRatio: 1.29, // lebar : tinggi kartu pilihan di desain (89 : 69)
      child: Material(
        color: _warnaPilihan(i),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _pilih(i),
          child: Stack(
            children: [
              // Label kecil "awal" di pojok kiri atas
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    _bentuk,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                ),
              ),

              // Huruf
              Center(
                child: Text(
                  _pilihan[i],
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 56,
                    height: 1.3,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
              ),

              // Tanda benar
              if (terpilihBenar)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.check_circle_rounded,
                      size: 24, color: Colors.white),
                ),
            ],
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