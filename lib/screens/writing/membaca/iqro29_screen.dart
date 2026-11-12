import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro29Screen extends StatelessWidget {
  const Iqro29Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    // Tidak ada baris judul. Semua baris isi memakai garis vertikal,
    // dibagi 3 balok per baris (tiap balok 3 huruf).
    hurufPerBalok: 3,
    baris: [
      // Semua baris harus 9 huruf supaya garisnya lurus.
      // Dibaca dari kanan ke kiri: balok kanan, tengah, kiri.
      ['بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ'],
      ['زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ'],
      ['فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ', 'وَ', 'هَ', 'يَ'],
      ['حَ', 'ءَ', 'اَ', 'يَ', 'بَ', 'لَ', 'نَ', 'وَ', 'مَ'],
      ['بَ', 'ثَ', 'جَ', 'حَ', 'ذَ', 'دَ', 'رَ', 'زَ', 'سَ'],
      ['رَ', 'ذَ', 'دَ', 'خَ', 'حَ', 'جَ', 'ثَ', 'تَ', 'بَ'],
      ['غَ', 'عَ', 'ظَ', 'طَ', 'ضَ', 'صَ', 'شَ', 'سَ', 'زَ'],
      ['يَ', 'هَ', 'وَ', 'نَ', 'مَ', 'لَ', 'كَ', 'قَ', 'فَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 29, data: _data);
  }
}