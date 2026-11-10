import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'area_cek_screen.dart';
import 'area_menulis_data.dart';
import 'area_menulispainter.dart';
import 'area_menuliswidget_screen.dart';

class AreaMenulisScreen extends StatefulWidget {
  /// Nama latin huruf yang langsung terpilih saat layar dibuka,
  /// urutannya = Huruf 1, Huruf 2, Huruf 3. Contoh: ['ba', 'ta'].
  final List<String> hurufAwal;

  const AreaMenulisScreen({super.key, this.hurufAwal = const []});

  @override
  State<AreaMenulisScreen> createState() => _AreaMenulisScreenState();
}

class _AreaMenulisScreenState extends State<AreaMenulisScreen> {
  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _purpleDark = Color(0xFF4A2BB8);
  static const Color _purpleSoft = Color(0xFFB9A6EE);
  static const Color _orange = Color(0xFFFF7A00);

  static const int _maks = 3;

  final FlutterTts _tts = FlutterTts();
  final List<HurufMenulis> _dipilih = []; // urutan: Huruf 1, 2, 3
  final List<List<Offset>> _goresan = [];
  bool _modeContoh = false;

  String get _kata => _dipilih.map((h) => h.arab).join();

  /// Cek Tulisan menyala begitu ada huruf yang dipilih.
  bool get _siapCek => _dipilih.isNotEmpty;

  /// Tulisan latin gabungan: ba -> "ba", ba+ta -> "bat", ba+ta+tsa -> "bat-tsa"
  String get _latinGabung {
    if (_dipilih.isEmpty) return '';
    final l = _dipilih.map((h) => h.latin).toList();
    if (l.length == 1) return l[0];
    final tengah = _tanpaVokal(l[1]);
    if (l.length == 2) return l[0] + tengah;
    return '${l[0]}$tengah-${l[2]}';
  }

  String _tanpaVokal(String s) =>
      s.endsWith('a') ? s.substring(0, s.length - 1) : s;

  @override
  void initState() {
    super.initState();
    // Huruf yang sudah terpilih sejak awal (mis. ba + ta)
    for (final latin in widget.hurufAwal) {
      if (_dipilih.length >= _maks) break;
      for (final h in daftarHurufMenulis) {
        if (h.latin == latin && !_dipilih.contains(h)) {
          _dipilih.add(h);
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _ketukChip(HurufMenulis h) {
    final idx = _dipilih.indexOf(h);
    if (idx >= 0) {
      _lepas(idx); // ketuk huruf yang sudah dipilih = melepasnya
      return;
    }
    if (_dipilih.length >= _maks) {
      _tampilkanBatas();
      return;
    }
    setState(() {
      _dipilih.add(h);
      _goresan.clear(); // susunan huruf berubah, tulisan diulang
    });
  }

  void _lepas(int i) {
    setState(() {
      _dipilih.removeAt(i);
      _goresan.clear();
      if (_dipilih.isEmpty) _modeContoh = false;
    });
  }

  Future<void> _tampilkanBatas() async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (_) => const BatasDialog(),
    );
    if (reset == true && mounted) {
      setState(() {
        _dipilih.clear();
        _goresan.clear();
        _modeContoh = false;
      });
    }
  }

  void _ulang() => setState(() => _goresan.clear());

  Future<void> _contoh() async {
    if (_dipilih.isEmpty) {
      _snack('Pilih huruf dulu ya');
      return;
    }
    // Ketuk lagi untuk menutup tampilan contoh
    if (_modeContoh) {
      setState(() => _modeContoh = false);
      return;
    }

    setState(() => _modeContoh = true);
    try {
      await _tts.stop();
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.4);
      await _tts.speak(_kata);
    } catch (_) {
      _snack('Suara belum bisa diputar di perangkat ini');
    }
  }

  Future<void> _cek() async {
    if (_goresan.isEmpty) {
      _snack('Tulis hurufnya dulu ya');
      return;
    }

    // TODO: ganti 92 dengan nilai asli dari penilai tulisan (handwriting_scorer)
    final selesai = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AreaCekScreen(kata: _kata, skor: 92),
      ),
    );

