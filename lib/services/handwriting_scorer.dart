import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Hasil penilaian tulisan anak.
class HandwritingResult {
  final int percent; // kemiripan 0..100
  final int stars; // 0..3
  final bool passed; // true jika level boleh dianggap selesai
  final String title;
  final String message;

  const HandwritingResult({
    required this.percent,
    required this.stars,
    required this.passed,
    required this.title,
    required this.message,
  });

  factory HandwritingResult.fromPercent(int percent, {required bool compound}) {
    if (percent >= 85) {
      return HandwritingResult(
        percent: percent,
        stars: 3,
        passed: true,
        title: 'Hebat sekali!',
        message:
            compound ? 'Gandengannya sudah rapi.' : 'Hurufnya sudah rapi.',
      );
    }
    if (percent >= 60) {
      return HandwritingResult(
        percent: percent,
        stars: 2,
        passed: true,
        title: 'Hampir benar!',
        message: compound
            ? 'Gandengannya hampir benar, tinggal dirapikan ya.'
            : 'Hurufnya benar, tinggal dirapikan ya.',
      );
    }
    return HandwritingResult(
      percent: percent,
      stars: percent >= 40 ? 1 : 0,
      passed: false,
      title: 'Ayo coba lagi!',
      message: 'Pastikan tulisan di dalam kotak dan cahaya cukup.',
    );
  }
}

/// Penilai tulisan berbasis heuristik (prototipe, berjalan offline).
///
/// Foto dipotong sesuai kotak putus-putus di kamera, diubah menjadi hitam-putih
/// (Otsu), lalu dinilai dari: jumlah titik vs titik yang seharusnya, ukuran &
/// posisi tulisan di dalam kotak, dan banyaknya goresan.
/// Untuk akurasi lebih baik, ganti `_analyze` dengan model TFLite.
class HandwritingScorer {
  HandwritingScorer._();

  static Future<HandwritingResult> score({
    required String imagePath,
    required int expectedDots,
    required bool compound,
  }) async {
    final Uint8List bytes = await File(imagePath).readAsBytes();
    final percent = await compute(
      _analyze,
      <String, dynamic>{'bytes': bytes, 'dots': expectedDots},
    );
    return HandwritingResult.fromPercent(percent, compound: compound);
  }
}

class _Comp {
  int area = 0;
  int minX = 1 << 30, minY = 1 << 30, maxX = -1, maxY = -1;
}

