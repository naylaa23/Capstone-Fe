import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro20Screen extends StatelessWidget {
  const Iqro20Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: fa, qaf)
      ['فَ', 'قَ'],
      // 1-4: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['قَ', 'بَ', 'ضَ', 'قَ', 'طَ', 'فَ'],
      ['ثَ', 'عَ', 'ظَ', 'فَ', 'قَ', 'سَ'],
      ['حَ', 'ذَ', 'خَ', 'قَ', 'صَ', 'عَ'],
      ['ضَ', 'غَ', 'شَ', 'فَ', 'عَ', 'قَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['طَ', 'ظَ', 'عَ', 'غَ', 'فَ', 'قَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 20, data: _data);
  }
}