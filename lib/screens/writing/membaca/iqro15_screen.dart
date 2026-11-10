import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro15Screen extends StatelessWidget {
  const Iqro15Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul
      ['طَ'],
      // 1-5: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['طَ', 'اَ', 'ضَ', 'زَ', 'طَ', 'سَ', 'حَ', 'جَ'],
      ['تَ', 'صَ', 'ضَ', 'ذَ', 'طَ', 'سَ', 'زَ', 'دَ'],
      ['دَ', 'ضَ', 'صَ', 'سَ', 'رَ', 'طَ', 'شَ', 'ثَ'],
      ['شَ', 'خَ', 'طَ', 'حَ', 'ذَ', 'ضَ', 'صَ', 'بَ'],
      ['رَ', 'ذَ', 'جَ', 'طَ', 'ثَ', 'اَ', 'سَ', 'شَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['سَ', 'خَ', 'طَ', 'اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 15, data: _data);
  }
}