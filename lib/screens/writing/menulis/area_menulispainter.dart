import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'area_menulis_data.dart';

/// Garis tepi putus-putus berbentuk kotak membulat
class DashedBox extends CustomPainter {
  final Color color;
  final double radius;

  DashedBox({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 7), paint);
        d += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBox old) =>
      old.color != color || old.radius != radius;
}

/// Dua garis bantu putus-putus di kotak menulis
class GarisBantu extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1;

    for (final y in [0.3, 0.7]) {
      double x = 18;
      while (x < size.width - 18) {
        canvas.drawLine(
          Offset(x, size.height * y),
          Offset(x + 4, size.height * y),
          paint,
        );
        x += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Titik bernomor di tampilan "Contoh":
/// hijau = awal garis tiap huruf, oranye = titik huruf.
/// Nomor hijau 1..n mengikuti urutan huruf, lalu nomor oranye melanjutkan.
/// Posisi titik adalah perkiraan (kolom sama lebar, huruf pertama di kanan).
class TitikPainter extends CustomPainter {
  final List<HurufMenulis> huruf;
  TitikPainter(this.huruf);

  static const Color _hijau = Color(0xFF1FA64A);
  static const Color _oranye = Color(0xFFFF7A00);

  @override
  void paint(Canvas canvas, Size size) {
    final n = huruf.length;
    if (n == 0) return;

    final w = size.width;
    final h = size.height;
    final s = (w / 306).clamp(0.8, 1.4).toDouble();

    final lebarKata = math.min(w * 0.86, n * 0.26 * w);
    final kolom = lebarKata / n;
    final kanan = w / 2 + lebarKata / 2;

    final yGaris = h * 0.53;
    final yAtas = h * 0.41;
    final yBawah = h * 0.66;

    double cx(int i) => kanan - (i + 0.5) * kolom;

    int nomor = 1;

    // Titik hijau: awal garis tiap huruf
    for (int i = 0; i < n; i++) {
      _marker(canvas, Offset(cx(i) + kolom * 0.22, yGaris), _hijau,
          '${nomor++}', s);
    }

    // Titik oranye: titik huruf (kiri ke kanan)
    for (int i = 0; i < n; i++) {
      final x = cx(i);
      final g = huruf[i];

      final posisi = <Offset>[];
      if (g.titikAtas == 1) {
        posisi.add(Offset(x, yAtas));
      } else if (g.titikAtas == 2) {
        posisi.addAll(
            [Offset(x - w * 0.06, yAtas), Offset(x + w * 0.06, yAtas)]);
      } else if (g.titikAtas >= 3) {
        posisi.addAll([
          Offset(x - w * 0.06, yAtas + h * 0.025),
          Offset(x + w * 0.06, yAtas + h * 0.025),
          Offset(x, yAtas - h * 0.04),
        ]);
      }
      if (g.titikBawah == 1) {
        posisi.add(Offset(x, yBawah));
      } else if (g.titikBawah >= 2) {
        posisi.addAll(
            [Offset(x - w * 0.06, yBawah), Offset(x + w * 0.06, yBawah)]);
      }

      for (final p in posisi) {
        _marker(canvas, p, _oranye, '${nomor++}', s);
      }
    }
  }

  void _marker(Canvas canvas, Offset p, Color warna, String label, double s) {
    final r = 9 * s;
    canvas.drawCircle(p, r + 2, Paint()..color = Colors.white);
    canvas.drawCircle(p, r, Paint()..color = warna);

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: r * 1.1,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant TitikPainter old) => true;
}

/// Coretan jari anak (dihaluskan)
class GoresPainter extends CustomPainter {
  final List<List<Offset>> goresan;
  GoresPainter(this.goresan);

  @override
  void paint(Canvas canvas, Size size) {
    final garis = Paint()
      ..color = const Color(0xFF6C3FD6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final titik = Paint()..color = const Color(0xFF6C3FD6);

    for (final g in goresan) {
      if (g.length == 1) {
        canvas.drawCircle(g.first, 4, titik);
        continue;
      }
      final path = Path()..moveTo(g.first.dx, g.first.dy);
      for (int i = 1; i < g.length - 1; i++) {
        final mid = Offset(
          (g[i].dx + g[i + 1].dx) / 2,
          (g[i].dy + g[i + 1].dy) / 2,
        );
        path.quadraticBezierTo(g[i].dx, g[i].dy, mid.dx, mid.dy);
      }
      path.lineTo(g.last.dx, g.last.dy);
      canvas.drawPath(path, garis);
    }
  }

  @override
  bool shouldRepaint(covariant GoresPainter old) => true;
}