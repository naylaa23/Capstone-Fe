import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro23Screen extends StatelessWidget {
  const Iqro23Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['مَ'],
      // 1-4: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['غَ', 'مَ', 'ضَ', 'لَ', 'مَ', 'سَ', 'جَ', 'مَ', 'عَ'],
      ['فَ', 'رَ', 'ضَ', 'مَ', 'رَ', 'خَ', 'لَ', 'مَ', 'طَ'],
      ['صَ', 'مَ', 'دَ', 'ثَ', 'ظَ', 'ذَ', 'مَ', 'زَ', 'قَ'],
      ['شَ', 'مَ', 'لَ', 'فَ', 'كَ', 'حَ', 'غَ', 'مَ', 'مَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['عَ', 'غَ', 'فَ', 'قَ', 'كَ', 'لَ', 'مَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 23, data: _data);
  }
}