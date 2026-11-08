import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Data satu soal "Teks -> Suara": anak melihat huruf lalu mengucapkannya.
class KuisSuaraSoal {
  final String bentuk; // mis. "awal"
  final String bentukLabel; // mis. "Bentuk awal"
  final String huruf; // huruf yang tampil, mis. "تـ"
  final String caption; // mis. "di awal kata!"
  final String contoh; // teks Arab yang diucapkan saat "Dengar contoh"

  const KuisSuaraSoal({
    required this.bentuk,
    required this.bentukLabel,
    required this.huruf,
    required this.caption,
    required this.contoh,
  });
}

enum _Fase { diam, mendengar, benar, salah, izin }

/// Tampilan layar soal "Teks -> Suara", dipakai oleh level bertipe mikrofon.
class KuisSuaraView extends StatefulWidget {
  final int level;
  final int totalLevel;
  final KuisSuaraSoal soal;

  /// Jumlah bintang yang sudah dimiliki sebelum level ini (tampil di pojok).
  final int totalBintang;

  const KuisSuaraView({
    super.key,
    required this.level,
    required this.soal,
    this.totalLevel = 10,
    this.totalBintang = 0,
  });

  @override
  State<KuisSuaraView> createState() => _KuisSuaraViewState();
}

class _KuisSuaraViewState extends State<KuisSuaraView>
    with SingleTickerProviderStateMixin {
  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _purpleSoft = Color(0xFFD9CCF7);
  static const Color _pink = Color(0xFFFF6B9A);
  static const Color _pinkCard = Color(0xFFFF8DB8);
  static const Color _orange = Color(0xFFFF9A4D);
  static const Color _orangeMic = Color(0xFFF77F1E);
  static const Color _teal = Color(0xFF2BA39A);
  static const Color _yellow = Color(0xFFFFC83A);
  static const Color _red = Color(0xFFE8394D);
  static const Color _grayMic = Color(0xFF9A9AA8);
  static const Color _greenCard = Color(0xFF4CD787);
  static const Color _greenDark = Color(0xFF1FA64A);

  /// MODE DEMO: pengenalan suara dan izin mikrofon belum tersambung ke
  /// perangkat sungguhan.
  ///  - _demoBenar = false           -> tampil kartu pink "Hampir! Coba lagi"
  ///  - _demoIzinDiberikan = false   -> tampil kartu putih "Izinkan akses mikrofon"
  static const bool _demoBenar = true;
  static const bool _demoIzinDiberikan = true;

  final FlutterTts _tts = FlutterTts();
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  Timer? _timer;

  _Fase _fase = _Fase.diam;
  bool _izinMic = _demoIzinDiberikan;
  int _salah = 0;
  int _bintang = 0; // bintang yang didapat di level ini

  KuisSuaraSoal get _soal => widget.soal;

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _dengarContoh() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.4);
      await _tts.speak(_soal.contoh);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Suara belum bisa diputar di perangkat ini'),
        ),
      );
    }
  }

  void _tapMic() {
    if (_fase == _Fase.benar) return;
    if (_fase == _Fase.mendengar) {
      _berhenti();
    } else {
      _mulaiMendengar();
    }
  }

  void _mulaiMendengar() {
    // cek izin mikrofon sungguhan (mis. paket permission_handler).
    // Untuk demo, izin ditentukan oleh _demoIzinDiberikan.
    if (!_izinMic) {
      setState(() => _fase = _Fase.izin);
      return;
    }

    setState(() => _fase = _Fase.mendengar);
    _pulse.repeat(reverse: true);

    //  sambungkan ke pengenal suara sungguhan (mis. paket speech_to_text),
    // lalu panggil _hasil(true/false) sesuai ucapan anak.
    _timer = Timer(const Duration(seconds: 3), () => _hasil(_demoBenar));
  }

  void _berhenti() {
    _timer?.cancel();
    _pulse.stop();
    _pulse.reset();
    setState(() => _fase = _Fase.diam);
  }

  void _hasil(bool benar) {
    if (!mounted) return;
    _pulse.stop();
    _pulse.reset();
    setState(() {
      if (benar) {
        _fase = _Fase.benar;
        _bintang = _salah == 0 ? 1 : 0; // bintang jika benar di percobaan pertama
      } else {
        _salah++;
        _fase = _Fase.salah;
      }
    });
  }

  void _bukaPengaturan() {
    // buka pengaturan aplikasi (mis. openAppSettings() dari
    // permission_handler), lalu cek izin lagi saat anak kembali ke aplikasi.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buka Pengaturan, lalu izinkan mikrofon untuk aplikasi'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 12),
                _progress(),
                const SizedBox(height: 16),
                _kartuSoal(),
                const SizedBox(height: 14),
                _kartuBawah(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Kartu di bawah soal, berganti sesuai fase.
  Widget _kartuBawah() {
    switch (_fase) {
      case _Fase.benar:
        return _kartuBenar();
      case _Fase.salah:
        return _kartuCobaLagi();
      case _Fase.izin:
        return _kartuIzin();
      case _Fase.diam:
      case _Fase.mendengar:
        return _kartuMic();
    }
  }

  // Tombol tutup, judul level, jumlah bintang
  Widget _header() {
    return Row(
      children: [
        SizedBox(
          width: 64,
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
        Expanded(
          child: Center(
            child: Text(
              'Level ${widget.level} dari ${widget.totalLevel}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 64,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 16, color: Color(0xFFFFB800)),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.totalBintang}',
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

  // Bar progress: level lewat = pink, level ini = ungu, sisanya ungu muda
  Widget _progress() {
    return Row(
      children: List.generate(widget.totalLevel, (i) {
        final nomor = i + 1;
        Color warna;
        if (nomor < widget.level) {
          warna = _pink;
        } else if (nomor == widget.level) {
          warna = _purple;
        } else {
          warna = _purpleSoft;
        }
        return Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: i == widget.totalLevel - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: warna,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  // Kartu putih: label, perintah, huruf besar, keterangan
  Widget _kartuSoal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tag(_soal.bentukLabel, _orange),
              const SizedBox(width: 8),
              _tag('Teks → Suara', _teal),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Ucapkan huruf ini',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _soal.huruf,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 64,
              height: 1.3,
              color: _navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _soal.caption,
            style: const TextStyle(
              fontSize: 11,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  // Kartu kuning: mikrofon, status, tombol dengar contoh
  Widget _kartuMic() {
    final mendengar = _fase == _Fase.mendengar;

    return _kartu(
      warna: _yellow,
      mic: _mic(warna: _red, denyut: mendengar),
      judul: mendengar ? 'Mendengarkan...' : 'Ketuk mikrofon',
      sub: mendengar ? 'Ucapkan sekarang' : 'Lalu ucapkan hurufnya',
      tombol: _tombolKecil('♪ Dengar contoh', _dengarContoh),
    );
  }

  // Kartu pink: ucapan belum tepat, boleh coba lagi
  Widget _kartuCobaLagi() {
    return _kartu(
      warna: _pinkCard,
      mic: _mic(warna: _orangeMic),
      judul: 'Hampir! Coba lagi',
      sub: 'Dengar contoh dulu, lalu ucapkan lagi',
      tombol: _tombolKecil(
        'Ulangi',
        _mulaiMendengar,
        ikon: Icons.refresh_rounded,
      ),
    );
  }

  // Kartu putih: izin mikrofon belum diberikan
  Widget _kartuIzin() {
    return _kartu(
      warna: Colors.white,
      mic: _mic(warna: _grayMic, onTap: () {
        // Cek izin lagi (untuk demo: sesuai _demoIzinDiberikan)
        setState(() => _izinMic = _demoIzinDiberikan);
        if (_izinMic) _mulaiMendengar();
      }),
      judul: 'Izinkan akses mikrofon',
      sub: 'Aplikasi butuh mikrofon untuk mendengarkan bacaanmu',
      tombol: _tombolKecil('Buka pengaturan', _bukaPengaturan),
    );
  }

  // Kartu hijau saat jawaban benar: centang besar, pesan, tombol Lanjut
  Widget _kartuBenar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 28),
      decoration: BoxDecoration(
        color: _greenCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _greenDark,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bunyinya tepat!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: _navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _bintang > 0
                ? 'Hebat! Kamu dapat 1 bintang'
                : 'Hebat! Ucapanmu sudah benar',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 16),
          _tombolKecil('Lanjut', () => Navigator.pop(context, true)),
        ],
      ),
    );
  }

  /// Kerangka kartu bawah: mikrofon, judul, keterangan, tombol.
  Widget _kartu({
    required Color warna,
    required Widget mic,
    required String judul,
    required String sub,
    required Widget tombol,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          mic,
          const SizedBox(height: 10),
          Text(
            judul,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: _navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 14),
          tombol,
        ],
      ),
    );
  }

  Widget _tombolKecil(String teks, VoidCallback onTap, {IconData? ikon}) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ikon != null) ...[
              Icon(ikon, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              teks,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  /// Tombol mikrofon bulat. [denyut] = cincin oranye berdenyut saat mendengar.
  Widget _mic({
    required Color warna,
    bool denyut = false,
    VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        final t = denyut ? _pulse.value : 0.0;
        final ring = 104.0 + 14 * t;
        return GestureDetector(
          onTap: onTap ?? _tapMic,
          child: SizedBox(
            width: 124,
            height: 124,
            child: Center(
              child: Container(
                width: denyut ? ring : 96,
                height: denyut ? ring : 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: denyut ? _orange.withOpacity(0.45) : warna,
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: warna,
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}