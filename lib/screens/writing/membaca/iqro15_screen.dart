import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro15Screen extends StatelessWidget {
  const Iqro15Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    hurufPerBalok: 3, // garis vertikal setiap 3 huruf = 3 balok
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul
      ['طَ'],
      // 1-5: baris isi, semuanya 9 huruf = 3 balok x 3 huruf
      ['طَ', 'اَ', 'ضَ', 'شَ', 'طَ', 'زَ', 'حَ', 'جَ', 'طَ'],
      ['تَ', 'صَ', 'ضَ', 'ذَ', 'طَ', 'سَ', 'زَ', 'دَ', 'طَ'],
      ['دَ', 'ضَ', 'صَ', 'طَ', 'رَ', 'سَ', 'شَ', 'ضَ', 'ثَ'],
      ['طَ', 'خَ', 'شَ', 'ذَ', 'حَ', 'طَ', 'ضَ', 'صَ', 'بَ'],
      ['ذَ', 'رَ', 'طَ', 'ضَ', 'زَ', 'جَ', 'ثَ', 'اَ', 'شَ'],
      // 6-7: deretan huruf berurutan, tanpa garis vertikal
      ['سَ', 'خَ', 'طَ', 'اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ'],
      ['دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 15, data: _data);
  }
}