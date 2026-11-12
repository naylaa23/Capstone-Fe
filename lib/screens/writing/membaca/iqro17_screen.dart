import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro17Screen extends StatelessWidget {
  const Iqro17Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    hurufPerBalok: 3, // garis vertikal setiap 3 huruf = 3 balok
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul
      ['عَ'],
      // 1-5: baris isi, semuanya 9 huruf = 3 balok x 3 huruf
      ['ظَ', 'اَ', 'عَ', 'تَ', 'عَ', 'رَ', 'بَ', 'عَ', 'طَ'],
      ['صَ', 'عَ', 'زَ', 'صَ', 'عَ', 'ضَ', 'دَ', 'حَ', 'ظَ'],
      ['بَ', 'عَ', 'ثَ', 'سَ', 'عَ', 'ظَ', 'شَ', 'طَ', 'عَ'],
      ['جَ', 'خَ', 'ذَ', 'ضَ', 'عَ', 'شَ', 'زَ', 'اَ', 'ضَ'],
      ['عَ', 'جَ', 'ظَ', 'دَ', 'طَ', 'ضَ', 'طَ', 'عَ', 'طَ'],
      // 6-7: deretan huruf berurutan, tanpa garis vertikal
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 17, data: _data);
  }
}