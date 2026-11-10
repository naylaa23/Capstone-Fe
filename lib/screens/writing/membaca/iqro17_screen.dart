import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro17Screen extends StatelessWidget {
  const Iqro17Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul
      ['عَ'],
      // 1-5: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['ظَ', 'اَ', 'عَ', 'رَ', 'بَ', 'عَ', 'ظَ', 'طَ'],
      ['صَ', 'ضَ', 'عَ', 'زَ', 'ضَ', 'عَ', 'دَ', 'حَ'],
      ['عَ', 'ظَ', 'عَ', 'ثَ', 'سَ', 'عَ', 'شَ', 'ضَ'],
      ['عَ', 'ذَ', 'عَ', 'ضَ', 'زَ', 'اَ', 'عَ', 'ضَ'],
      ['عَ', 'ظَ', 'عَ', 'خَ', 'طَ', 'ضَ', 'سَ', 'عَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 17, data: _data);
  }
}