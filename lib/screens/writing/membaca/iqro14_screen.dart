import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro14Screen extends StatelessWidget {
  const Iqro14Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: shad, dhad)
      ['صَ', 'ضَ'],
      // 1-5: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['صَ', 'اَ', 'ضَ', 'صَ', 'حَ', 'رَ', 'ضَ', 'صَ'],
      ['شَ', 'اَ', 'ضَ', 'شَ', 'خَ', 'ضَ', 'رَ', 'بَ'],
      ['صَ', 'حَ', 'ثَ', 'صَ', 'دَ', 'زَ', 'دَ', 'شَ'],
      ['نَ', 'صَ', 'حَ', 'رَ', 'صَ', 'دَ', 'ضَ', 'ذَ'],
      ['غَ', 'صَ', 'حَ', 'زَ', 'ضَ', 'جَ', 'سَ', 'اَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['صَ', 'رَ', 'ضَ', 'اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['ذَ', 'رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 14, data: _data);
  }
}