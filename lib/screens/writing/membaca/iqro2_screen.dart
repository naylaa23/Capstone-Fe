import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

const String _a = 'اَ';
const String _b = 'بَ';
const String _t = 'تَ';

class Iqro2Screen extends StatelessWidget {
  const Iqro2Screen({super.key});

  // Sel pertama tiap baris = paling kanan (urutan baca Arab).
  static const _data = IqroHalaman(
    instruksi: 'BACAAN LANGSUNG A - BA·TA Dst. DENGAN SUARA PENDEK-PENDEK',
    legend: ['تَ', 'بَ'],
    baris: [
      [_b, _t, _a, _a, _b, _t],
      [_t, _a, _b, _b, _t, _a],
      [_b, _a, _t, _t, _b, _a],
      [_t, _b, _a, _a, _t, _b],
      [_a, _t, _b, _t, _a, _b],
      [_b, _a, _t, _b, _t, _a],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 2, data: _data);
  }
}