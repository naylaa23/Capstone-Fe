import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro19Screen extends StatelessWidget {
  const Iqro19Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul
      ['فَ'],
      // 1-5: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['فَ', 'اَ', 'غَ', 'ضَ', 'فَ', 'صَ'],
      ['فَ', 'تَ', 'حَ', 'غَ', 'جَ', 'عَ'],
      ['طَ', 'عَ', 'حَ', 'صَ', 'دَ', 'فَ'],
      ['سَ', 'عَ', 'ظَ', 'خَ', 'فَ', 'ذَ'],
      ['فَ', 'زَ', 'عَ', 'ثَ', 'طَ', 'غَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ', 'فَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 19, data: _data);
  }
}