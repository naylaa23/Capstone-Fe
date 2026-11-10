import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro29Screen extends StatelessWidget {
  const Iqro29Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    // Tidak ada baris judul. Baris deretan huruf berurutan (0, 1, 2 dan
    // 5, 6, 7) tanpa garis tengah; baris 3 dan 4 memakai garis tengah.
    barisTanpaPembagi: {0, 1, 2, 5, 6, 7},
    baris: [
      // 0-2: deretan huruf berurutan, dibaca dari kanan ke kiri
      ['بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ'],
      ['زَ', 'سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ'],
      ['فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ', 'وَ', 'هَ', 'يَ'],
      // 3-4: huruf campur dengan garis tengah (keduanya 6 huruf)
      ['حَ', 'ءَ', 'اَ', 'يَ', 'بَ', 'لَ'],
      ['بَ', 'ثَ', 'جَ', 'حَ', 'ذَ', 'دَ'],
      // 5-7: deretan huruf berurutan, urutan terbalik
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