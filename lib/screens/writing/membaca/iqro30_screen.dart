import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro30Screen extends StatelessWidget {
  const Iqro30Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: 'Penting: bedakan bunyi huruf yang mirip.',
    legend: [],
    // Tidak ada baris judul. Semua baris isi memakai garis tengah
    // (barisTanpaPembagi dibiarkan kosong).
    baris: [
      // Tiap baris = 2 sel: sel pertama di kanan, sel kedua di kiri.
      ['اَ – عَ', 'ثَ – سَ'],
      ['حَ – هَ', 'ثَ – شَ'],
      ['جَ – زَ', 'سَ – شَ'],
      ['يَ – زَ', 'سَ – صَ'],
      ['خَ – غَ', 'تَ – طَ'],
      ['خَ – قَ', 'ذَ – ظَ'],
      ['غَ – قَ', 'ضَ – ظَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 30, data: _data);
  }
}