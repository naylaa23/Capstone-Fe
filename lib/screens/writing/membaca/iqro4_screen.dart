import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro4Screen extends StatelessWidget {
  const Iqro4Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul
      ['جَ'],
      // Baris isi (semuanya 6 huruf): dibaca dari kanan ke kiri
      ['جَ', 'اَ', 'ثَ', 'جَ', 'جَ', 'اَ'],
      ['جَ', 'بَ', 'ثَ', 'جَ', 'تَ', 'اَ'],
      ['جَ', 'اَ', 'ثَ', 'ثَ', 'جَ', 'اَ'],
      ['ثَ', 'اَ', 'جَ', 'بَ', 'اَ', 'جَ'],
      ['جَ', 'جَ', 'ثَ', 'جَ', 'اَ', 'تَ'],
      ['ثَ', 'ثَ', 'جَ', 'جَ', 'اَ', 'جَ'],
      ['جَ', 'ثَ', 'تَ', 'بَ', 'اَ', 'جَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 4, data: _data);
  }
}