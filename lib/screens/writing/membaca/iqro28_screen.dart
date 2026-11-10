import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro28Screen extends StatelessWidget {
  const Iqro28Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    // Baris 0 (persamaan huruf) tanpa garis tengah
    barisTanpaPembagi: {0},
    baris: [
      // 0: persamaan huruf, dibaca dari kanan ke kiri
      ['اَ', '=', 'أَ', '=', 'ءَ'],
      // 1: dua persamaan, dengan garis tengah
      ['رَ', '=', 'رَ', 'مَ', '=', 'مَ'],
      // 2-7: baris isi dengan garis tengah (semuanya 6 huruf),
      // dibaca dari kanan ke kiri
      ['بَ', 'رَ', 'قَ', 'رَ', 'بَ', 'اَ'],
      ['اَ', 'مَ', 'مَ', 'جَ', 'ءَ', 'لَ'],
      ['رَ', 'قَ', 'غَ', 'دَ', 'حَ', 'مَ'],
      ['لَ', 'كَ', 'ءَ', 'شَ', 'دَ', 'مَ'],
      ['سَ', 'جَ', 'كَ', 'يَ', 'كَ', 'يَ'],
      ['قَ', 'ثَ', 'لَ', 'مَ', 'سَ', 'نَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 28, data: _data);
  }
}