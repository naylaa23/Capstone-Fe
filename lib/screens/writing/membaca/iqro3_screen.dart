import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

/// Isi satu halaman bacaan.
/// [judulBaris] = baris besar paling atas.
/// [baris] = tiap baris dibagi 2 bagian (kanan dibaca dulu, lalu kiri).
class _DataHalaman {
  final List<String> judulBaris;
  final List<List<List<String>>> baris;

  const _DataHalaman({required this.judulBaris, required this.baris});
}

/// Halaman membaca Jilid. Menutup layar dengan Navigator.pop(context, true)
/// saat "Tandai selesai" ditekan.
class MembacaScreen extends StatefulWidget {
  final int jilid;
  final int halaman;

  const MembacaScreen({super.key, this.jilid = 1, this.halaman = 3});

  @override
  State<MembacaScreen> createState() => _MembacaScreenState();
}

class _MembacaScreenState extends State<MembacaScreen> {
  static const Color _background = Color(0xFFFFF4D1);
  static const Color _navy = Color(0xFF231A4A);
  static const Color _kartu = Color(0xFFFFFBF0);
  static const Color _musicBlue = Color(0xFF1F75E6);
  static const Color _kuning = Color(0xFFFFD43B);
  static const Color _ungu = Color(0xFF7047E6);
  static const Color _hijau = Color(0xFF4CD787);

  static const int _totalHalaman = 32;

  // Isi tiap halaman. Tambahkan halaman lain di sini (kunci = nomor halaman).
  static const Map<int, _DataHalaman> _data = {
    3: _DataHalaman(
      judulBaris: ['بَ', 'تَ', 'ثَ'],
      baris: [
        [
          ['تَ', 'بَ', 'ثَ'],
          ['ثَ', 'بَ', 'تَ'],
        ],
        [
          ['بَ', 'تَ', 'ثَ'],
          ['تَ', 'ثَ', 'بَ'],
        ],
        [
          ['أَ', 'بَ', 'ثَ'],
          ['ثَ', 'تَ', 'بَ'],
        ],
        [
          ['ثَ', 'بَ', 'تَ'],
          ['بَ', 'أَ', 'تَ'],
        ],
        [
          ['تَ', 'ثَ', 'بَ'],
          ['أَ', 'ثَ', 'بَ'],
        ],
        [
          ['بَ', 'ثَ', 'تَ'],
          ['تَ', 'بَ', 'ثَ'],
        ],
        [
          ['ثَ', 'أَ', 'بَ', 'تَ'],
          ['تَ', 'بَ', 'ثَ', 'أَ'],
        ],
      ],
    ),
  };

  final FlutterTts _tts = FlutterTts();

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  // Membacakan seluruh isi halaman
  Future<void> _dengar() async {
    final d = _data[widget.halaman];
    if (d == null) return;

    final teks = [
      d.judulBaris.join(' '),
      for (final b in d.baris) [...b[0], ...b[1]].join(' '),
    ].join(' . ');

    try {
      await _tts.stop();
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.35);
      await _tts.speak(teks);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Suara belum bisa diputar di perangkat ini')),
      );
    }
  }

  void _pindah(int halamanBaru) {
    if (halamanBaru < 1 || halamanBaru > _totalHalaman) return;
    if (!_data.containsKey(halamanBaru)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Halaman $halamanBaru segera hadir')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MembacaScreen(jilid: widget.jilid, halaman: halamanBaru),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data[widget.halaman];

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              const SizedBox(height: 14),
              _tombolDengarBacaan(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Halaman ${widget.halaman} dari $_totalHalaman',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: data == null ? _kosong() : _tabel(data),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _tombolKecil(
                    'Sebelumnya',
                    _kuning,
                    _navy,
                    widget.halaman > 1
                        ? () => _pindah(widget.halaman - 1)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  _tombolKecil('Dengar', _ungu, Colors.white, _dengar),
                  const SizedBox(width: 10),
                  _tombolKecil(
                    'Berikutnya',
                    _kuning,
                    _navy,
                    widget.halaman < _totalHalaman
                        ? () => _pindah(widget.halaman + 1)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hijau,
                    foregroundColor: _navy,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Tandai selesai',
                    style: TextStyle(
                      fontSize: 14,
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

  // Tombol kembali + judul
  Widget _header() {
    return Row(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.maybePop(context),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.chevron_left, size: 26, color: _navy),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Jilid ${widget.jilid} · Halaman ${widget.halaman}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tombolDengarBacaan() {
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: _dengar,
        icon: const Icon(Icons.music_note_rounded, size: 18),
        label: const Text(
          'Dengar bacaan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _musicBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _tombolKecil(
    String teks,
    Color bg,
    Color fg,
    VoidCallback? onTap,
  ) {
    return Expanded(
      child: SizedBox(
        height: 46,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            disabledBackgroundColor: bg.withOpacity(0.4),
            disabledForegroundColor: fg.withOpacity(0.5),
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            teks,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  // Kartu bertabel: baris judul besar + baris-baris huruf
  Widget _tabel(_DataHalaman d) {
    return Container(
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _navy, width: 2.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: [
            Expanded(child: _barisJudul(d.judulBaris)),
            for (final b in d.baris) Expanded(child: _barisIsi(b)),
          ],
        ),
      ),
    );
  }

  Widget _barisJudul(List<String> huruf) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _navy, width: 2)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [for (final h in huruf) _huruf(h, 36)],
        ),
      ),
    );
  }

  // Satu baris: bagian kanan dibaca dulu, garis tengah, lalu bagian kiri
  Widget _barisIsi(List<List<String>> b) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _navy, width: 1)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            for (final h in b[0]) _huruf(h, 28),
            const VerticalDivider(width: 1.5, thickness: 1.5, color: _navy),
            for (final h in b[1]) _huruf(h, 28),
          ],
        ),
      ),
    );
  }

  Widget _huruf(String teks, double ukuran) {
    return Expanded(
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            teks,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: ukuran,
              height: 1.3,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
        ),
      ),
    );
  }

  // Tampil kalau isi halaman ini belum dibuat
  Widget _kosong() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Isi halaman ini segera hadir',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _navy,
        ),
      ),
    );
  }
}