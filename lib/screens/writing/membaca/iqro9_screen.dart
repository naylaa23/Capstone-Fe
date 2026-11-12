import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro9Screen extends StatelessWidget {
  const Iqro9Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    barisTanpaPembagi: {7}, // baris ke-9 (paling bawah) tanpa garis tengah
    baris: [
      // Baris judul
      ['رَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['دَ', 'ذَ', 'رَ', 'خَ', 'ذَ', 'رَ'],
      ['رَ', 'حَ', 'ذَ', 'جَ', 'رَ', 'ذَ'],
      ['رَ', 'حَ', 'دَ', 'ثَ', 'ذَ', 'رَ'],
      ['بَ', 'رَ', 'دَ', 'خَ', 'رَ', 'جَ'],
      ['حَ', 'ذَ', 'رَ', 'بَ', 'رَ', 'تَ'],
      ['حَ', 'رَ', 'ذَ', 'خَ', 'جَ', 'رَ'],
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 9, data: _data);
  }
}