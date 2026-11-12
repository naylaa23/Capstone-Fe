import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro24Screen extends StatelessWidget {
  const Iqro24Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    hurufPerBalok: 3,
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['نَ'],
      // 1-4: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['نَ', 'عَ', 'طَ', 'شَ', 'غَ', 'نَ', 'فَ', 'ظَ', 'نَ'],
      ['صَ', 'مَ', 'ضَ', 'قَ', 'رَ', 'نَ', 'خَ', 'لَ', 'قَ'],
      ['زَ', 'مَ', 'نَ', 'كَ', 'ذَ', 'بَ', 'جَ', 'نَ', 'دَ'],
      ['كَ', 'نَ', 'سَ', 'لَ', 'حَ', 'ظَ', 'مَ', 'نَ', 'نَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['عَ', 'غَ', 'فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 24, data: _data);
  }
}