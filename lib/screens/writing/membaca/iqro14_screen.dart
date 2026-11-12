import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro14Screen extends StatelessWidget {
  const Iqro14Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    // Garis vertikal setiap 3 huruf: tiap baris isi jadi 3 balok
    hurufPerBalok: 3,
    // Dua baris terakhir (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {6, 7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: shad, dhad)
      ['صَ', 'ضَ'],
      // 1-5: baris isi, semuanya 9 huruf = 3 balok x 3 huruf.
      // Dibaca dari kanan ke kiri: balok kanan, tengah, kiri.
      ['صَ', 'اَ', 'ضَ', 'رَ', 'ضَ', 'حَ', 'ضَ', 'صَ', 'اَ'],
      ['شَ', 'اَ', 'ضَ', 'زَ', 'خَ', 'شَ', 'ضَ', 'رَ', 'بَ'],
      ['صَ', 'حَ', 'ثَ', 'صَ', 'دَ', 'زَ', 'دَ', 'شَ', 'ضَ'],
      ['سَ', 'حَ', 'ذَ', 'دَ', 'صَ', 'رَ', 'ضَ', 'تَ', 'ذَ'],
      ['ثَ', 'خَ', 'زَ', 'ذَ', 'جَ', 'ضَ', 'سَ', 'اَ', 'شَ'],
      // 6: deretan huruf berurutan, satu baris utuh tanpa garis vertikal
      ['صَ', 'رَ', 'ضَ', 'اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ'],
      // 7: deretan huruf berurutan (dal sampai dhad)
      ['دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 14, data: _data);
  }
}