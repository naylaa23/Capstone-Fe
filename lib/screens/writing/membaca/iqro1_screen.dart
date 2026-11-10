import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

const String _a = 'اَ';
const String _b = 'بَ';

class Iqro1Screen extends StatelessWidget {
  const Iqro1Screen({super.key});

  // Sel pertama tiap baris = paling kanan (urutan baca Arab).
  static const _data = IqroHalaman(
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
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 1, data: _data);
  }
}