import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro22Screen extends StatelessWidget {
  const Iqro22Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['لَ'],
      // 1-4: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['قَ', 'لَ', 'بَ', 'جَ', 'عَ', 'لَ', 'خَ', 'طَ'],
      ['ذَ', 'كَ', 'لَ', 'غَ', 'لَ', 'ظَ', 'قَ', 'ضَ'],
      ['حَ', 'لَ', 'فَ', 'دَ', 'عَ', 'سَ', 'شَ', 'لَ'],
      ['ضَ', 'رَ', 'عَ', 'زَ', 'تَ', 'كَ', 'لَ', 'لَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['طَ', 'ظَ', 'عَ', 'غَ', 'فَ', 'قَ', 'كَ', 'لَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 22, data: _data);
  }
}