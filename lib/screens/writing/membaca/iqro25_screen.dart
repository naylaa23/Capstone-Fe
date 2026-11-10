import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro25Screen extends StatelessWidget {
  const Iqro25Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['وَ'],
      // 1-4: baris isi dengan garis tengah (semuanya 9 huruf),
      // dibaca dari kanan ke kiri
      ['وَ', 'زَ', 'رَ', 'وَ', 'لَ', 'غَ', 'دَ', 'وَ', 'مَ'],
      ['فَ', 'وَ', 'طَ', 'نَ', 'قَ', 'وَ', 'مَ', 'ظَ', 'جَ'],
      ['كَ', 'وَ', 'نَ', 'سَ', 'كَ', 'تَ', 'خَ', 'وَ', 'صَ'],
      ['شَ', 'وَ', 'لَ', 'ذَ', 'حَ', 'ضَ', 'وَ', 'نَ', 'وَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['عَ', 'غَ', 'فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ', 'وَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 25, data: _data);
  }
}