import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro10Screen extends StatelessWidget {
  const Iqro10Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul (urutan baca dari kanan: ra, za)
      ['رَ', 'زَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['رَ', 'اَ', 'رَ', 'ذَ', 'رَ', 'زَ'],
      ['زَ', 'رَ', 'دَ', 'رَ', 'خَ', 'زَ'],
      ['زَ', 'حَ', 'دَ', 'رَ', 'ثَ', 'زَ'],
      ['خَ', 'رَ', 'جَ', 'زَ', 'تَ', 'دَ'],
      ['بَ', 'ذَ', 'رَ', 'زَ', 'حَ', 'ثَ'],
      ['جَ', 'خَ', 'زَ', 'رَ', 'اَ', 'زَ'],
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 10, data: _data);
  }
}