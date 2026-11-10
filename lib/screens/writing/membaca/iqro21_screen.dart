import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro21Screen extends StatelessWidget {
  const Iqro21Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['كَ'],
      // 1-4: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['كَ', 'خَ', 'قَ', 'كَ', 'قَ', 'خَ', 'كَ', 'قَ'],
      ['رَ', 'كَ', 'عَ', 'طَ', 'فَ', 'كَ', 'شَ', 'ضَ'],
      ['سَ', 'غَ', 'زَ', 'كَ', 'كَ', 'فَ', 'ذَ', 'جَ'],
      ['طَ', 'كَ', 'زَ', 'كَ', 'فَ', 'غَ', 'صَ', 'دَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['عَ', 'غَ', 'فَ', 'قَ', 'كَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 21, data: _data);
  }
}