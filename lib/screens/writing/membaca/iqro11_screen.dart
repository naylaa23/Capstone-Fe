import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro11Screen extends StatelessWidget {
  const Iqro11Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul
      ['سَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['زَ', 'اَ', 'سَ', 'زَ', 'رَ', 'سَ'],
      ['سَ', 'خَ', 'ذَ', 'حَ', 'سَ', 'دَ'],
      ['سَ', 'خَ', 'ثَ', 'جَ', 'زَ', 'رَ'],
      ['سَ', 'بَ', 'تَ', 'ذَ', 'رَ', 'سَ'],
      ['سَ', 'خَ', 'ذَ', 'زَ', 'حَ', 'دَ'],
      ['سَ', 'جَ', 'ثَ', 'اَ', 'بَ', 'تَ'],
      ['ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ', 'سَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 11, data: _data);
  }
}