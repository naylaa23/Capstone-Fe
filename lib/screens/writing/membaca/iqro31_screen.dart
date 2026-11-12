import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro31Screen extends StatelessWidget {
  const Iqro31Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    // Tidak ada baris judul. Semua baris tanpa garis tengah
    // (hanya garis antar baris).
    barisTanpaPembagi: {0, 1, 2, 3, 4, 5},
    baris: [
      // 0: alif sampai za, dibaca dari kanan ke kiri
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'خَ', 'دَ', 'ذَ', 'رَ', 'زَ'],
      // 1: sin sampai ghain
      ['سَ', 'شَ', 'صَ', 'ضَ', 'طَ', 'ظَ', 'عَ', 'غَ'],
      // 2: fa sampai ya
      ['فَ', 'قَ', 'كَ', 'لَ', 'مَ', 'نَ', 'وَ', 'هَ', 'ءَ', 'يَ'],
      // 3: ya sampai fa (urutan terbalik)
      ['يَ', 'ءَ', 'هَ', 'وَ', 'نَ', 'مَ', 'لَ', 'كَ', 'قَ', 'فَ'],
      // 4: ghain sampai sin (urutan terbalik)
      ['غَ', 'عَ', 'ظَ', 'طَ', 'ضَ', 'صَ', 'شَ', 'سَ'],
      // 5: za sampai alif (urutan terbalik)
      ['زَ', 'رَ', 'ذَ', 'دَ', 'خَ', 'حَ', 'جَ', 'ثَ', 'تَ', 'بَ', 'اَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 31, data: _data);
  }
}