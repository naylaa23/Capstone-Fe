import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro16Screen extends StatelessWidget {
  const Iqro16Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    hurufPerBalok: 3, // garis vertikal setiap 3 huruf = 3 balok
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: tha, zha)
      ['طَ', 'ظَ'],
      // 1-5: baris isi, semuanya 9 huruf = 3 balok x 3 huruf
      ['ظَ', 'اَ', 'طَ', 'بَ', 'طَ', 'ظَ', 'ذَ', 'حَ', 'ظَ'],
      ['ذَ', 'حَ', 'طَ', 'ضَ', 'صَ', 'دَ', 'ظَ', 'ضَ', 'سَ'],
      ['طَ', 'خَ', 'زَ', 'صَ', 'رَ', 'سَ', 'ظَ', 'اَ', 'شَ'],
      ['ظَ', 'ضَ', 'تَ', 'ضَ', 'خَ', 'زَ', 'ضَ', 'رَ', 'ثَ'],
      ['ظَ', 'طَ', 'شَ', 'ضَ', 'طَ', 'جَ', 'شَ', 'دَ', 'صَ'],
      // 6-7: deretan huruf berurutan, tanpa garis vertikal
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 16, data: _data);
  }
}