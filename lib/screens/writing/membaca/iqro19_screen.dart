import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro19Screen extends StatelessWidget {
  const Iqro19Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    hurufPerBalok: 3, // garis vertikal setiap 3 huruf = 3 balok
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul
      ['فَ'],
      // 1-5: baris isi, semuanya 9 huruf = 3 balok x 3 huruf
      ['فَ', 'اَ', 'غَ', 'فَ', 'عَ', 'ضَ', 'غَ', 'فَ', 'صَ'],
      ['فَ', 'تَ', 'حَ', 'غَ', 'جَ', 'زَ', 'حَ', 'فَ', 'ظَ'],
      ['طَ', 'عَ', 'دَ', 'صَ', 'فَ', 'غَ', 'شَ', 'خَ', 'ضَ'],
      ['سَ', 'عَ', 'ظَ', 'خَ', 'فَ', 'ذَ', 'شَ', 'غَ', 'ضَ'],
      ['فَ', 'زَ', 'عَ', 'ثَ', 'غَ', 'طَ', 'ظَ', 'فَ', 'رَ'],
      // 6-7: deretan huruf berurutan, tanpa garis vertikal
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ'],
      ['سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ', 'فَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 19, data: _data);
  }
}