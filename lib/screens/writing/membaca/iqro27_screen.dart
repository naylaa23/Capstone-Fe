import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro27Screen extends StatelessWidget {
  const Iqro27Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['يَ'],
      // 1-4: baris isi dengan garis tengah (semuanya 9 huruf),
      // dibaca dari kanan ke kiri
      ['ضَ', 'يَ', 'رَ', 'يَ', 'حَ', 'ضَ', 'يَ', 'زَ', 'نَ'],
      ['سَ', 'يَ', 'غَ', 'يَ', 'وَ', 'كَ', 'لَ', 'هَ', 'خَ'],
      ['طَ', 'هَ', 'ظَ', 'شَ', 'يَ', 'عَ', 'يَ', 'وَ', 'قَ'],
      ['دَ', 'يَ', 'يَ', 'ذَ', 'ثَ', 'يَ', 'مَ', 'هَ', 'يَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ', 'وَ', 'هَ', 'يَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 27, data: _data);
  }
}