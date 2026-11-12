import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro26Screen extends StatelessWidget {
  const Iqro26Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    hurufPerBalok: 3,
    // Tiga baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {5, 6, 7},
    baris: [
      // 0: baris judul
      ['هَ'],
      // 1-4: baris isi dengan garis tengah (semuanya 9 huruf),
      // dibaca dari kanan ke kiri
      ['هَ', 'مَ', 'شَ', 'جَ', 'هَ', 'دَ', 'وَ', 'مَ', 'هَ'],
      ['فَ', 'خَ', 'عَ', 'هَ', 'رَ', 'طَ', 'هَ', 'وَ', 'ضَ'],
      ['وَ', 'هَ', 'ظَ', 'كَ', 'مَ', 'نَ', 'زَ', 'هَ', 'قَ'],
      ['سَ', 'هَ', 'لَ', 'هَ', 'جَ', 'صَ', 'ذَ', 'هَ', 'هَ'],
      // 5: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['عَ', 'غَ', 'فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ', 'وَ', 'هَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 26, data: _data);
  }
}