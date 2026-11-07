import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/hijaiyah.dart';
import '../../models/writing_target.dart';
import '../../providers/progress_provider.dart';
import 'writing_result_screen.dart';

/// Panduan satu huruf. Semua koordinat 0.0 - 1.0 terhadap kotak menulis.
///
/// [jalur]    : titik-titik yang DILEWATI kerangka huruf (dari awal ke ujung).
///              Kurvanya dihaluskan otomatis (Catmull-Rom).
/// [penanda]  : posisi lingkaran angka 1, 2, 3, ... (harus ada di jalur).
/// [dots]     : titik huruf (oranye). Nomornya melanjutkan penanda.
class _LetterGuide {
  final String huruf;
  final String nama;
  final List<Offset> jalur;
  final List<Offset> penanda;
  final List<Offset> dots;
  const _LetterGuide(
    this.huruf,
    this.nama, {
    required this.jalur,
    required this.penanda,
    this.dots = const [],
  });
}

// Kerangka tiap huruf diukur langsung dari pixel desain (Level 2, 3, 4).
// Koordinat 0.0 - 1.0 terhadap kotak menulis.

// Level 2: ba (paling tinggi dan landai)
const List<Offset> _jalurBa = [
  Offset(0.745, 0.331), // 1 (awal)
  Offset(0.755, 0.431),
  Offset(0.693, 0.466), // 2
  Offset(0.622, 0.493),
  Offset(0.505, 0.501), // 3
  Offset(0.451, 0.508),
  Offset(0.359, 0.503),
  Offset(0.317, 0.491), // 4
  Offset(0.258, 0.450),
  Offset(0.276, 0.346), // 5 (ujung)
];

const List<Offset> _penandaBa = [
  Offset(0.745, 0.331),
  Offset(0.693, 0.466),
  Offset(0.505, 0.501),
  Offset(0.317, 0.491),
  Offset(0.276, 0.346),
];

// Level 3: ta
const List<Offset> _jalurTa = [
  Offset(0.745, 0.434), // 1 (awal)
  Offset(0.754, 0.536),
  Offset(0.705, 0.580), // 2
  Offset(0.600, 0.611),
  Offset(0.516, 0.614), // 3
  Offset(0.476, 0.625),
  Offset(0.381, 0.621),
  Offset(0.335, 0.609), // 4
  Offset(0.263, 0.575),
  Offset(0.258, 0.474), // 5 (ujung)
];

const List<Offset> _penandaTa = [
  Offset(0.745, 0.434),
  Offset(0.705, 0.580),
  Offset(0.516, 0.614),
  Offset(0.335, 0.609),
  Offset(0.258, 0.474),
];

// Level 4: tsa (paling rendah)
const List<Offset> _jalurTsa = [
  Offset(0.746, 0.478), // 1 (awal)
  Offset(0.753, 0.580),
  Offset(0.693, 0.613), // 2
  Offset(0.621, 0.639),
  Offset(0.505, 0.649), // 3
  Offset(0.420, 0.655),
  Offset(0.352, 0.649),
  Offset(0.316, 0.632), // 4
  Offset(0.256, 0.594),
  Offset(0.269, 0.492), // 5 (ujung)
];

const List<Offset> _penandaTsa = [
  Offset(0.746, 0.478),
  Offset(0.693, 0.613),
  Offset(0.505, 0.649),
  Offset(0.316, 0.632),
  Offset(0.269, 0.492),
];

const Map<int, _LetterGuide> _guides = {
  // Level 1: Alif (garis lurus dari atas ke bawah)
  1: _LetterGuide(
    'ا',
    'alif',
    jalur: [Offset(0.50, 0.30), Offset(0.50, 0.52), Offset(0.50, 0.74)],
    penanda: [Offset(0.50, 0.30), Offset(0.50, 0.52), Offset(0.50, 0.74)],
  ),

  // Level 2: Ba. Titik 6 di bawah mangkuk.
  2: _LetterGuide(
    'ب',
    'ba',
    jalur: _jalurBa,
    penanda: _penandaBa,
    dots: [Offset(0.520, 0.649)],
  ),

  // Level 3: Ta. Titik 6 = kanan, titik 7 = kiri.
  3: _LetterGuide(
    'ت',
    'ta',
    jalur: _jalurTa,
    penanda: _penandaTa,
    dots: [Offset(0.538, 0.380), Offset(0.462, 0.394)],
  ),

  // Level 4: Tsa. Titik 6 = atas, titik 7 = kanan bawah, titik 8 = kiri bawah.
  4: _LetterGuide(
    'ث',
    'tsa',
    jalur: _jalurTsa,
    penanda: _penandaTsa,
    dots: [
      Offset(0.485, 0.347),
      Offset(0.538, 0.409),
      Offset(0.466, 0.423),
    ],
  ),
};
/// Jalur kurva huruf dalam piksel. Titik jalur dihubungkan dengan
/// Catmull-Rom yang diubah menjadi segmen Bezier kubik.
Path _guidePath(_LetterGuide g, Size size) {
  final pts = g.jalur
      .map((p) => Offset(p.dx * size.width, p.dy * size.height))
      .toList();
  final path = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (int i = 0; i < pts.length - 1; i++) {
    final p0 = i == 0 ? pts[i] : pts[i - 1];
    final p1 = pts[i];
    final p2 = pts[i + 1];
    final p3 = i + 2 < pts.length ? pts[i + 2] : pts[i + 1];
    final c1 = p1 + (p2 - p0) / 6;
    final c2 = p2 - (p3 - p1) / 6;
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }
  return path;
}