    // Kalau anak menekan "Selesai", tutup Area Menulis juga
    if (selesai == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  void _snack(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(pesan)));
  }

  // ---------------------------------------------------------------
  // Tampilan
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Tinggi kotak menulis mengikuti tinggi layar (dibesarkan: 38%)
    final tinggiKotak =
        (MediaQuery.of(context).size.height * 0.38).clamp(260.0, 420.0);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            // Bagian yang bisa digulir: header, pilihan huruf, kotak menulis
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 14),

                    // Mode pilih huruf, atau ringkasan saat "Contoh" aktif
                    ...(_modeContoh ? _bagianContoh() : _bagianPilih()),

                    SizedBox(height: tinggiKotak, child: _kotakMenulis()),
                  ],
                ),
              ),
            ),

            // Tombol di bawah, selalu terlihat
            _barBawah(),
          ],
        ),
      ),
    );
  }

  Widget _barBawah() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ulang & Contoh
          Row(
            children: [
              Expanded(
                child: _tombolPutih(
                  ikon: Icons.refresh_rounded,
                  teks: 'Ulang',
                  onTap: _ulang,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _tombolPutih(
                  ikon: Icons.play_arrow_rounded,
                  teks: 'Contoh',
                  onTap: _contoh,
                  aktif: _modeContoh,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Cek tulisan
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _siapCek ? _cek : null,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text(
                'Cek Tulisan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFD6CDEE),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
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
              width: 40,
              height: 40,
              child: Icon(Icons.chevron_left, size: 24, color: _navy),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Area Menulis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _purple,
          ),
        ),
      ],
    );
  }

  // Bagian atas saat memilih huruf: label, tiga slot, pratinjau, pilihan huruf
  List<Widget> _bagianPilih() {
    final penuh = _dipilih.length >= _maks;

    return [
      Row(
        children: [
          Expanded(
            child: Text(
              'Pilih huruf (maks. $_maks)',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
          ),
          Text(
            '${_dipilih.length}/$_maks',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: penuh ? _orange : _purple,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),

      // Tiga slot: Huruf 3, Huruf 2, Huruf 1 (kiri ke kanan)
      Row(
        children: [
          for (int i = _maks - 1; i >= 0; i--) ...[
            if (i != _maks - 1) const SizedBox(width: 10),
            Expanded(child: _slot(i)),
          ],
        ],
      ),
      const SizedBox(height: 8),

      // Pratinjau kata gabungan + tulisan latin, di atas pilihan huruf
      SizedBox(
        height: _dipilih.isEmpty ? 40 : 78,
        child: _dipilih.isEmpty
            ? const Center(
                child: Text(
                  'Pilih huruf untuk menyusun kata',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B6B7B),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _kata,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 44,
                        height: 1.3,
                        color: _navy,
                      ),
                    ),
                  ),
                  Text(
                    _latinGabung,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ],
              ),
      ),
      const SizedBox(height: 6),

      // Pilihan huruf. clipBehavior: Clip.none supaya badge centang di sudut
      // chip tidak terpotong oleh batas GridView.
      GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.9,
        shrinkWrap: true,
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [for (final h in daftarHurufMenulis) _chip(h)],
      ),
      const SizedBox(height: 16),
    ];
  }

  // Bagian atas saat "Contoh" aktif: huruf terpilih (kecil) + kata
  List<Widget> _bagianContoh() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = _dipilih.length - 1; i >= 0; i--) ...[
            _chipKecil(_dipilih[i]),
            const SizedBox(width: 8),
          ],
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _kata,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 40, height: 1.3, color: _navy),
              ),
              Text(
                _latinGabung,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 12),
    ];
  }

  // Satu slot huruf. Ketuk slot yang terisi untuk melepas hurufnya.
  Widget _slot(int i) {
    final HurufMenulis? h = i < _dipilih.length ? _dipilih[i] : null;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: GestureDetector(
            onTap: h != null ? () => _lepas(i) : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: h != null
                      ? Container(
                          decoration: BoxDecoration(
                            color: h.warna,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _purple, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              h.arab,
                              style: const TextStyle(
                                fontSize: 38,
                                height: 1.3,
                                color: _navy,
                              ),
                            ),
                          ),
                        )
                      : CustomPaint(
                          painter: DashedBox(color: _purpleSoft, radius: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(Icons.add_rounded,
                                  size: 26, color: _purple),
                            ),
                          ),
                        ),
                ),
                if (h != null)
                  Positioned(top: -7, left: -7, child: _badgeX()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Huruf ${i + 1}',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: _navy,
          ),
        ),
      ],
    );
  }

  Widget _badgeX() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: _purple, width: 1.5),
      ),
      child: const Icon(Icons.close_rounded, size: 10, color: _purple),
    );
  }

  Widget _badgeCek() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: _purple,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Icon(Icons.check_rounded, size: 11, color: Colors.white),
    );
  }

  // Chip pilihan huruf. Sudah dipilih = bingkai ungu + centang.
  // Kalau slot penuh, chip yang belum dipilih memudar.
  Widget _chip(HurufMenulis h) {
    final dipilih = _dipilih.contains(h);
    final redup = _dipilih.length >= _maks && !dipilih;

    return Opacity(
      opacity: redup ? 0.4 : 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Material(
              color: h.warna,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: dipilih
                    ? const BorderSide(color: _purple, width: 2)
                    : BorderSide.none,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _ketukChip(h),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          h.arab,
                          style: const TextStyle(
                            fontSize: 22,
                            height: 1.3,
                            color: _navy,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          h.latin,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: _navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (dipilih) Positioned(top: -6, left: -6, child: _badgeCek()),
        ],
      ),
    );
  }

  Widget _chipKecil(HurufMenulis h) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: h.warna,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            h.arab,
            style: const TextStyle(fontSize: 18, height: 1.3, color: _navy),
          ),
          const SizedBox(width: 4),
          Text(
            h.latin,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
        ],
      ),
    );
  }

  // Kotak menulis: garis bantu, kata panduan, titik contoh, dan coretan anak
  Widget _kotakMenulis() {
    final aktif = _dipilih.isNotEmpty;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: GarisBantu())),

        // Kata panduan atau petunjuk
        Center(
          child: aktif
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      _kata,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        // Besar; kalau kata panjang, FittedBox otomatis
                        // mengecilkannya supaya tetap muat selebar canvas.
                        fontSize: _modeContoh ? 170 : 150,
                        height: 1.3,
                        color: const Color(0xFFE4DEF3),
                      ),
                    ),
                  ),
                )
              : const Text(
                  'Pilih huruf dulu, lalu tulis di sini',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
        ),

        // Titik bernomor (hanya saat "Contoh" aktif)
        if (aktif && _modeContoh)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: TitikPainter(List.of(_dipilih))),
            ),
          ),

        // Coretan. Halaman ini bisa digulir, jadi area menulis "merebut"
        // sentuhan lebih dulu (EagerGestureRecognizer) supaya menggambar
        // tidak ikut menggulir halaman.
        if (aktif)
          Positioned.fill(
            child: RawGestureDetector(
              gestures: {
                EagerGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                        EagerGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                  (EagerGestureRecognizer instance) {},
                ),
              },
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (e) =>
                    setState(() => _goresan.add([e.localPosition])),
                onPointerMove: (e) => setState(() {
                  if (_goresan.isNotEmpty) {
                    _goresan.last.add(e.localPosition);
                  }
                }),
                child: CustomPaint(painter: GoresPainter(_goresan)),
              ),
            ),
          ),

        const Positioned(
          top: 12,
          right: 16,
          child: Text(
            'Tulis dari kanan ke kiri',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: _purple,
            ),
          ),
        ),

        // Keterangan titik
        if (_modeContoh)
          Positioned(
            left: 16,
            bottom: 12,
            child: Row(
              children: const [
                TitikLegend(warna: Color(0xFF1FA64A), teks: 'Garis'),
                SizedBox(width: 14),
                TitikLegend(warna: _orange, teks: 'Titik'),
              ],
            ),
          ),

        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: DashedBox(color: _purpleSoft, radius: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tombolPutih({
    required IconData ikon,
    required String teks,
    required VoidCallback onTap,
    bool aktif = false,
  }) {
    return Material(
      color: aktif ? const Color(0xFFEFEAFB) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: aktif
            ? const BorderSide(color: _purple, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 18, color: aktif ? _purple : _navy),
              const SizedBox(width: 6),
              Text(
                teks,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: aktif ? _purple : _navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}