/// Berjalan di isolate terpisah lewat `compute`, jadi harus top-level.
int _analyze(Map<String, dynamic> args) {
  final Uint8List bytes = args['bytes'] as Uint8List;
  final int expectedDots = args['dots'] as int;
  const int n = 100;

  var image = img.decodeImage(bytes);
  if (image == null) return 0;
  image = img.bakeOrientation(image);

  // Potong area kotak (72% lebar, di tengah) sesuai overlay kamera.
  final side = math.min((image.width * 0.72).round(), image.height);
  final x0 = ((image.width - side) / 2).round();
  final y0 = ((image.height - side) / 2).round();
  var crop = img.copyCrop(image, x: x0, y: y0, width: side, height: side);
  crop = img.copyResize(crop, width: n, height: n);

  // Kecerahan tiap piksel.
  final lum = List<double>.filled(n * n, 0);
  final hist = List<int>.filled(256, 0);
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final p = crop.getPixel(x, y);
      final v = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
      lum[y * n + x] = v;
      var idx = v.round();
      if (idx < 0) idx = 0;
      if (idx > 255) idx = 255;
      hist[idx]++;
    }
  }

  // Ambang Otsu.
  const total = n * n;
  double sumAll = 0;
  for (var i = 0; i < 256; i++) {
    sumAll += i * hist[i];
  }
  double sumB = 0, maxVar = 0, bestMb = 0, bestMf = 0;
  int wB = 0, thr = 127;
  for (var t = 0; t < 256; t++) {
    wB += hist[t];
    if (wB == 0) continue;
    final wF = total - wB;
    if (wF == 0) break;
    sumB += t * hist[t];
    final mB = sumB / wB;
    final mF = (sumAll - sumB) / wF;
    final between = wB.toDouble() * wF * (mB - mF) * (mB - mF);
    if (between > maxVar) {
      maxVar = between;
      thr = t;
      bestMb = mB;
      bestMf = mF;
    }
  }
  // Kontras terlalu kecil = kertas kosong / tidak ada tulisan.
  if (bestMf - bestMb < 25) return 0;

  final ink = List<bool>.generate(total, (i) => lum[i] <= thr);
  final inkCount = ink.where((v) => v).length;
  final coverage = inkCount / total;
  if (coverage < 0.004) return 0;

  // Komponen terhubung (BFS iteratif, 4 tetangga).
  final label = List<int>.filled(total, -1);
  final comps = <_Comp>[];
  for (var start = 0; start < total; start++) {
    if (!ink[start] || label[start] != -1) continue;
    final comp = _Comp();
    final id = comps.length;
    final stack = <int>[start];
    label[start] = id;
    while (stack.isNotEmpty) {
      final cur = stack.removeLast();
      final cx = cur % n;
      final cy = cur ~/ n;
      comp.area++;
      if (cx < comp.minX) comp.minX = cx;
      if (cx > comp.maxX) comp.maxX = cx;
      if (cy < comp.minY) comp.minY = cy;
      if (cy > comp.maxY) comp.maxY = cy;
      void visit(int nx, int ny) {
        if (nx < 0 || ny < 0 || nx >= n || ny >= n) return;
        final ni = ny * n + nx;
        if (ink[ni] && label[ni] == -1) {
          label[ni] = id;
          stack.add(ni);
        }
      }

      visit(cx + 1, cy);
      visit(cx - 1, cy);
      visit(cx, cy + 1);
      visit(cx, cy - 1);
    }
    comps.add(comp);
  }

  final real = comps.where((c) => c.area >= 6).toList();
  if (real.isEmpty) return 0;
  final largest = real.map((c) => c.area).reduce(math.max);
  final dotCount =
      real.where((c) => c.area != largest && c.area <= largest * 0.12).length;

  // 1) Skor titik.
  double dotScore;
  if (expectedDots == 0) {
    dotScore = dotCount == 0 ? 1.0 : math.max(0.0, 1.0 - dotCount * 0.5);
  } else {
    dotScore =
        math.max(0.0, 1.0 - (expectedDots - dotCount).abs() / expectedDots);
  }

  // 2) Skor ukuran & posisi (kotak pembatas seluruh tulisan).
  final minX = real.map((c) => c.minX).reduce(math.min);
  final maxX = real.map((c) => c.maxX).reduce(math.max);
  final minY = real.map((c) => c.minY).reduce(math.min);
  final maxY = real.map((c) => c.maxY).reduce(math.max);
  final fill = math.max((maxX - minX + 1) / n, (maxY - minY + 1) / n);
  double fillScore;
  if (fill < 0.35) {
    fillScore = fill / 0.35;
  } else if (fill > 0.95) {
    fillScore = math.max(0.0, 1.0 - (fill - 0.95) * 5);
  } else {
    fillScore = 1.0;
  }
  final cxBox = (minX + maxX) / 2 / n;
  final cyBox = (minY + maxY) / 2 / n;
  final off = math.sqrt(math.pow(cxBox - 0.5, 2) + math.pow(cyBox - 0.5, 2));
  final centerScore = math.max(0.0, 1.0 - off * 2.5);
  final sizeScore = 0.6 * fillScore + 0.4 * centerScore;

  // 3) Skor ketebalan goresan (terlalu sedikit / terlalu penuh = kurang rapi).
  double inkScore;
  if (coverage < 0.02) {
    inkScore = coverage / 0.02;
  } else if (coverage > 0.30) {
    inkScore = math.max(0.0, 1.0 - (coverage - 0.30) / 0.30);
  } else {
    inkScore = 1.0;
  }

  final totalScore = 0.40 * dotScore + 0.30 * sizeScore + 0.30 * inkScore;
  return math.max(0, math.min(100, (totalScore * 100).round()));
}
