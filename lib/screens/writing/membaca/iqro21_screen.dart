import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro21Screen extends StatelessWidget {
  const Iqro21Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    // Garis vertikal setiap 3 huruf: tiap baris bergaris jadi 3 balok
    hurufPerBalok: 3,
    // Baris 1 (satu baris utuh) dan baris 5-7 (deretan huruf berurutan)
    // tanpa garis vertikal
    barisTanpaPembagi: {1, 5, 6, 7},
    baris: [
      // 0: baris judul
      ['كَ'],
      // 1: satu baris utuh (8 huruf), tanpa garis vertikal
      ['كَ', 'قَ', 'كَ', 'خَ', 'قَ', 'خَ', 'كَ', 'قَ'],
      // 2-4: baris bergaris, semuanya 9 huruf = 3 balok x 3 huruf.
      // Dibaca dari kanan ke kiri: balok kanan, tengah, kiri.
      ['ضَ', 'حَ', 'كَ', 'عَ', 'طَ', 'فَ', 'شَ', 'كَ', 'رَ'],
      ['جَ', 'كَ', 'تَ', 'قَ', 'كَ', 'فَ', 'ذَ', 'غَ', 'سَ'],
      ['صَ', 'دَ', 'ثَ', 'غَ', 'فَ', 'كَ', 'زَ', 'كَ', 'طَ'],
      // 5-7: deretan huruf berurutan, tanpa garis vertikal
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ'],
      ['رَ', 'زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ'],
      ['عَ', 'غَ', 'فَ', 'قَ', 'كَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 21, data: _data);
  }
}