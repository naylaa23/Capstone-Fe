import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Isi satu halaman Iqro.
class _IqroHalaman {
  final String instruksi;
  final List<String> legend; // baris contoh di bawah instruksi
  final List<List<String>> baris; // urutan baca: dari kanan ke kiri

  const _IqroHalaman({
    required this.instruksi,
    required this.legend,
    required this.baris,
  });
}

const String _a = 'اَ';
const String _b = 'بَ';
const String _t = 'تَ';

/// Data Jilid 1. Baru halaman 1 dan 2 yang terisi; tambah halaman lain di sini.
/// Tiap baris berisi 6 sel: 3 sel di sisi kanan, garis tengah, 3 sel di kiri.
/// Sel pertama = paling kanan (urutan baca Arab).
const Map<int, _IqroHalaman> _halamanJilid1 = {
  1: _IqroHalaman(
    instruksi:
        'Bacaan langsung A - Ba dst. Tidak perlu diurai/dieja. '
        'Bacalah dengan suara pendek.',
    legend: ['اَ', '=', 'ا', 'ـَ'],
    baris: [
      [_b, _a, _b, _a, _b, _a],
      [_a, _a, _b, _b, _a, _b],
      [_b, _b, _a, _a, _b, _a],
      [_a, _b, _b, _a, _a, _b],
      [_b, _a, _a, _b, _b, _a],
      [_a, _b, _a, _b, _a, _a],
    ],
  ),
  2: _IqroHalaman(
    instruksi:
        'BACAAN LANGSUNG A - BA·TA Dst. DENGAN SUARA PENDEK-PENDEK',
    legend: ['تَ', 'بَ'],
    baris: [
      [_b, _t, _a, _a, _b, _t],
      [_t, _a, _b, _b, _t, _a],
      [_b, _a, _t, _t, _b, _a],
      [_t, _b, _a, _a, _t, _b],
      [_a, _t, _b, _t, _a, _b],
      [_b, _a, _t, _b, _t, _a],
    ],
  ),
};

class IqroHalamanScreen extends StatefulWidget {
  final int jilid;
  final int halaman;
  final int totalHalaman;

  const IqroHalamanScreen({
    super.key,
    this.jilid = 1,
    this.halaman = 1,
    this.totalHalaman = 32,
  });

  @override
  State<IqroHalamanScreen> createState() => _IqroHalamanScreenState();
}

class _IqroHalamanScreenState extends State<IqroHalamanScreen> {
  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _blue = Color(0xFF2F80ED);
  static const Color _yellow = Color(0xFFFFC83A);
  static const Color _green = Color(0xFF1FA64A);

  final FlutterTts _tts = FlutterTts();
  late int _halaman = widget.halaman;
  final Set<int> _selesai = {};

  /// null = datanya belum diisi untuk halaman ini.
  _IqroHalaman? get _data => _halamanJilid1[_halaman];

  bool get _adaSebelumnya => _halaman > 1;
  bool get _adaBerikutnya => _halaman < widget.totalHalaman;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _dengar() async {
    final d = _data;
    if (d == null) return;

    try {
      await _tts.stop();
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.35);
      await _tts.speak(d.baris.expand((r) => r).join(' '));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Suara belum bisa diputar di perangkat ini'),
        ),
      );
    }
  }

  void _pindah(int arah) {
    _tts.stop();
    setState(() => _halaman += arah);
  }

  void _tandaiSelesai() {
    final baru = _selesai.add(_halaman);
    if (!baru) _selesai.remove(_halaman);
    setState(() {});

    // TODO: simpan ke ProgressProvider
    if (baru) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Halaman $_halaman ditandai selesai')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selesai = _selesai.contains(_halaman);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              // Header
              Row(
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
                        child:
                            Icon(Icons.chevron_left, size: 26, color: _navy),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Jilid ${widget.jilid} · Halaman $_halaman',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _purple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Dengar bacaan
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _data == null ? null : _dengar,
                  icon: const Icon(Icons.music_note_rounded, size: 18),
                  label: const Text(
                    'Dengar bacaan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _blue.withOpacity(0.45),
                    disabledForegroundColor: Colors.white70,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Halaman $_halaman dari ${widget.totalHalaman}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),

              // Kartu halaman Iqro
              Expanded(child: _kartuHalaman()),
              const SizedBox(height: 12),

              // Sebelumnya, Dengar, Berikutnya
              Row(
                children: [
                  _tombol(
                    'Sebelumnya',
                    _yellow,
                    _navy,
                    _adaSebelumnya ? () => _pindah(-1) : null,
                  ),
                  const SizedBox(width: 10),
                  _tombol(
                    'Dengar',
                    _purple,
                    Colors.white,
                    _data == null ? null : _dengar,
                  ),
                  const SizedBox(width: 10),
                  _tombol(
                    'Berikutnya',
                    _yellow,
                    _navy,
                    _adaBerikutnya ? () => _pindah(1) : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tandai selesai
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _tandaiSelesai,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selesai ? const Color(0xFF168A3C) : _green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    selesai ? 'Sudah selesai ✓' : 'Tandai selesai',
                    style: const TextStyle(
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

  Widget _tombol(String teks, Color bg, Color fg, VoidCallback? onTap) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            disabledBackgroundColor: bg.withOpacity(0.45),
            disabledForegroundColor: fg.withOpacity(0.6),
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            teks,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  // Kartu berbingkai ungu: instruksi, contoh, dan kotak bacaan
  Widget _kartuHalaman() {
    final d = _data;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: d == null
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Isi halaman ini belum tersedia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Text(
                      d.instruksi,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1.5, color: _purple),

                  // Baris contoh
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final t in d.legend)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              t,
                              style: const TextStyle(
                                fontSize: 34,
                                height: 1.3,
                                color: _navy,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1.5, color: _purple),

                  // Kotak bacaan
                  Expanded(
                    child: Column(
                      children: [
                        for (int r = 0; r < d.baris.length; r++)
                          Expanded(
                            child: _baris(
                              d.baris[r],
                              garisBawah: r < d.baris.length - 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Satu baris bacaan. RTL: sel pertama ada di paling kanan.
  Widget _baris(List<String> sel, {required bool garisBawah}) {
    final setengah = sel.length ~/ 2;

    return Container(
      decoration: BoxDecoration(
        border: garisBawah
            ? Border(
                bottom: BorderSide(
                  color: _purple.withOpacity(0.55),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < sel.length; i++) ...[
              if (i == setengah) Container(width: 2, color: _purple),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      sel[i],
                      style: const TextStyle(
                        fontSize: 32,
                        height: 1.3,
                        color: _navy,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}