/// Posisi lingkaran angka dalam piksel.
List<Offset> _markerPoints(_LetterGuide g, Size size) => g.penanda
    .map((p) => Offset(p.dx * size.width, p.dy * size.height))
    .toList();

class WritingLevelScreen extends StatefulWidget {
  final int level;
  final int totalLevel;
  final WritingKind? kind;

  const WritingLevelScreen({
    super.key,
    this.level = 1,
    this.totalLevel = 28,
    this.kind,
  });

  @override
  State<WritingLevelScreen> createState() => _WritingLevelScreenState();
}

class _WritingLevelScreenState extends State<WritingLevelScreen>
    with SingleTickerProviderStateMixin {
  // Warna diambil dari pixel desain.
  static const Color _background = Color(0xFFFFF4D1);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _orange = Color(0xFFF2711C);
  static const Color _pink = Color(0xFFF0558B);
  static const Color _warnaPeriksa = Color(0xFF8C75D5);

  /// true  -> "Tulis huruf ta"  (nama latin, seperti di desain)
  /// false -> "Tulis huruf ت"   (huruf Arab)
  static const bool _pakaiNamaLatin = true;

  /// Rasio lebar : tinggi kotak menulis, diukur dari desain (200 x 235).
  static const double _rasioKotak = 200 / 235;

  late final AnimationController _demo;
  final List<List<Offset>> _strokes = [];
  Size _canvasSize = Size.zero;

  _LetterGuide get _guide {
    final g = _guides[widget.level];
    if (g != null) return g;
    // Belum ada kerangka untuk level ini: tampilkan huruf yang benar sebagai
    // bayangan untuk ditebalkan (tanpa angka).
    final i =
        math.max(0, math.min(widget.level - 1, Hijaiyah.letters.length - 1));
    final l = Hijaiyah.letters[i];
    return _LetterGuide(l.arabic, l.name, jalur: const [], penanda: const []);
  }

  @override
  void initState() {
    super.initState();
    _demo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _demo.dispose();
    super.dispose();
  }

  void _hapus() {
    _demo.reset();
    setState(() => _strokes.clear());
  }

  void _contoh() {
    if (_guide.jalur.isEmpty) return; // belum ada kerangka untuk dianimasikan
    setState(() => _strokes.clear());
    _demo.forward(from: 0);
  }

  /// Skor 0 - 100: rata-rata kedekatan coretan ke tiap titik angka dan
  /// titik huruf. Dekat (<= 7% lebar kotak) nilai penuh, jauh (>= 25%) nol.
  int _hitungSkor() {
    final w = _canvasSize.width;
    final h = _canvasSize.height;
    final semua = _strokes.expand((s) => s).toList();
    if (semua.isEmpty) return 0;

    final targets = [
      ..._markerPoints(_guide, _canvasSize),
      ..._guide.dots.map((d) => Offset(d.dx * w, d.dy * h)),
    ];

    // Level tanpa kerangka: penilaian sementara dari panjang coretan.
    if (targets.isEmpty) {
      double panjang = 0;
      for (final s in _strokes) {
        for (int i = 1; i < s.length; i++) {
          panjang += (s[i] - s[i - 1]).distance;
        }
      }
      return panjang >= w * 0.6 ? 75 : 45;
    }

    final penuh = w * 0.07;
    final nol = w * 0.25;

    double total = 0;
    for (final target in targets) {
      double dekat = double.infinity;
      for (final p in semua) {
        final d = (p - target).distance;
        if (d < dekat) dekat = d;
      }
      total += (1 - (dekat - penuh) / (nol - penuh)).clamp(0.0, 1.0).toDouble();
    }
    return (total / targets.length * 100).round();
  }

  Future<void> _periksa() async {
    if (_strokes.isEmpty || _canvasSize == Size.zero) {
      _snack('Tulis hurufnya dulu ya');
      return;
    }

    final skor = _hitungSkor();
    final bintang = skor >= 85 ? 3 : (skor >= 60 ? 2 : (skor >= 40 ? 1 : 0));

    // Lulus (>= 60): simpan bintang dan buka level berikutnya.
    if (skor >= 60) {
      await context.read<ProgressProvider>().completeWriting(
            widget.kind ?? WritingKind.single,
            widget.level,
            bintang,
          );
      if (!mounted) return;
    }

    final aksi = await Navigator.push<WritingResultAction>(
      context,
      MaterialPageRoute(
        builder: (_) => WritingResultScreen(
          target: _guide.huruf,
          score: skor,
        ),
      ),
    );

    if (!mounted) return;

    if (aksi == WritingResultAction.next) {
      _lanjut();
    } else if (aksi == WritingResultAction.example) {
      _contoh();
    } else {
      _hapus(); // coba lagi (atau tombol kembali)
    }
  }

  void _lanjut() {
    if (widget.level < widget.totalLevel) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WritingLevelScreen(
            level: widget.level + 1,
            totalLevel: widget.totalLevel,
            kind: widget.kind,
          ),
        ),
      );
    } else {
      Navigator.pop(context); // level terakhir: kembali ke peta level
    }
  }

  void _snack(String pesan) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    final adaKerangka = _guide.jalur.isNotEmpty;

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
                  Text(
                    'Level ${widget.level} dari ${widget.totalLevel}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Progress
              _progressBar(),
              const SizedBox(height: 16),

              // Perintah
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tulis huruf',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _pakaiNamaLatin ? _guide.nama : _guide.huruf,
                    style: TextStyle(
                      fontSize: _pakaiNamaLatin ? 28 : 34,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: _orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Kotak menulis menempel di bawah judul (rasio dikunci seperti
              // desain), teks petunjuk langsung di bawah kotak.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    const petunjukTinggi = 32.0;
                    final w = math.min(
                      c.maxWidth,
                      (c.maxHeight - petunjukTinggi) * _rasioKotak,
                    );
                    final h = w / _rasioKotak;
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: w, height: h, child: _canvas()),
                          const SizedBox(height: 12),
                          Text(
                            adaKerangka
                                ? 'Mulai dari angka 1, lalu ikuti angka berikutnya'
                                : 'Ikuti bentuk huruf dengan jarimu',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _navy,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Hapus & Contoh
              Row(
                children: [
                  Expanded(
                    child: _smallButton(
                      icon: Icons.refresh_rounded,
                      label: 'Hapus',
                      onTap: _hapus,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _smallButton(
                      icon: Icons.play_arrow_rounded,
                      label: 'Contoh',
                      onTap: _contoh,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Periksa
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _periksa,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _warnaPeriksa,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Periksa',
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

  /// Di desain, jalur putih dan isi pink sama tinggi, dan isinya
  /// = level / total (level 3 dari 28 = 3/28).
  Widget _progressBar() {
    const tinggi = 10.0;
    final value =
        (widget.level / widget.totalLevel).clamp(0.0, 1.0).toDouble();
    return LayoutBuilder(
      builder: (context, c) {
        final isi = math.max(tinggi, c.maxWidth * value);
        return SizedBox(
          height: tinggi,
          child: Stack(
            children: [
              Container(
                width: c.maxWidth,
                height: tinggi,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(tinggi),
                ),
              ),
              Container(
                width: isi,
                height: tinggi,
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(tinggi),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _canvas() {
    return LayoutBuilder(
      builder: (context, c) {
        _canvasSize = Size(c.maxWidth, c.maxHeight);
        return Stack(
          children: [
            // Latar putih
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),

            // Panduan (garis, kurva, titik angka, contoh animasi)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _demo,
                builder: (_, __) => CustomPaint(
                  painter: _GuidePainter(
                    guide: _guide,
                    demoProgress: _demo.value,
                  ),
                ),
              ),
            ),

            // Coretan anak
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                // Ketukan singkat = menaruh titik (untuk titik huruf)
                onTapUp: (d) {
                  _demo.reset();
                  setState(() => _strokes.add([d.localPosition]));
                },
                onPanStart: (d) {
                  _demo.reset();
                  setState(() => _strokes.add([d.localPosition]));
                },
                onPanUpdate: (d) {
                  setState(() => _strokes.last.add(d.localPosition));
                },
                child: CustomPaint(painter: _StrokePainter(_strokes)),
              ),
            ),

            // Garis putus-putus di tepi
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _DashedBorderPainter()),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _smallButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: _navy),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Garis bantu, kerangka huruf, penanda angka, titik huruf, dan animasi contoh.
/// Semua ukuran dikali [s] = lebar kotak / 200 (lebar kotak di desain),
/// jadi proporsinya selalu sama seperti desain di layar berukuran apa pun.
class _GuidePainter extends CustomPainter {
  final _LetterGuide guide;
  final double demoProgress;

  _GuidePainter({required this.guide, required this.demoProgress});

  static const Color _green = Color(0xFF22A06B);
  static const Color _orange = Color(0xFFF2711C);
  static const Color _band = Color(0xFFE4DFF5);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;

    // Garis putus-putus horizontal (25%, 50%, 75% tinggi kotak)
    final linePaint = Paint()
      ..color = _band
      ..strokeWidth = 1.2 * s;
    for (final y in [0.25, 0.50, 0.75]) {
      double x = 10 * s;
      while (x < size.width - 10 * s) {
        canvas.drawLine(
          Offset(x, size.height * y),
          Offset(x + 3 * s, size.height * y),
          linePaint,
        );
        x += 6 * s;
      }
    }

    // Level tanpa kerangka: bayangan huruf, tanpa angka.
    if (guide.jalur.isEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: guide.huruf,
          style: GoogleFonts.amiri(
            fontSize: size.height * 0.6,
            color: _band,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
      return;
    }

    // Kerangka huruf (pita lavender)
    final path = _guidePath(guide, size);
    canvas.drawPath(
      path,
      Paint()
        ..color = _band
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Animasi contoh (kerangka terisi bertahap)
    if (demoProgress > 0) {
      for (final m in path.computeMetrics()) {
        canvas.drawPath(
          m.extractPath(0, m.length * demoProgress),
          Paint()
            ..color = const Color(0xFF6C3FD6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8 * s
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    }

    final pts = _markerPoints(guide, size);

    // Titik huruf (oranye), nomornya melanjutkan angka
    for (int j = 0; j < guide.dots.length; j++) {
      final p = Offset(
        guide.dots[j].dx * size.width,
        guide.dots[j].dy * size.height,
      );
      _marker(canvas, p, 6.8 * s, _orange, '${pts.length + j + 1}');
    }

    // Lingkaran angka (hijau). Angka 1 punya cincin tipis di sekelilingnya.
    for (int i = 0; i < pts.length; i++) {
      if (i == 0) {
        canvas.drawCircle(
          pts[i],
          11 * s,
          Paint()
            ..color = _green.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4 * s,
        );
      }
      _marker(canvas, pts[i], 6.8 * s, _green, '${i + 1}');
    }

    // Tag "Mulai" di atas angka 1
    final awal = pts.first;
    final tagCenter = Offset(awal.dx, awal.dy - 17.7 * s);
    final tag = RRect.fromRectAndRadius(
      Rect.fromCenter(center: tagCenter, width: 24 * s, height: 11 * s),
      Radius.circular(5.5 * s),
    );
    canvas.drawRRect(tag, Paint()..color = _green);
    _teks(canvas, 'Mulai', tagCenter, 5.8 * s, Colors.white, FontWeight.w700);
  }

  void _marker(Canvas canvas, Offset p, double r, Color color, String label) {
    canvas.drawCircle(p, r + 1.6 * r / 6.8, Paint()..color = Colors.white);
    canvas.drawCircle(p, r, Paint()..color = color);
    _teks(canvas, label, p, r * 1.1, Colors.white, FontWeight.w800);
  }

  void _teks(Canvas canvas, String t, Offset center, double size, Color color,
      FontWeight weight) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontSize: size, color: color, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GuidePainter old) =>
      old.demoProgress != demoProgress || old.guide != guide;
}

/// Coretan jari anak (dihaluskan)
class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _StrokePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;

    final line = Paint()
      ..color = const Color(0xFF6C3FD6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final dot = Paint()..color = const Color(0xFF6C3FD6);

    for (final st in strokes) {
      if (st.length == 1) {
        canvas.drawCircle(st.first, 6 * s, dot);
        continue;
      }
      final path = Path()..moveTo(st.first.dx, st.first.dy);
      for (int i = 1; i < st.length - 1; i++) {
        final mid = Offset(
          (st[i].dx + st[i + 1].dx) / 2,
          (st[i].dy + st[i + 1].dy) / 2,
        );
        path.quadraticBezierTo(st[i].dx, st[i].dy, mid.dx, mid.dy);
      }
      path.lineTo(st.last.dx, st.last.dy);
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) => true;
}

/// Garis tepi putus-putus (ungu muda)
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB9A6EE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(24),
      ));

    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 8), paint);
        d += 14;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}