import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'iqro_halaman_screen.dart';
import 'iqro_kartu_screen.dart';
import 'iqro_router_screen.dart';

// Supaya file iqroN_screen.dart cukup mengimpor file ini.
export 'iqro_halaman_screen.dart';

/// Tampilan layar halaman Iqro, dipakai oleh semua halaman.
/// [data] = null berarti isi halaman belum tersedia.
class IqroHalamanView extends StatefulWidget {
  final int jilid;
  final int halaman;
  final int totalHalaman;
  final IqroHalaman? data;

  const IqroHalamanView({
    super.key,
    required this.halaman,
    required this.data,
    this.jilid = 1,
    this.totalHalaman = 31,
  });

  @override
  State<IqroHalamanView> createState() => _IqroHalamanViewState();
}

class _IqroHalamanViewState extends State<IqroHalamanView> {
  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _blue = Color(0xFF2F80ED);
  static const Color _yellow = Color(0xFFFFC83A);
  static const Color _green = Color(0xFF1FA64A);

  final FlutterTts _tts = FlutterTts();
  bool _selesai = false;

  bool get _adaSebelumnya => widget.halaman > 1;
  bool get _adaBerikutnya => widget.halaman < widget.totalHalaman;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _dengar() async {
    final d = widget.data;
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

  // Pindah ke halaman lain lewat router (tiap halaman = satu file)
  void _pindah(int arah) {
    _tts.stop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => iqroHalamanScreen(widget.halaman + arah),
      ),
    );
  }

  void _tandaiSelesai() {
    setState(() => _selesai = !_selesai);

    // simpan ke ProgressProvider
    if (_selesai) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Halaman ${widget.halaman} ditandai selesai')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 14),
              _tombolDengarBacaan(),
              const SizedBox(height: 10),
              Text(
                'Halaman ${widget.halaman} dari ${widget.totalHalaman}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: IqroKartu(data: widget.data)),
              const SizedBox(height: 12),
              _navigasi(),
              const SizedBox(height: 10),
              _tombolSelesai(),
            ],
          ),
        ),
      ),
    );
  }

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
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _purple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tombolDengarBacaan() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: widget.data == null ? null : _dengar,
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
    );
  }

  // Sebelumnya, Dengar, Berikutnya
  Widget _navigasi() {
    return Row(
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
          widget.data == null ? null : _dengar,
        ),
        const SizedBox(width: 10),
        _tombol(
          'Berikutnya',
          _yellow,
          _navy,
          _adaBerikutnya ? () => _pindah(1) : null,
        ),
      ],
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

  Widget _tombolSelesai() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _tandaiSelesai,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selesai ? const Color(0xFF168A3C) : _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _selesai ? 'Sudah selesai ✓' : 'Tandai selesai',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}