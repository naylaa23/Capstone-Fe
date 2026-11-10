import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro7Screen extends StatelessWidget {
  const Iqro7Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul
      ['دَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['خَ', 'دَ', 'حَ', 'دَ', 'دَ', 'خَ'],
      ['حَ', 'دَ', 'ثَ', 'جَ', 'حَ', 'دَ'],
      ['خَ', 'تَ', 'دَ', 'حَ', 'جَ', 'دَ'],
      ['ثَ', 'بَ', 'دَ', 'جَ', 'حَ', 'خَ'],
      ['حَ', 'بَ', 'دَ', 'جَ', 'دَ', 'جَ'],
      ['حَ', 'جَ', 'تَ', 'خَ', 'دَ', 'دَ'],
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 7, data: _data);
  }
}