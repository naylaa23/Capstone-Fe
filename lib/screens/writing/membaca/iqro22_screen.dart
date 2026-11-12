import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro22Screen extends StatelessWidget {
  const Iqro22Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    hurufPerBalok: 3, // garis vertikal setiap 3 huruf (3 balok per baris)
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['لَ'],
      // 1-4: tiga balok x tiga huruf, dibaca dari kanan ke kiri.
      // Urutan tiap baris: balok kanan, balok tengah, balok kiri.
      ['قَ', 'لَ', 'بَ', 'جَ', 'عَ', 'لَ', 'خَ', 'لَ', 'طَ'],
      ['ذَ', 'كَ', 'رَ', 'غَ', 'لَ', 'ظَ', 'قَ', 'فَ', 'صَ'],
      ['حَ', 'لَ', 'فَ', 'دَ', 'غَ', 'سَ', 'شَ', 'كَ', 'لَ'],
      ['ضَ', 'رَ', 'عَ', 'زَ', 'تَ', 'ظَ', 'كَ', 'لَ', 'لَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['طَ', 'ظَ', 'عَ', 'غَ', 'فَ', 'قَ', 'كَ', 'لَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 22, data: _data);
  }
}