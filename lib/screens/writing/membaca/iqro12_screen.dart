import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro12Screen extends StatelessWidget {
  const Iqro12Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    // Garis vertikal setiap 3 huruf: tiap baris isi jadi 3 balok
    hurufPerBalok: 3,
    // Baris paling bawah (deretan huruf berurutan) tanpa garis vertikal
    barisTanpaPembagi: {7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: sin, syin)
      ['سَ', 'شَ'],
      // 1-6: baris isi, semuanya 9 huruf = 3 balok x 3 huruf.
      // Dibaca dari kanan ke kiri: balok kanan, tengah, kiri.
      ['سَ', 'اَ', 'شَ', 'سَ', 'زَ', 'شَ', 'سَ', 'ثَ', 'شَ'],
      ['سَ', 'ذَ', 'شَ', 'رَ', 'سَ', 'ذَ', 'شَ', 'ثَ', 'ذَ'],
      ['زَ', 'حَ', 'خَ', 'شَ', 'بَ', 'سَ', 'رَ', 'سَ', 'زَ'],
      ['دَ', 'سَ', 'شَ', 'اَ', 'رَ', 'حَ', 'سَ', 'شَ', 'دَ'],
      ['ذَ', 'خَ', 'زَ', 'اَ', 'سَ', 'شَ', 'رَ', 'زَ', 'ذَ'],
      ['خَ', 'سَ', 'زَ', 'جَ', 'شَ', 'سَ', 'دَ', 'بَ', 'اَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis vertikal
      ['ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 12, data: _data);
  }
}