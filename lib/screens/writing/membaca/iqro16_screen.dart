import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro16Screen extends StatelessWidget {
  const Iqro16Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: tha, zha)
      ['طَ', 'ظَ'],
      // 1-5: baris isi dengan garis tengah, dibaca dari kanan ke kiri
      ['ظَ', 'اَ', 'طَ', 'بَ', 'ظَ', 'طَ'],
      ['سَ', 'ضَ', 'ظَ', 'صَ', 'دَ', 'ظَ'],
      ['شَ', 'اَ', 'ظَ', 'سَ', 'رَ', 'طَ'],
      ['ثَ', 'ضَ', 'تَ', 'ظَ', 'زَ', 'خَ'],
      ['صَ', 'دَ', 'شَ', 'ضَ', 'ظَ', 'طَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 16, data: _data);
  }
}