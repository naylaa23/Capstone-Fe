import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro18Screen extends StatelessWidget {
  const Iqro18Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: ain, ghain)
      ['عَ', 'غَ'],
      // 1-5: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['غَ', 'اَ', 'عَ', 'دَ', 'غَ', 'عَ'],
      ['ثَ', 'عَ', 'غَ', 'سَ', 'عَ', 'شَ'],
      ['حَ', 'عَ', 'رَ', 'غَ', 'صَ', 'عَ'],
      ['عَ', 'ظَ', 'غَ', 'ذَ', 'تَ', 'عَ'],
      ['غَ', 'ضَ', 'عَ', 'بَ', 'غَ', 'ضَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 18, data: _data);
  }
}