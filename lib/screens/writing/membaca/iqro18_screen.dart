import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro18Screen extends StatelessWidget {
  const Iqro18Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    hurufPerBalok: 3, // garis vertikal setiap 3 huruf = 3 balok
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: ain, ghain)
      ['عَ', 'غَ'],
      // 1-5: baris isi, semuanya 9 huruf = 3 balok x 3 huruf
      ['غَ', 'اَ', 'عَ', 'دَ', 'غَ', 'ظَ', 'عَ', 'طَ', 'غَ'],
      ['ثَ', 'عَ', 'ظَ', 'جَ', 'غَ', 'ظَ', 'سَ', 'طَ', 'عَ'],
      ['حَ', 'رَ', 'ظَ', 'شَ', 'غَ', 'طَ', 'صَ', 'رَ', 'عَ'],
      ['زَ', 'خَ', 'ظَ', 'ذَ', 'عَ', 'ضَ', 'تَ', 'غَ', 'صَ'],
      ['شَ', 'رَ', 'ظَ', 'طَ', 'عَ', 'ظَ', 'بَ', 'غَ', 'صَ'],
      // 6-7: deretan huruf berurutan, tanpa garis vertikal
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ'],
      ['سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 18, data: _data);
  }
}