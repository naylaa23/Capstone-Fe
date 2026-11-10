import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro13Screen extends StatelessWidget {
  const Iqro13Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul
      ['صَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['صَ', 'اَ', 'شَ', 'صَ', 'زَ', 'سَ', 'رَ', 'صَ'],
      ['صَ', 'ثَ', 'ذَ', 'سَ', 'شَ', 'صَ', 'رَ', 'تَ'],
      ['سَ', 'خَ', 'صَ', 'حَ', 'دَ', 'ذَ', 'زَ', 'صَ'],
      ['حَ', 'ذَ', 'رَ', 'شَ', 'بَ', 'صَ', 'سَ', 'جَ'],
      ['صَ', 'دَ', 'خَ', 'حَ', 'صَ', 'ذَ', 'زَ', 'رَ'],
      ['خَ', 'صَ', 'ثَ', 'تَ', 'بَ', 'اَ', 'حَ', 'جَ'],
      ['خَ', 'دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ', 'صَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 13, data: _data);
  }
}