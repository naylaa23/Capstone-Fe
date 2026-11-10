import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro12Screen extends StatelessWidget {
  const Iqro12Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul (urutan baca dari kanan: sin, syin)
      ['سَ', 'شَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['سَ', 'اَ', 'شَ', 'سَ', 'زَ', 'شَ'],
      ['سَ', 'ذَ', 'شَ', 'رَ', 'سَ', 'ذَ'],
      ['زَ', 'حَ', 'خَ', 'شَ', 'بَ', 'سَ'],
      ['دَ', 'سَ', 'شَ', 'اَ', 'رَ', 'حَ'],
      ['ذَ', 'خَ', 'زَ', 'اَ', 'سَ', 'شَ'],
      ['خَ', 'سَ', 'زَ', 'جَ', 'شَ', 'سَ'],
      ['ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 12, data: _data);
  }
}